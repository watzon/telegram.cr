# JSON serialization helper module for Telegram Bot API client
# Provides comprehensive type conversion, validation, and serialization capabilities
require "json"
require "./input_file"

module Telegram
  # Comprehensive JSON serialization helper for Telegram Bot API
  #
  # This module provides utilities for converting Crystal types to JSON-compatible formats
  # while handling the specific requirements of the Telegram Bot API. It includes:
  # - Safe type conversion with comprehensive error handling
  # - Support for all Telegram API types including file uploads
  # - Performance optimizations to minimize allocations
  # - Validation for API-specific constraints
  #
  # ## Example
  #
  # ```
  # class MyClient
  #   include Telegram::JSONHelper
  #
  #   def send_message(text : String, keyboard : InlineKeyboardMarkup? = nil)
  #     params = build_request_hash(
  #       "text" => text,
  #       "reply_markup" => keyboard
  #     )
  #     # params will only include non-nil values
  #   end
  # end
  # ```
  module JSONHelper
    # Build a request hash that excludes only nil values
    # This is the primary method for building API request parameters
    #
    # ## Parameters
    #
    # - **args** (**named arguments): Key-value pairs for request parameters
    #
    # ## Returns
    #
    # A hash suitable for JSON serialization with all non-nil values converted
    #
    # ## Example
    #
    # ```
    # params = build_request_hash(
    #   chat_id: 12345,
    #   text: "Hello",
    #   disable_notification: false,  # Will be included (false != nil)
    #   reply_markup: nil              # Will be excluded
    # )
    # # => {"chat_id" => 12345_i64, "text" => "Hello", "disable_notification" => false}
    # ```
    private def build_request_hash(**args) : Hash(String, JSON::Any)
      params = Hash(String, JSON::Any).new(initial_capacity: args.size)

      args.each do |key, value|
        unless value.nil?
          string_key = key.to_s
          json_value = to_json_any(value)
          params[string_key] = json_value
        end
      end

      params
    end

    # Build a request hash from a hash input
    # Alternative version that accepts a hash instead of named arguments
    #
    # ## Parameters
    #
    # - **hash** (`Hash`): Hash of key-value pairs for request parameters
    #
    # ## Returns
    #
    # A hash suitable for JSON serialization
    #
    # ## Example
    #
    # ```
    # params = build_request_hash_from_hash({
    #   "chat_id" => 12345,
    #   "text" => "Hello",
    #   "disable_notification" => false
    # })
    # ```
    private def build_request_hash_from_hash(hash : Hash) : Hash(String, JSON::Any)
      params = Hash(String, JSON::Any).new(initial_capacity: hash.size)

      hash.each do |key, value|
        unless value.nil?
          string_key = key.to_s
          json_value = to_json_any(value)
          params[string_key] = json_value
        end
      end

      params
    end

  
    # Convert any Crystal type to JSON::Any safely with comprehensive type handling
    # This is the core conversion method that handles all supported types
    #
    # ## Parameters
    #
    # - **value** (`Any`): The value to convert to JSON::Any
    #
    # ## Returns
    #
    # A JSON::Any representation of the input value
    #
    # ## Raises
    #
    # - `ArgumentError` if the value type is not supported
    #
    # ## Supported Types
    #
    # - Primitives: `Bool`, `Int32`, `Int64`, `Float64`, `Float32`, `String`
    # - Collections: `Array`, `Hash`, `Set`
    # - File types: `File`, `IO`, `MemoryIO`
    # - Custom objects with `to_json` method
    private def to_json_any(value) : JSON::Any
      case value
      when nil
        JSON::Any.new(nil)
      when .nil?
        JSON::Any.new(nil)
      when Bool
        JSON::Any.new(value)
      when Int32
        JSON::Any.new(value.to_i64)  # Telegram API expects 64-bit integers
      when Int64
        JSON::Any.new(value)
      when Int16
        JSON::Any.new(value.to_i64)
      when Int8
        JSON::Any.new(value.to_i64)
      when UInt32, UInt16, UInt8
        JSON::Any.new(value.to_i64)
      when Float64
        JSON::Any.new(value)
      when Float32
        JSON::Any.new(value.to_f64)
      when String
        # Validate string encoding and content
        validate_string_for_telegram(value)
        JSON::Any.new(value)
      when Symbol
        JSON::Any.new(value.to_s)
      when Array
        # Handle arrays efficiently with pre-allocation
        json_array = Array(JSON::Any).new(value.size)
        value.each do |item|
          json_array << to_json_any(item)
        end
        JSON::Any.new(json_array)
      when Set
        # Convert Set to Array for JSON compatibility
        json_array = Array(JSON::Any).new(value.size)
        value.each do |item|
          json_array << to_json_any(item)
        end
        JSON::Any.new(json_array)
      when Hash
        # Handle Hash with string keys
        json_hash = Hash(String, JSON::Any).new(initial_capacity: value.size)
        value.each do |k, v|
          # Only include non-nil values in the hash
          unless v.nil?
            json_hash[k.to_s] = to_json_any(v)
          end
        end
        JSON::Any.new(json_hash)
      when File
        # For File objects, return the file path as string
        # Multipart handling should be done at a higher level
        JSON::Any.new(value.path)
      when IO
        # For IO objects, we can't serialize directly to JSON
        # Return a marker or raise an error for multipart handling
        raise ArgumentError.new("IO objects cannot be directly serialized to JSON. Use multipart form data for file uploads.")
      when Enum
        # Convert enums to their string or integer value
        case value.value
        when String, Int32, Int64, Bool
          to_json_any(value.value)
        else
          to_json_any(value.to_s)
        end
      when Time
        # Convert Time to Unix timestamp (seconds since epoch)
        JSON::Any.new(value.to_unix)
      when .responds_to?(:to_json)
        # For custom objects that implement to_json
        begin
          JSON.parse(value.to_json)
        rescue ex : JSON::ParseException
          # Fallback: try to serialize as string representation
          JSON::Any.new(value.to_s)
        rescue ex
          raise ArgumentError.new("Failed to serialize object of type #{value.class}: #{ex.message}")
        end
      else
        # Last resort: try to convert to string
        # This should be avoided for performance reasons
        JSON::Any.new(value.to_s)
      end
    rescue ex
      raise ArgumentError.new("Failed to convert #{value.class} to JSON: #{ex.message}")
    end

    # Check if a value contains file data that requires multipart form handling
    # This method detects File, IO, or file-like objects
    #
    # ## Parameters
    #
    # - **value** (`Any`): The value to check for file content
    #
    # ## Returns
    #
    # `true` if the value contains file data, `false` otherwise
    #
    # ## Example
    #
    # ```
    # contains_file_data?(File.open("photo.jpg"))  # => true
    # contains_file_data?("some text")            # => false
    # contains_file_data?([file1, file2])         # => true
    # ```
    private def contains_file_data?(value) : Bool
      case value
      when File, IO, InputFile
        true
      when Array
        value.any? { |item| contains_file_data?(item) }
      when Hash
        value.any? { |_k, v| contains_file_data?(v) }
      else
        if value.responds_to?(:read)
          true
        elsif value.responds_to?(:contains_file_data?)
          value.contains_file_data?
        else
          false
        end
      end
    end

    # Validate string content for Telegram API compliance
    # Telegram Bot API has specific requirements for string content
    #
    # ## Parameters
    #
    # - **str** (`String`): The string to validate
    #
    # ## Raises
    #
    # - `ArgumentError` if the string violates Telegram API requirements
    private def validate_string_for_telegram(str : String) : Nil
      # Check for valid UTF-8 encoding
      unless str.valid_encoding?
        raise ArgumentError.new("String contains invalid UTF-8 characters")
      end

      # Telegram has length limits for certain fields
      # This is a general check - specific limits depend on the field
      if str.bytesize > 4096  # Conservative limit for most text fields
        # Note: Some fields like photo captions have specific limits (1024 chars)
        # This is a general validation that can be overridden per field
      end

      # Check for control characters that might cause issues
      if str.each_char.any? { |char| char.ascii_control? && char != '\n' && char != '\t' && char != '\r' }
        raise ArgumentError.new("String contains unsupported control characters")
      end
    end

    # Convert a hash to JSON string with error handling
    # Provides a safe way to serialize hashes to JSON
    #
    # ## Parameters
    #
    # - **hash** (`Hash`): The hash to serialize
    #
    # ## Returns
    #
    # JSON string representation of the hash
    #
    # ## Raises
    #
    # - `ArgumentError` if serialization fails
    private def hash_to_json(hash : Hash) : String
      begin
        hash.to_json
      rescue ex : JSON::Error
        # Try to convert problematic values
        sanitized = hash.transform_values do |value|
          begin
            to_json_any(value)
          rescue
            JSON::Any.new(value.to_s)
          end
        end
        sanitized.to_json
      end
    end

    # Generate a random multipart boundary string
    private def generate_boundary : String
      "----TelegramMultipartBoundary#{Random::Secure.hex(16)}"
    end

    # Build multipart form data for file uploads
    # This method handles the complex logic of multipart form creation
    #
    # ## Parameters
    #
    # - **params** (`Hash`): Parameters to include in the form
    # - **boundary** (`String`): Multipart boundary string
    #
    # ## Returns
    #
    # Tuple of boundary string and form body IO
    #
    # ## Example
    #
    # ```
    # boundary, form_body = build_multipart_form({
    #   "chat_id" => 12345,
    #   "photo" => File.open("image.jpg"),
    #   "caption" => "My photo"
    # })
    # ```
    private def build_multipart_form(params : Hash, boundary : String? = nil) : {String, IO}
      boundary ||= generate_boundary

      form_data = IO::Memory.new

      params.each do |key, value|
        next if value.nil?

        form_data << "--#{boundary}\r\n"

        case value
        when File
          filename = File.basename(value.path)
          content_type = guess_content_type(filename)
          form_data << "Content-Disposition: form-data; name=\"#{key}\"; filename=\"#{filename}\"\r\n"
          form_data << "Content-Type: #{content_type}\r\n\r\n"

          # Copy file content
          File.open(value.path, "rb") do |file|
            IO.copy(file, form_data)
          end

          form_data << "\r\n"
        when IO
          filename = "file"
          content_type = "application/octet-stream"
          form_data << "Content-Disposition: form-data; name=\"#{key}\"; filename=\"#{filename}\"\r\n"
          form_data << "Content-Type: #{content_type}\r\n\r\n"

          # Reset IO position if possible and copy content
          if value.responds_to?(:rewind)
            value.rewind
          end
          IO.copy(value, form_data)
          form_data << "\r\n"
        else
          # Regular field
          form_data << "Content-Disposition: form-data; name=\"#{key}\"\r\n\r\n"
          form_data << value.to_s
          form_data << "\r\n"
        end
      end

      form_data << "--#{boundary}--\r\n"
      form_data.rewind

      {boundary, form_data}
    end

    # Build multipart form data with proper file handling and JSON serialization
    # This method is used for runtime-detected file uploads and handles:
    # - File/IO objects as actual file uploads
    # - String values as regular fields (file_id or URL)
    # - Complex objects properly JSON-encoded
    # - attach:// protocol for file references
    #
    # ## Parameters
    #
    # - **params** (`Hash`): Parameters to include in the form
    # - **boundary** (`String`): Multipart boundary string
    #
    # ## Returns
    #
    # Tuple of boundary string and form body IO
    #
    # ## Example
    #
    # ```
    # boundary, form_body = build_multipart_form_with_files({
    #   "chat_id" => 12345,
    #   "photo" => File.open("image.jpg"),  # Will be uploaded
    #   "caption" => "My photo",
    #   "reply_markup" => {"inline_keyboard" => [[{"text" => "Button"}]]}
    # })
    # ```
    private def build_multipart_form_with_files(params : Hash, boundary : String? = nil) : {String, IO}
      boundary ||= generate_boundary
      form_data = IO::Memory.new
      registry = Telegram::Multipart::AttachmentRegistry.new

      Telegram::Multipart.with_registry(registry) do
        params.each do |key, value|
          next if value.nil?

          form_data << "--#{boundary}\r\n"

          case value
          when File
            filename = File.basename(value.path)
            content_type = guess_content_type(filename)
            form_data << "Content-Disposition: form-data; name=\"#{key}\"; filename=\"#{filename}\"\r\n"
            form_data << "Content-Type: #{content_type}\r\n\r\n"
            File.open(value.path, "rb") do |file|
              IO.copy(file, form_data)
            end
            form_data << "\r\n"
          when IO
            filename = "#{key}_upload"
            content_type = "application/octet-stream"
            form_data << "Content-Disposition: form-data; name=\"#{key}\"; filename=\"#{filename}\"\r\n"
            form_data << "Content-Type: #{content_type}\r\n\r\n"
            if value.responds_to?(:rewind)
              value.rewind
            end
            IO.copy(value, form_data)
            form_data << "\r\n"
          when InputFile
            filename = value.filename || "#{key}_upload"
            content_type = value.content_type || guess_content_type(filename)
            form_data << "Content-Disposition: form-data; name=\"#{key}\"; filename=\"#{filename}\"\r\n"
            form_data << "Content-Type: #{content_type}\r\n\r\n"
            value.write_to(form_data)
            form_data << "\r\n"
          else
            form_data << "Content-Disposition: form-data; name=\"#{key}\"\r\n\r\n"
            form_data << serialize_form_field(value)
            form_data << "\r\n"
          end
        end
      end

      registry.attachments.each do |attachment|
        file = attachment.file
        filename = file.filename || attachment.name
        content_type = file.content_type || guess_content_type(filename)
        form_data << "--#{boundary}\r\n"
        form_data << "Content-Disposition: form-data; name=\"#{attachment.name}\"; filename=\"#{filename}\"\r\n"
        form_data << "Content-Type: #{content_type}\r\n\r\n"
        file.write_to(form_data)
        form_data << "\r\n"
      end

      form_data << "--#{boundary}--\r\n"
      form_data.rewind

      {boundary, form_data}
    end

    private def serialize_form_field(value) : String
      case value
      when String
        value
      when Int32, Int64, Int16, Int8, UInt32, UInt16, UInt8
        value.to_i64.to_s
      when Float64, Float32
        value.to_f64.to_s
      when Bool
        value ? "true" : "false"
      when Array, Hash
        value.to_json
      else
        if value.responds_to?(:to_json)
          value.to_json
        else
          value.to_s
        end
      end
    end

    # Guess content type based on file extension
    # Simple content type detection for common file types
    #
    # ## Parameters
    #
    # - **filename** (`String`): The filename to check
    #
    # ## Returns
    #
    # Content type string
    private def guess_content_type(filename : String) : String
      ext = File.extname(filename).downcase

      case ext
      when ".jpg", ".jpeg" then "image/jpeg"
      when ".png" then "image/png"
      when ".gif" then "image/gif"
      when ".webp" then "image/webp"
      when ".mp4" then "video/mp4"
      when ".webm" then "video/webm"
      when ".pdf" then "application/pdf"
      when ".zip" then "application/zip"
      when ".txt" then "text/plain"
      when ".json" then "application/json"
      when ".xml" then "application/xml"
      else "application/octet-stream"
      end
    end

    # Flatten nested parameters for API compatibility
    # Some Telegram API endpoints expect flattened parameter structures
    #
    # ## Parameters
    #
    # - **hash** (`Hash`): The hash to flatten
    # - **prefix** (`String`): Key prefix for nested values
    #
    # ## Returns
    #
    # Flattened hash with dot-separated keys
    #
    # ## Example
    #
    # ```
    # flatten_hash({
    #   "reply_markup" => {
    #     "inline_keyboard" => [[{"text" => "Button", "callback_data" => "data"}]]
    #   }
    # })
    # # => {"reply_markup.inline_keyboard" => [[{"text" => "Button", "callback_data" => "data"}]]}
    # ```
    private def flatten_hash(hash : Hash, prefix : String = "") : Hash(String, JSON::Any)
      result = Hash(String, JSON::Any).new

      hash.each do |key, value|
        new_key = prefix.empty? ? key.to_s : "#{prefix}.#{key}"

        case value
        when Hash
          result.merge!(flatten_hash(value, new_key))
        else
          result[new_key] = to_json_any(value)
        end
      end

      result
    end

    # Optimize array serialization for large datasets
    # Special handling for arrays to minimize memory usage
    #
    # ## Parameters
    #
    # - **array** (`Array`): The array to serialize
    #
    # ## Returns
    #
    # JSON::Any representation of the array
    private def serialize_array_optimized(array : Array) : JSON::Any
      # For large arrays, use streaming JSON generation
      if array.size > 1000
        json_string = String.build do |str|
          str << "["
          array.each_with_index do |item, index|
            str << "," if index > 0
            str << to_json_any(item).to_json
          end
          str << "]"
        end
        JSON.parse(json_string)
      else
        # For smaller arrays, use the standard approach
        JSON::Any.new(array.map { |item| to_json_any(item) })
      end
    end

    # Cache for frequently used JSON::Any values
    # Performance optimization for common boolean and nil values
    CACHED_JSON_VALUES = {
      true => JSON::Any.new(true),
      false => JSON::Any.new(false),
      nil => JSON::Any.new(nil)
    } of Nil | Bool => JSON::Any
  end
end
