module Telegram
  # Generates Crystal type definitions from API specification
  class TypeGenerator
    property output_dir : String
    property types_content : String

    # Map of Telegram API types to Crystal types
    TYPE_MAPPING = {
      "Integer"   => "Int64", # Telegram uses 64-bit integers for IDs
      "Float"     => "Float64",
      "String"    => "String",
      "Boolean"   => "Bool",
      "True"      => "Bool",
      "Array"     => "Array",
      "InputFile" => "Telegram::InputFile | File | IO", # Telegram's InputFile type
      # Additional common Telegram types that might appear in specs
      "Integer32"    => "Int32",
      "Integer64"    => "Int64",
      "Timestamp"    => "Time",  # Unix timestamps
      "Seconds"      => "Int32", # Duration in seconds
      "Milliseconds" => "Int64", # Duration in milliseconds
      "Bytes"        => "Bytes", # Raw binary data
    }

    # Rename map for conflicting type names
    TYPE_RENAMES = {
      "File" => "TelegramFile",
    }

    # Fields that should use flexible integer types (Int32 | Int64) for compatibility
    # This follows Tourmaline's approach for API compatibility
    FLEXIBLE_INTEGER_FIELDS = {
      "chat_id"                 => true,
      "message_id"              => true,
      "user_id"                 => true,
      "from_user_id"            => true,
      "forward_from_message_id" => true,
      "reply_to_message_id"     => true,
      "migrate_to_chat_id"      => true,
      "migrate_from_chat_id"    => true,
      "super_group_id"          => true,
      "channel_id"              => true,
      "sender_chat_id"          => true,
      "forward_from_chat_id"    => true,
      "photo_size_file_id"      => true,
      "file_id"                 => true,
      "file_unique_id"          => true,
      "thumb_file_id"           => true,
      "video_file_id"           => true,
      "audio_file_id"           => true,
      "document_file_id"        => true,
      "sticker_file_id"         => true,
      "voice_file_id"           => true,
      "video_note_file_id"      => true,
      "animation_file_id"       => true,
      "mask_position_point"     => true,
      "x_shift"                 => true,
      "y_shift"                 => true,
      "scale"                   => true,
    }

    def initialize(@output_dir : String)
      @types_content = ""
    end

    # Main API types that should be classes (not structs)
    CLASS_TYPES = {
      "Message"           => true,
      "Update"            => true,
      "User"              => true,
      "Chat"              => true,
      "BotCommand"        => true,
      "CallbackQuery"     => true,
      "InlineQuery"       => true,
      "ShippingQuery"     => true,
      "PreCheckoutQuery"  => true,
      "Poll"              => true,
      "Game"              => true,
      "Invoice"           => true,
      "SuccessfulPayment" => true,
    }
    SKIP_TYPES = {
      "InputFile" => true,
    }

    private def should_use_class?(type_name : String) : Bool
      CLASS_TYPES[type_name]? || false
    end

    def generate(spec : APISpec)
      # Extract types from the spec if available, otherwise infer from method fields
      types = spec.types || extract_types_from_methods(spec.methods)

      # Validate the spec to ensure all types are supported
      validate_spec(spec)

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

        generate_type_definitions(str, types)
      end
    end

    # Extract types from method parameters and return types when types hash is not available
    private def extract_types_from_methods(methods : Hash(String, APIMethod)) : Hash(String, APIType)
      types = Hash(String, APIType).new

      # Basic types that should always be available
      basic_types = [
        "Update", "Message", "User", "Chat", "MessageEntity", "PhotoSize",
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

        generate_type_definitions(str, types)

        str << "end\n"
      end

      filename = File.join(output_dir, "types", "types.cr")
      File.write(filename, content)
    end

    private def generate_type_definitions(str : IO, types : Hash(String, APIType))
      types.each do |name, type|
        next if SKIP_TYPES[name]?
        safe_name = TYPE_RENAMES[name]? || name

        str << "  # Telegram API type: #{name}\n"
        if desc = type.description
          desc.each do |line|
            str << "  # #{line}\n"
          end
        end

        fields = type.fields.try { |arr| ordered_fields(arr) }
        has_fields = fields && !fields.empty?

        if should_use_class?(name)
          str << "  class #{safe_name}\n"
          str << "    include JSON::Serializable\n\n"

          if has_fields
            fields.not_nil!.each do |field|
              add_field_comment_and_property(str, field)
            end
            add_initializer(str, fields.not_nil!)
          else
            str << "    # No fields defined for this type\n"
            str << "    def initialize\n"
            str << "    end\n"
          end

          str << "  end\n\n"
        else
          build_record_type(str, safe_name, fields)
        end
      end
    end

    private def add_field_comment_and_property(str : IO, field : Field)
      crystal_type = map_telegram_type_to_crystal(field)
      name = field.name.underscore
      optional = field.required ? "" : "?"

      if field_desc = field.description
        str << "    # #{field_desc}\n"
      end
      str << "    @[JSON::Field(key: \"#{field.name}\")]\n"
      str << "    property #{name} : #{crystal_type}#{optional}\n\n"
    end

    private def add_initializer(str : IO, fields : Array(Field))
      params = fields.map do |field|
        crystal_type = map_telegram_type_to_crystal(field)
        optional = field.required ? "" : "?"
        default = field.required ? "" : " = nil"
        "      #{field.name.underscore} : #{crystal_type}#{optional}#{default}"
      end

      str << "    def initialize(\n"
      str << params.join(",\n")
      str << "\n    )\n"

      fields.each do |field|
        name = field.name.underscore
        str << "      @#{name} = #{name}\n"
      end

      str << "    end\n"
    end

    private def build_record_type(str : IO, safe_name : String, fields : Array(Field)?)
      if fields && !fields.empty?
        header = record_header(fields)
        str << "  record #{safe_name}#{header} do\n"
        str << "    include JSON::Serializable\n\n"
        add_record_instance_variables(str, fields)
      else
        str << "  record #{safe_name} do\n"
        str << "    include JSON::Serializable\n"
        str << "    # No fields defined for this type\n"
      end

      str << "  end\n\n"
    end

    private def record_header(fields : Array(Field)) : String
      parts = fields.map do |field|
        crystal_type = map_telegram_type_to_crystal(field)
        optional = field.required ? "" : "?"
        default = field.required ? "" : " = nil"
        "#{field.name.underscore} : #{crystal_type}#{optional}#{default}"
      end
      parts.empty? ? "" : ", " + parts.join(", ")
    end

    private def add_record_instance_variables(str : IO, fields : Array(Field))
      fields.each do |field|
        if field_desc = field.description
          str << "    # #{field_desc}\n"
        end

        crystal_type = map_telegram_type_to_crystal(field)
        optional = field.required ? "" : "?"

        str << "    @[JSON::Field(key: \"#{field.name}\")]\n"
        str << "    @#{field.name.underscore} : #{crystal_type}#{optional}\n\n"
      end
    end

    private def ordered_fields(fields : Array(Field)) : Array(Field)
      fields.sort_by do |field|
        field.required ? 0 : 1
      end
    end

    private def map_telegram_type_to_crystal(field : Field) : String
      if field.types.size == 1
        type_str = field.types.first
        if type_str.includes?(" or ")
          # Handle "or" expressions within a single type string
          parse_union_type(type_str, field.name).join(" | ")
        else
          map_single_type_with_field_override(type_str, field.name)
        end
      else
        # Handle multiple types as union
        parsed_types = field.types.flat_map do |type_str|
          if type_str.includes?(" or ")
            parse_union_type(type_str, field.name)
          else
            [map_single_type_with_field_override(type_str, field.name)]
          end
        end
        deduplicate_union_types(parsed_types).join(" | ")
      end
    end

    # Parse "A or B or C" expressions and return array of types
    private def parse_union_type(type_str : String, field_name : String) : Array(String)
      types = type_str.split(/\s+or\s+/).map(&.strip)
      deduplicated = deduplicate_union_types(types.map { |t| map_single_type_with_field_override(t, field_name) })
      deduplicated
    end

    # Deduplicate union types while preserving order
    private def deduplicate_union_types(types : Array(String)) : Array(String)
      seen = Set(String).new
      types.select { |t| seen.add?(t) }
    end

    private def map_single_type_with_field_override(type_str : String, field_name : String) : String
      # Handle field-specific overrides for flexible integer types
      if FLEXIBLE_INTEGER_FIELDS[field_name]? && (type_str == "Integer")
        return "Int32 | Int64"
      end

      map_single_type(type_str)
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

      # Handle "Array(X)" patterns
      if type_str.matches?(/^Array\(/)
        return convert_generic_array_notation(type_str)
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

    # Convert "Array(X)" patterns to Crystal Array syntax
    private def convert_generic_array_notation(type_str : String) : String
      if type_str.matches?(/^Array\((.+)\)$/)
        inner_type = $1
        mapped_inner = map_single_type(inner_type.strip)
        "Array(#{mapped_inner})"
      else
        type_str
      end
    end

    # Validate the API specification to ensure all field types are supported
    private def validate_spec(spec : APISpec) : Nil
      unsupported_types = Set(String).new

      # Validate method return types and parameter types
      spec.methods.each do |method_name, method|
        # Validate return types
        method.returns.each do |return_type|
          validate_type_string(return_type, unsupported_types, "method #{method_name} return")
        end

        # Validate parameter types
        if fields = method.fields
          fields.each do |field|
            field.types.each do |type|
              if type.includes?(" or ")
                type.split(/\s+or\s+/).each do |individual_type|
                  validate_type_string(individual_type.strip, unsupported_types, "method #{method_name} field #{field.name}")
                end
              else
                validate_type_string(type, unsupported_types, "method #{method_name} field #{field.name}")
              end
            end
          end
        end
      end

      # Validate type definitions
      if types = spec.types
        types.each do |type_name, api_type|
          if fields = api_type.fields
            fields.each do |field|
              field.types.each do |type|
                if type.includes?(" or ")
                  type.split(/\s+or\s+/).each do |individual_type|
                    validate_type_string(individual_type.strip, unsupported_types, "type #{type_name} field #{field.name}")
                  end
                else
                  validate_type_string(type, unsupported_types, "type #{type_name} field #{field.name}")
                end
              end
            end
          end
        end
      end

      # Report unsupported types
      unless unsupported_types.empty?
        puts "⚠️  Warning: Unsupported type mappings found:"
        unsupported_types.each do |type|
          puts "   - #{type}"
        end
        puts "   These will be passed through as-is. Consider adding them to TYPE_MAPPING."
      end
    end

    # Validate a single type string and collect unsupported types
    private def validate_type_string(type_str : String, unsupported_types : Set(String), context : String) : Nil
      # Handle array patterns
      if type_str.includes?("Array of")
        # Extract the inner type from "Array of X" or "Array of Array of Y"
        inner_type = type_str.gsub(/^Array of (Array of )?/, "")
        validate_type_string(inner_type, unsupported_types, context)
        return
      end

      if type_str.matches?(/^Array\((.+)\)$/)
        inner_type = $1
        validate_type_string(inner_type.strip, unsupported_types, context)
        return
      end

      # Check if the type is supported
      unless TYPE_MAPPING.has_key?(type_str) ||
             TYPE_RENAMES.has_key?(type_str) ||
             # Allow PascalCase types (likely custom API types)
             type_str.matches?(/^[A-Z][a-zA-Z0-9]*$/)
        unsupported_types.add(type_str)
      end
    end
  end
end
