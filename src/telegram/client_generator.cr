module Telegram
  # Generates HTTP client methods from API specification
  class ClientGenerator
    property output_dir : String

    # Rename map for conflicting type names (same as TypeGenerator)
    TYPE_RENAMES = {
      "File" => "TelegramFile",
    }

    def initialize(@output_dir : String)
    end

    def generate(spec : APISpec)
      content = String.build do |str|
        str << "# HTTP client for Telegram Bot API\n"
        str << "# Generated for Telegram Bot API #{spec.version} (#{spec.release_date})\n"
        str << "require \"http/client\"\n"
        str << "require \"mime/multipart\"\n"
        str << "require \"../json_helper\"\n"
        str << "require \"../response_parser\"\n"
        str << "require \"../http_client_wrapper\"\n\n"

        str << "module Telegram\n"
        str << "  module Client\n\n"

        # Generate the main client class
        str << generate_client_class(spec)

        str << "  end\n"
        str << "end\n"
      end

      # Write to file
      filename = File.join(output_dir, "client.cr")
      File.write(filename, content)
    end

    private def generate_client_class(spec : APISpec) : String
      String.build do |str|
        str << "    # Main API client for Telegram Bot API with enhanced HTTP features\n"
        str << "    # Features: persistent connections, retries, timeouts, proxy support\n"
        str << "    class APIClient\n"
        str << "      include Telegram::JSONHelper\n"
        str << "      include Telegram::ResponseParser\n\n"

        str << "      # Bot token from @BotFather\n"
        str << "      property token : String\n\n"

        str << "      # Base API URL\n"
        str << "      property api_url : String = \"https://api.telegram.org\"\n\n"

        str << "      # HTTP client configuration\n"
        str << "      property http_config : Telegram::HTTPClientConfig\n\n"

        str << "      # HTTP client wrapper\n"
        str << "      @http_client : Telegram::HTTPClientWrapper\n\n"

        str << "      # Initialize with default configuration\n"
        str << "      def initialize(@token : String, @api_url : String = \"https://api.telegram.org\")\n"
        str << "        @http_config = Telegram::HTTPClientConfig.new\n"
        str << "        @http_client = Telegram::HTTPClientWrapper.new(@http_config)\n"
        str << "      end\n\n"

        str << "      # Initialize with custom configuration\n"
        str << "      def initialize(@token : String, @api_url : String, @http_config : Telegram::HTTPClientConfig)\n"
        str << "        @http_client = Telegram::HTTPClientWrapper.new(@http_config)\n"
        str << "      end\n\n"

        str << "      # Initialize with custom HTTP client (for advanced use cases)\n"
        str << "      def initialize(@token : String, @api_url : String, custom_client : HTTP::Client, @http_config : Telegram::HTTPClientConfig = Telegram::HTTPClientConfig.new)\n"
        str << "        @http_client = Telegram::HTTPClientWrapper.new(custom_client, @http_config)\n"
        str << "      end\n\n"

        str << "      # Configure the HTTP client\n"
        str << "      def configure_http(&block : Telegram::HTTPClientConfig ->)\n"
        str << "        yield @http_config\n"
        str << "        # Recreate the HTTP client with new configuration\n"
        str << "        @http_client.close\n"
        str << "        @http_client = Telegram::HTTPClientWrapper.new(@http_config)\n"
        str << "      end\n\n"

        str << "      # Close the HTTP client and cleanup resources\n"
        str << "      def close\n"
        str << "        @http_client.close\n"
        str << "      end\n\n"

        # Generate methods for each API endpoint
        spec.methods.each do |method_name, method|
          str << generate_api_method(method)
          str << "\n"
        end

        str << "    end\n"
      end
    end

    private def generate_api_method(method : APIMethod) : String
      String.build do |str|
        # Add documentation
        str << "      # #{method.name}\n"
        desc = method.description
        if desc && !desc.empty?
          desc.each do |line|
            str << "      # #{line}\n"
          end
        end
        str << "      #\n"
        str << "      # Returns: #{method_returns_to_crystal(method.returns)}\n"
        str << "      # See: #{method.href}\n"
        # Convert method name to snake_case
        snake_case_method_name = method.name.underscore
        str << "      def #{snake_case_method_name}("

        # Add parameters - required first, then optional
        required_params = [] of String
        optional_params = [] of String

        if method.fields
          method.fields.not_nil!.each do |field|
            # Convert parameter name to snake_case
            param_name = field.name.underscore
            param_type = field_type_to_crystal(field)

            # Add default nil for optional parameters
            if field.required
              required_params << "#{param_name} : #{param_type}"
            else
              optional_params << "#{param_name} : #{param_type}? = nil"
            end
          end
        end

        params = required_params + optional_params

        str << params.join(", ")
        str << ") : #{method_returns_to_crystal(method.returns)}\n"

        # Generate method body
        str << generate_method_body(method, snake_case_method_name)
        str << "      end\n"
      end
    end

    private def generate_method_body(method : APIMethod, snake_case_method_name : String) : String
      return_type = method_returns_to_crystal(method.returns)

      # Check if method can potentially have file parameters
      can_have_files = method_can_have_files?(method)

      String.build do |str|
        # Collect all parameters for runtime file detection
        if fields = method.fields
          param_list = fields.map { |field| field.name.underscore }.join(", ")
          str << "        # Collect parameters for file detection\n"
          str << "        params_hash = {\n"
          fields.each do |field|
            snake_case_field_name = field.name.underscore
            str << "          \"#{field.name}\" => #{snake_case_field_name},\n"
          end
          str << "        }\n\n"
        end

        if can_have_files
          str << "        # Runtime detection: check if any parameters contain actual file data\n"
          str << "        has_files = contains_file_data?(params_hash)\n\n"

          str << "        if has_files\n"
          str << "          # Use multipart form data for file uploads\n"
          str << "          boundary, form_body = build_multipart_form_with_files(params_hash)\n"
          str << "          \n"
          str << "          # Make HTTP request with multipart form using enhanced client\n"
          str << "          url = \"\#{@api_url}/bot\#{@token}/#{method.name}\"\n"
          str << "          response = @http_client.post_multipart(url, {boundary, form_body})\n"
          str << "        else\n"
          str << "          # Use JSON request when no files are present\n"
          str << "          params = build_request_hash_from_hash(params_hash)\n"
          str << "          \n"
          str << "          # Make HTTP request using enhanced client\n"
          str << "          url = \"\#{@api_url}/bot\#{@token}/#{method.name}\"\n"
          str << "          response = @http_client.post(url,\n"
          str << "            headers: HTTP::Headers{\"Content-Type\" => \"application/json\"},\n"
          str << "            body: params.to_json\n"
          str << "          )\n"
          str << "        end\n"
        else
          str << "        # Build JSON request parameters (method never accepts files)\n"
          str << "        params = build_request_hash("
          if fields = method.fields
            str << "\n"
            fields.each do |field|
              snake_case_field_name = field.name.underscore
              str << "          #{snake_case_field_name}: #{snake_case_field_name},\n"
            end
          end
          str << "        )\n\n"
          str << "        # Make HTTP request using enhanced client\n"
          str << "        url = \"\#{@api_url}/bot\#{@token}/#{method.name}\"\n"
          str << "        response = @http_client.post(url,\n"
          str << "          headers: HTTP::Headers{\"Content-Type\" => \"application/json\"},\n"
          str << "          body: params.to_json\n"
          str << "        )\n"
        end

        str << "\n"
        str << "        # Parse response - extract and deserialize the result\n"
        str << "        json_response = JSON.parse(response.body)\n"
        str << "        unless json_response[\"ok\"]?.try(&.as_bool)\n"
        str << "          error_desc = json_response[\"description\"]?.try(&.as_s) || \"Unknown error\"\n"
        str << "          raise \"API Error: \" + error_desc\n"
        str << "        end\n"
        str << "        result_data = json_response[\"result\"]\n"
        str << "        #{method_returns_to_crystal(method.returns)}.from_json(result_data.to_json)\n"
      end
    end

    # Map API types to Crystal as_* methods for response parsing
    private def type_to_crystal_type(type : String) : String
      case type
      when "Bool"
        "bool"
      when "Int32", "Integer"
        "i"
      when "Int64"
        "i64"
      when "Float64", "Float"
        "f64"
      when "String"
        "s"
      when .starts_with?("Array(")
        "a"  # For arrays, return as JSON::Any array
      else
        # For complex types, deserialize from JSON
        "string"
      end
    end

    # Check if method can potentially have file parameters (runtime detection will be used)
    # This is based on the explicit list of methods that can accept files in Telegram Bot API
    private def method_can_have_files?(method : APIMethod) : Bool
      FILE_ACCEPTING_METHODS.includes?(method.name)
    end

    # Check if method has file parameters that require multipart form (legacy method)
    private def method_has_file_parameters?(method : APIMethod) : Bool
      return false unless fields = method.fields
      fields.any? { |field| is_file_parameter?(field) }
    end

    # Check if a field is a file parameter
    private def is_file_parameter?(field : Field) : Bool
      field.types.any? { |type| type == "InputFile" }
    end

    # List of Telegram Bot API methods that can accept file uploads
    # This follows the same approach as Tourmaline for better accuracy
    FILE_ACCEPTING_METHODS = [
      "sendPhoto",
      "sendAudio",
      "sendDocument",
      "sendVideo",
      "sendAnimation",
      "sendVoice",
      "sendVideoNote",
      "sendMediaGroup",
      "setChatPhoto",
      "setStickerSetThumbnail",
      "uploadStickerFile",
      "addStickerToSet",
      "createNewStickerSet",
      "replaceStickerInSet",
      "setWebhook"
    ] of String

    private def field_type_to_crystal(field : Field) : String
      if field.types.size == 1
        map_single_field_type(field.types.first)
      else
        # Handle union types
        mapped_types = field.types.map { |t| map_single_field_type(t) }
        mapped_types.join(" | ")
      end
    end

    private def map_single_field_type(type_str : String) : String
      case type_str
      when "Integer"
        "Int32"
      when "Float"
        "Float64"
      when "String"
        "String"
      when "Boolean"
        "Bool"
      when "True"
        "Bool"
      when "InputFile"
        "Telegram::InputFile | File | IO"
      else
        # Handle array types
        if type_str.starts_with?("Array of ")
          element_type = type_str["Array of ".size..-1]
          mapped_element = map_single_field_type(element_type)
          "Array(#{mapped_element})"
        else
          # Assume it's a custom Telegram type
          type_str
        end
      end
    end

    private def method_returns_to_crystal(returns : Array(String)) : String
      if returns.empty?
        "JSON::Any"
      elsif returns.size == 1
        return_type_to_crystal(returns.first)
      else
        "JSON::Any" # Default for complex returns
      end
    end

    private def return_type_to_crystal(return_type : String) : String
      case return_type
      when "Boolean"
        "Bool"
      when "Integer"
        "Int32"
      when "String"
        "String"
      when "Float"
        "Float64"
      when .includes?("Array of")
        # Handle "Array of Message" -> "Array(TelegramMessage)"
        element_type = return_type["Array of ".size..-1]
        safe_element_type = rename_type_if_needed(element_type)
        "Array(#{safe_element_type})"
      when .includes?("Array")
        # Generic array handling
        "Array(JSON::Any)"
      else
        # For complex types, use the renamed type if needed
        rename_type_if_needed(return_type)
      end
    end

    private def rename_type_if_needed(type_name : String) : String
      TYPE_RENAMES[type_name]? || type_name
    end

    end
end
