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
        str << "require \"mime/multipart\"\n\n"

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
        str << "    # Main API client for Telegram Bot API\n"
        str << "    class APIClient\n\n"

        str << "      # Bot token from @BotFather\n"
        str << "      property token : String\n\n"

        str << "      # Base API URL\n"
        str << "      property api_url : String = \"https://api.telegram.org\"\n\n"

        str << "      def initialize(@token : String, @api_url : String = \"https://api.telegram.org\")\n"
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

      # Check if method has file parameters that require multipart form
      has_files = method_has_file_parameters?(method)

      String.build do |str|
        if has_files
          str << "        # Build multipart form data for file upload\n"
          str << "        boundary = MIME::Multipart.generate_boundary\n"
          str << "        form_body = MIME::Multipart.build(boundary) do |builder|\n"

          if fields = method.fields
            fields.each do |field|
              snake_case_field_name = field.name.underscore
              if is_file_parameter?(field)
                str << "          if #{snake_case_field_name}\n"
                str << "            if #{snake_case_field_name}.is_a?(File)\n"
                str << "              file_io = #{snake_case_field_name}\n"
                str << "              filename = File.basename(#{snake_case_field_name}.path)\n"
                str << "            elsif #{snake_case_field_name}.is_a?(IO)\n"
                str << "              file_io = #{snake_case_field_name}\n"
                str << "              filename = \"file\"\n"
                str << "            else\n"
                str << "              file_io = IO::Memory.new(#{snake_case_field_name}.to_s)\n"
                str << "              filename = \"file\"\n"
                str << "            end\n"
                str << "            headers = HTTP::Headers{\n"
                str << "              \"Content-Disposition\" => \"form-data; name=\\\"#{field.name}\\\"; filename=\\\"#\{filename}\\\"\",\n"
                str << "              \"Content-Type\" => \"application/octet-stream\"\n"
                str << "            }\n"
                str << "            builder.body_part(headers, file_io)\n"
                str << "          end\n"
              else
                str << "          if #{snake_case_field_name}\n"
                str << "            headers = HTTP::Headers{\"Content-Disposition\" => \"form-data; name=\\\"#{field.name}\\\"\"}\n"
                str << "            builder.body_part(headers, #{snake_case_field_name}.to_s)\n"
                str << "          end\n"
              end
            end
          end

          str << "        end\n"
          str << "\n"
          str << "        # Make HTTP request with multipart form\n"
          str << "        url = \"\#{@api_url}/bot\#{@token}/#{method.name}\"\n"
          str << "        response = HTTP::Client.post(url,\n"
          str << "          headers: HTTP::Headers{\"Content-Type\" => \"multipart/form-data; boundary=\#{boundary}\"},\n"
          str << "          body: form_body\n"
          str << "        )\n"
        else
          str << "        # Build JSON request parameters\n"
          str << "        params = Hash(String, JSON::Any).new\n"

          if fields = method.fields
            fields.each do |field|
              snake_case_field_name = field.name.underscore
              str << "        params[\"#{field.name}\"] = JSON::Any.new(#{snake_case_field_name}) if #{snake_case_field_name}\n"
            end
          end

          str << "\n"
          str << "        # Make HTTP request\n"
          str << "        url = \"\#{@api_url}/bot\#{@token}/#{method.name}\"\n"
          str << "        response = HTTP::Client.post(url,\n"
          str << "          headers: HTTP::Headers{\"Content-Type\" => \"application/json\"},\n"
          str << "          body: params.to_json\n"
          str << "        )\n"
        end

        str << "\n"
        str << "        # Handle response\n"
        str << "        unless response.success?\n"
        str << "          raise \"Telegram API error: \#{response.status_code} - \#{response.body}\"\n"
        str << "        end\n"
        str << "\n"
        str << "        # Parse response\n"
        str << "        json_response = JSON.parse(response.body)\n"
        str << "\n"
        str << "        unless json_response[\"ok\"]?.try(&.as_bool)\n"
        str << "          error_desc = json_response[\"description\"]?.try(&.as_s) || \"Unknown error\"\n"
        str << "          raise \"Telegram API error: \#{error_desc}\"\n"
        str << "        end\n"
        str << "\n"

        # Generate appropriate parsing based on return type
        str << generate_response_parsing(return_type)
      end
    end

    # Check if method has file parameters that require multipart form
    private def method_has_file_parameters?(method : APIMethod) : Bool
      return false unless fields = method.fields
      fields.any? { |field| is_file_parameter?(field) }
    end

    # Check if a field is a file parameter
    private def is_file_parameter?(field : Field) : Bool
      field.types.any? { |type| type == "InputFile" }
    end

    private def generate_response_parsing(return_type : String) : String
      String.build do |str|
        case return_type
        when "Bool"
          str << "        json_response[\"result\"].as_bool\n"
        when "Int32"
          str << "        json_response[\"result\"].as_i\n"
        when "String"
          str << "        json_response[\"result\"].as_s\n"
        when "Float64"
          str << "        json_response[\"result\"].as_f\n"
        when .starts_with?("Array(")
          # Handle Array(SomeType)
          element_type = return_type["Array(".size..-2] # Remove "Array(" and trailing ")"
          if is_basic_type?(element_type)
            str << "        json_response[\"result\"].as_a.map { |item| item.as_#{basic_type_accessor(element_type)} }\n"
          else
            str << "        json_response[\"result\"].as_a.map { |item| #{element_type}.from_json(item.to_json) }\n"
          end
        when "JSON::Any"
          str << "        json_response[\"result\"]\n"
        else
          # Complex type - use from_json
          str << "        #{return_type}.from_json(json_response[\"result\"].to_json)\n"
        end
      end
    end

    private def is_basic_type?(type : String) : Bool
      ["Bool", "Int32", "Int64", "Float64", "String"].includes?(type)
    end

    private def basic_type_accessor(type : String) : String
      case type
      when "Bool" then "bool"
      when "Int32", "Int64" then "i64"
      when "Float64" then "f64"
      when "String" then "s"
      else "i"
      end
    end

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
        "File | IO"
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