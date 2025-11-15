# Enhanced HTTP client wrapper for Telegram Bot API
# Provides configurable, production-ready HTTP client with persistent connections, retries, and proper error handling
require "http/client"
require "mime/multipart"
require "openssl"
require "uri"
require "json"
require "log"
require "time"

module Telegram
  # Custom exception types for better error handling
  class TelegramError < Exception
    getter error_code : Int32?
    getter response_body : String?

    def initialize(message : String, @error_code : Int32? = nil, @response_body : String? = nil)
      super(message)
    end
  end

  class APIError < TelegramError
    def initialize(message : String, @error_code : Int32? = nil, @response_body : String? = nil)
      super(message, error_code, response_body)
    end
  end

  class NetworkError < TelegramError
    def initialize(message : String, @cause : Exception? = nil)
      super(message)
    end
  end

  class TimeoutError < NetworkError
    def initialize(message : String = "Request timed out")
      super(message)
    end
  end

  class RetryError < NetworkError
    def initialize(message : String, attempts : Int32)
      super("#{message} after #{attempts} attempts")
    end
  end

  # Configuration class for HTTP client settings
  class HTTPClientConfig
    # Connection settings
    property connect_timeout : Time::Span = 30.seconds
    property read_timeout : Time::Span = 60.seconds
    property keep_alive_timeout : Time::Span = 30.seconds

    # Pool settings
    property max_connections_per_host : Int32 = 10
    property pool_timeout : Time::Span = 5.seconds

    # Retry settings
    property max_retries : Int32 = 3
    property retry_delay : Time::Span = 1.second
    property retry_backoff_multiplier : Float64 = 2.0
    property retry_jitter : Float64 = 0.1

    # Proxy settings
    property proxy_host : String?
    property proxy_port : Int32?
    property proxy_user : String?
    property proxy_password : String?

    # SSL/TLS settings
    property verify_ssl : Bool = true
    property ssl_context : OpenSSL::SSL::Context::Client?

    # Headers
    property default_headers : HTTP::Headers = HTTP::Headers.new

    # User agent
    property user_agent : String = "TelegramBot/1.0 (Crystal)"

    # Logging
    property logger : Log = Log.for("telegram.http_client")
    property log_level : Log::Severity = Log::Severity::Info
    property log_requests : Bool = false
    property log_responses : Bool = false

    def initialize
    end

    # Create a configuration optimized for production bots
    def self.production
      config = new
      config.connect_timeout = 10.seconds
      config.read_timeout = 30.seconds
      config.max_retries = 5
      config.retry_delay = 500.milliseconds
      config.max_connections_per_host = 20
      config
    end

    # Create a configuration optimized for development/testing
    def self.development
      config = new
      config.max_retries = 1
      config.retry_delay = 100.milliseconds
      config.log_requests = true
      config.log_responses = true
      config
    end

    # Configure proxy settings
    def proxy(host : String, port : Int32, user : String? = nil, password : String? = nil)
      @proxy_host = host
      @proxy_port = port
      @proxy_user = user
      @proxy_password = password
      self
    end

    # Configure SSL/TLS
    def ssl(verify : Bool = true, context : OpenSSL::SSL::Context::Client? = nil)
      @verify_ssl = verify
      @ssl_context = context
      self
    end

    # Add default header
    def add_header(name : String, value : String)
      @default_headers[name] = value
      self
    end
  end

  # Enhanced HTTP client wrapper with production-ready features
  class HTTPClientWrapper
    private class ClientPool
      @max_size : Int32
      @builder : Proc(HTTP::Client)
      @mutex = Thread::Mutex.new
      @resource : Thread::ConditionVariable = Thread::ConditionVariable.new
      @available : Array(HTTP::Client) = [] of HTTP::Client
      @total : Int32 = 0
      @closed = false

      def initialize(max_size : Int32, &block : -> HTTP::Client)
        @max_size = {max_size, 1}.max
        @builder = block
      end

      def checkout : HTTP::Client
        @mutex.synchronize do
          loop do
            raise "HTTP client pool is closed" if @closed
            if client = @available.pop?
              return client
            elsif @total < @max_size
              @total += 1
              return @builder.call
            else
              @resource.wait(@mutex)
            end
          end
        end
      end

      def release(client : HTTP::Client)
        @mutex.synchronize do
          return if @closed
          @available << client
          @resource.signal
        end
      end

      def discard(client : HTTP::Client)
        begin
          client.close
        rescue
        end

        @mutex.synchronize do
          @total = {@total - 1, 0}.max
          @resource.signal
        end
      end

      def close
        clients = [] of HTTP::Client

        @mutex.synchronize do
          @closed = true
          clients.concat(@available)
          @available.clear
          @resource.broadcast
        end

        clients.each do |client|
          begin
            client.close
          rescue
          end
        end
      end

      def active? : Bool
        @mutex.synchronize { @total > 0 }
      end
    end

    @custom_client : HTTP::Client?
    @config : HTTPClientConfig
    @connection_mutex = Mutex.new
    @pool_mutex = Mutex.new
    @pools = Hash(String, ClientPool).new
    @logger : Log

    def initialize(@config : HTTPClientConfig = HTTPClientConfig.new)
      @logger = @config.logger
      @custom_client = nil
    end

    # Initialize with custom HTTP client
    def initialize(client : HTTP::Client, @config : HTTPClientConfig = HTTPClientConfig.new)
      @custom_client = client
      @logger = @config.logger
    end

    # Execute a POST request with automatic retry logic
    def post(url : String, headers : HTTP::Headers? = nil, body : String? = nil) : HTTP::Client::Response
      execute_request(:post, url, headers, body)
    end

    # Execute a GET request with automatic retry logic
    def get(url : String, headers : HTTP::Headers? = nil) : HTTP::Client::Response
      execute_request(:get, url, headers)
    end

    # Execute a PUT request with automatic retry logic
    def put(url : String, headers : HTTP::Headers? = nil, body : String? = nil) : HTTP::Client::Response
      execute_request(:put, url, headers, body)
    end

    # Execute a DELETE request with automatic retry logic
    def delete(url : String, headers : HTTP::Headers? = nil) : HTTP::Client::Response
      execute_request(:delete, url, headers)
    end

    # Execute a multipart POST request
    def post_multipart(url : String, multipart_data : {String, IO}, headers : HTTP::Headers? = nil) : HTTP::Client::Response
      boundary, io = multipart_data

      # Set multipart content type
      content_headers = (headers || HTTP::Headers.new).dup
      content_headers["Content-Type"] = "multipart/form-data; boundary=#{boundary}"

      execute_request(:post, url, content_headers, nil, io)
    end

    # Close the client and cleanup resources
    def close
      @connection_mutex.synchronize do
        if client = @custom_client
          client.close
          @custom_client = nil
        end
      end

      close_all_pools
    end

    # Check if client is connected
    def connected? : Bool
      return true if @custom_client

      @pool_mutex.synchronize do
        @pools.values.any?(&.active?)
      end
    end

    private def execute_request(method : Symbol, url : String, headers : HTTP::Headers? = nil, body : String? = nil, io : IO? = nil) : HTTP::Client::Response
      attempt = 0
      max_attempts = @config.max_retries + 1
      last_exception : Exception?

      while attempt < max_attempts
        attempt += 1

        begin
          request_headers = build_headers(headers)
          rewind_io(io)
          response = with_http_client(url) do |client|
            perform_request(client, method, url, request_headers, body, io)
          end

          log_response(response) if @config.log_responses

          # Check for HTTP errors
          unless response.success?
            handle_http_error(response)
          end

          return response
        rescue ex : IO::TimeoutError
          if attempt >= max_attempts
            raise TimeoutError.new("Request to #{url} timed out")
          end
          last_exception = ex
        rescue ex : OpenSSL::SSL::Error | Socket::Error | IO::Error
          if attempt >= max_attempts
            raise RetryError.new("Network error: #{ex.message}", attempt)
          end
          last_exception = ex
        rescue ex : Exception
          if attempt >= max_attempts || !should_retry?(ex)
            raise NetworkError.new("Unexpected error: #{ex.message}", ex)
          end
          last_exception = ex
        end

        # If we get here, we need to retry
        delay = calculate_retry_delay(attempt)
        @logger.warn { "Error on attempt #{attempt}/#{max_attempts}: #{last_exception.try(&.message)}. Retrying in #{delay}..." }
        sleep(delay)
      end

      # This should never be reached, but just in case
      raise NetworkError.new("Unexpected error during request execution")
    end

    private def with_http_client(url : String, &block : HTTP::Client -> HTTP::Client::Response)
      if client = @custom_client
        @connection_mutex.synchronize do
          block.call(client)
        end
      else
        pool = pool_for(url)
        http_client = pool.checkout

        begin
          response = block.call(http_client)
          pool.release(http_client)
          response
        rescue ex
          if should_discard_client?(ex)
            pool.discard(http_client)
          else
            pool.release(http_client)
          end
          raise ex
        end
      end
    end

    private def perform_request(client : HTTP::Client, method : Symbol, url : String, headers : HTTP::Headers, body : String?, io : IO?) : HTTP::Client::Response
      case method
      when :post
        if io
          client.post(url, headers: headers, body: io)
        else
          client.post(url, headers: headers, body: body)
        end
      when :get
        client.get(url, headers: headers)
      when :put
        client.put(url, headers: headers, body: body)
      when :delete
        client.delete(url, headers: headers)
      else
        raise ArgumentError.new("Unsupported HTTP method: #{method}")
      end
    end

    private def pool_for(url : String) : ClientPool
      uri = URI.parse(url)
      # Normalize to scheme://host:port so that pools are per origin
      normalized_uri = URI.parse("#{uri.scheme}://#{uri.host}:#{uri.port || default_port_for(uri.scheme)}")
      key = "#{normalized_uri.scheme}://#{normalized_uri.host}:#{normalized_uri.port}"

      @pool_mutex.synchronize do
        if pool = @pools[key]?
          pool
        else
          pool = ClientPool.new(@config.max_connections_per_host) do
            create_client_for_uri(normalized_uri)
          end
          @pools[key] = pool
          pool
        end
      end
    end

    private def default_port_for(scheme : String?) : Int32
      case scheme
      when "http" then 80
      else             443
      end
    end

    private def create_client_for_uri(uri : URI) : HTTP::Client
      client = HTTP::Client.new(uri)
      client.connect_timeout = @config.connect_timeout
      client.read_timeout = @config.read_timeout

      if uri.scheme == "https"
        ssl_context = @config.ssl_context || OpenSSL::SSL::Context::Client.new
        ssl_context.verify_mode = OpenSSL::SSL::VerifyMode::NONE unless @config.verify_ssl
      end

      # Proxy configuration placeholder (depends on Crystal version support)
      if proxy_host = @config.proxy_host
        # Implement proxy wiring once HTTP::Client supports it fully
        proxy_host
      end

      client
    end

    private def close_all_pools
      pools = [] of ClientPool

      @pool_mutex.synchronize do
        pools = @pools.values
        @pools = Hash(String, ClientPool).new
      end

      pools.each(&.close)
    end

    private def should_discard_client?(ex : Exception) : Bool
      case ex
      when IO::TimeoutError, IO::Error, Socket::Error, OpenSSL::SSL::Error
        true
      else
        false
      end
    end

    private def rewind_io(io : IO?)
      return unless io
      if io.responds_to?(:rewind)
        io.rewind
      end
    end

    private def build_headers(request_headers : HTTP::Headers?) : HTTP::Headers
      headers = @config.default_headers.dup
      headers["User-Agent"] = @config.user_agent

      if request_headers
        request_headers.each do |name, value|
          headers[name] = value
        end
      end

      headers
    end

    private def calculate_retry_delay(attempt : Int32) : Time::Span
      base_delay = @config.retry_delay * (@config.retry_backoff_multiplier ** (attempt - 1))

      # Add jitter to prevent thundering herd
      jitter = base_delay * @config.retry_jitter * (Random::DEFAULT.rand - 0.5)

      (base_delay + jitter).clamp(0.seconds, 60.seconds)
    end

    private def should_retry?(ex : Exception) : Bool
      # Don't retry on certain exceptions that won't resolve with retries
      case ex
      when ArgumentError, JSON::ParseException, TelegramError
        false
      else
        true
      end
    end

    private def handle_http_error(response : HTTP::Client::Response)
      begin
        json_response = JSON.parse(response.body)
        if json_response["ok"]?.try(&.as_bool) == false
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown API error"
          error_code = json_response["error_code"]?.try(&.as_i)
          raise APIError.new(error_desc, error_code, response.body)
        end
      rescue JSON::ParseException
        # Not a JSON response, treat as HTTP error
      end

      raise APIError.new(
        "HTTP error: #{response.status_code} #{response.status_message}",
        response.status_code,
        response.body
      )
    end

    private def log_response(response : HTTP::Client::Response)
      @logger.debug { "Response: #{response.status_code} #{response.status_message}" }
      @logger.debug { "Response body: #{response.body[0..Math.min(500, response.body.size - 1)]}..." } if response.body.size > 0
    end
  end
end
