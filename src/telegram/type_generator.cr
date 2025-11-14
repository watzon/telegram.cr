module Telegram
  # Generates Crystal type definitions from API specification
  class TypeGenerator
    property output_dir : String
    property types_content : String

    # Map of Telegram API types to Crystal types
    TYPE_MAPPING = {
      "Integer"   => "Int32",
      "Float"     => "Float64",
      "String"    => "String",
      "Boolean"   => "Bool",
      "True"      => "Bool",
      "Array"     => "Array",
      "InputFile" => "File | IO",  # Telegram's InputFile type
    }

    # Rename map for conflicting type names
    TYPE_RENAMES = {
      "File" => "TelegramFile",
    }

    def initialize(@output_dir : String)
      @types_content = ""
    end

    # Main API types that should be classes (not structs)
    CLASS_TYPES = {
      "Message" => true,
      "Update" => true,
      "User" => true,
      "Chat" => true,
      "BotCommand" => true,
      "CallbackQuery" => true,
      "InlineQuery" => true,
      "ShippingQuery" => true,
      "PreCheckoutQuery" => true,
      "Poll" => true,
      "Game" => true,
      "Invoice" => true,
      "SuccessfulPayment" => true,
    }

    private def should_use_class?(type_name : String) : Bool
      CLASS_TYPES[type_name]? || false
    end

    def generate(spec : APISpec)
      # Extract types from the spec if available, otherwise infer from method fields
      types = spec.types || extract_types_from_methods(spec.methods)

      # Generate types as a string that can be included in other files
      @types_content = generate_types_content(spec, types)
    end

    # Generate types content as a string that can be included in other files
    def generate_types_content(spec : APISpec, types : Hash(String, APIType)) : String
      String.build do |str|
        str << "  # Telegram API Types - Auto-generated\n"
        str << "  # Generated from Telegram Bot API #{spec.version}\n"
        str << "  # Release date: #{spec.release_date}\n"
        str << "  #\n"
        str << "  # All types in a single file to avoid dependency issues\n\n"

        # Generate all types in the file
        types.each do |name, type|
          safe_name = TYPE_RENAMES[name]? || name

          # Add documentation
          str << "  # Telegram API type: #{name}\n"
          if desc = type.description
            desc.each do |line|
              str << "  # #{line}\n"
            end
          end

          # Use class for main API types, struct for others
          type_keyword = should_use_class?(name) ? "class" : "struct"
          str << "  #{type_keyword} #{safe_name}\n"
          str << "    include JSON::Serializable\n\n"

          # Add fields
          if fields = type.fields
            if fields.empty?
              str << "    # No fields defined for this type\n"
            else
              fields.each do |field|
                crystal_type = map_telegram_type_to_crystal(field)
                # Convert field name to snake_case for Crystal property
                snake_case_field_name = field.name.underscore

                # Add field documentation
                if field_desc = field.description
                  str << "    # #{field_desc}\n"
                end

                # Add JSON field annotation since API uses camelCase
                str << "    @[JSON::Field(key: \"#{field.name}\")]\n"

                # Determine if field is optional
                optional = field.required ? "" : "?"

                str << "    property #{snake_case_field_name} : #{crystal_type}#{optional}\n\n"
              end
            end
          else
            str << "    # No fields defined for this type\n"
          end

          str << "  end\n\n"
        end
      end
    end

    # Extract types from method parameters and return types when types hash is not available
    private def extract_types_from_methods(methods : Hash(String, APIMethod)) : Hash(String, APIType)
      types = Hash(String, APIType).new

      # Basic types that should always be available
      basic_types = [
        "Update", "Message", "User", "Chat", "MessageEntity", "PhotoSize"
      ]

      basic_types.each do |type_name|
        types[type_name] = APIType.new(type_name, [] of Field)
      end

      types
    end

    private def generate_single_types_file(spec : APISpec, types : Hash(String, APIType))
      content = String.build do |str|
        str << "# Telegram API Types - Auto-generated\n"
        str << "# Generated from Telegram Bot API #{spec.version}\n"
        str << "# Release date: #{spec.release_date}\n"
        str << "#\n"
        str << "# All types in a single file to avoid dependency issues\n\n"
        str << "require \"json\"\n\n"
        str << "module Telegram\n"

        # Generate all types in the file
        types.each do |name, type|
          safe_name = TYPE_RENAMES[name]? || name

          # Add documentation
          str << "  # Telegram API type: #{name}\n"
          if desc = type.description
            desc.each do |line|
              str << "  # #{line}\n"
            end
          end

          # Use class for main API types, struct for others
          type_keyword = should_use_class?(name) ? "class" : "struct"
          str << "  #{type_keyword} #{safe_name}\n"
          str << "    include JSON::Serializable\n\n"

          # Add fields
          if fields = type.fields
            if fields.empty?
              str << "    # No fields defined for this type\n"
            else
              fields.each do |field|
                crystal_type = map_telegram_type_to_crystal(field)
                # Convert field name to snake_case for Crystal property
                snake_case_field_name = field.name.underscore

                # Add field documentation
                if field_desc = field.description
                  str << "    # #{field_desc}\n"
                end

                # Add JSON field annotation since API uses camelCase
                str << "    @[JSON::Field(key: \"#{field.name}\")]\n"

                # Determine if field is optional
                optional = field.required ? "" : "?"

                str << "    property #{snake_case_field_name} : #{crystal_type}#{optional}\n\n"
              end
            end
          else
            str << "    # No fields defined for this type\n"
          end

          str << "  end\n\n"
        end

        str << "end\n"
      end

      filename = File.join(output_dir, "types", "types.cr")
      File.write(filename, content)
    end

    private def map_telegram_type_to_crystal(field : Field) : String
      if field.types.size == 1
        map_single_type(field.types.first)
      else
        # Handle union types
        mapped_types = field.types.map { |t| map_single_type(t) }
        mapped_types.join(" | ")
      end
    end

    private def map_single_type(type_str : String) : String
      # First check for basic type mappings
      if mapped = TYPE_MAPPING[type_str]?
        return mapped
      end

      # Handle "Array of X" patterns from API spec
      if type_str.includes?("Array of")
        return convert_array_notation(type_str)
      end

      # Check for renamed types
      TYPE_RENAMES[type_str]? || type_str
    end

    # Convert "Array of X" and "Array of Array of Y" to Crystal Array syntax
    private def convert_array_notation(type_str : String) : String
      # Handle patterns like "Array of Array of PhotoSize" -> "Array(Array(PhotoSize))"
      while type_str.includes?("Array of")
        type_str = type_str.gsub(/^Array of (.+)$/) do |match|
          rest = $1
          "Array(#{convert_array_notation(rest)})"
        end
      end
      # Also convert any remaining simple types inside arrays
      TYPE_MAPPING[type_str]? || type_str
    end
  end
end