require "json"
require "dexter"
require "db/pool"
require "http/client"
require "http_proxy"

require "./update_action"
require "./support/parsers"
require "./api/types"
require "./api/methods"
require "./config"
require "./helpers"
require "./error"

class Telegram::API
  @pool : DB::Pool(HTTP::Client)

  property token : String

  def initialize(@token : String)
    proxy = settings.proxy
    if proxy
      if uri = settings.proxy_uri
        proxy_uri = uri.is_a?(URI) ? uri : URI.parse(uri.starts_with?("http") ? uri : "http://#{uri}")
        proxy_host = proxy_uri.host
        proxy_port = proxy_uri.port
        proxy_user = proxy_uri.user if proxy_uri.user
        proxy_pass = proxy_uri.password if proxy_uri.password
      end

      if proxy_host && proxy_port
        proxy = HTTP::Proxy::Client.new(proxy_host, proxy_port, username: proxy_user, password: proxy_pass)
      end
    end

    @pool = DB::Pool(HTTP::Client).new(max_pool_size: settings.pool_capacity, initial_pool_size: settings.initial_pool_size, checkout_timeout: settings.pool_timeout) do
      client = HTTP::Client.new(URI.parse(settings.endpoint))
      client.set_proxy(proxy.dup) if proxy
      client
    end
  end

  # Send a raw request to the Bot API.
  def request(path : String, params : NamedTuple | Hash | Nil = nil)
    params ||= {} of String => String
    using_connection do |client|
      Log.with_context(path: path, params: params) do
        Log.debug { "sending request" }
      end

      if Helpers.includes_media?(params)
        config = Helpers.build_form_data_config(params)
        response = client.exec(**config, path: path)
      else
        config = Helpers.build_json_config(params)
        response = client.exec(**config, path: path)
      end

      if response.status.ok?
        response.body
      else
        result = JSON.parse(response.body)
        error = Error.from_message(result["description"].to_s)
        error.code = response.status_code
        raise error
      end
    end
  end

  # Sent a request to the Bot API and deserialize the response as `type`.
  def request(type : T.class, method : String, params : NamedTuple? | Hash? = nil) forall T
    path = ::File.join("/bot#{@token}", method)
    response = Response(T).from_json(request(path, params))
    response.result
  end

  private def settings
    Telegram.settings
  end

  protected def using_connection
    @pool.retry do
      @pool.checkout do |conn|
        yield conn
      end
    end
  end
end
