require "json"
require "http/client"
require "./helpers"

module Telegram
  class Generator
    INT64_FIELDS = ["id", "user_id", "chat_id", "channel_id"]
    SKIPPED_TYPES = ["InputFile", "InputMedia", "InputMessageContent", "BotCommandScope"]

    FIELD_ANNOTATIONS = {
      "date" => [
        "@[JSON::Field(converter: Time::EpochConverter)]",
      ],
      "forward_date" => [
        "@[JSON::Field(converter: Time::EpochConverter)]",
      ],
      "edit_date" => [
        "@[JSON::Field(converter: Time::EpochConverter)]",
      ],
    }

    FIELD_OVERRIDES = {
      "parse_mode" => "ParseMode",
      "date" => "Time",
      "forward_date" => "Time",
      "edit_date" => "Time",
    }


    getter api : TelegramAPI

    def initialize(@api : TelegramAPI)
    end

    def self.new(json : String)
      api = TelegramAPI.from_json(json)
      new(api)
    end

    def write_types(file : String, header : String? = nil, namespace : String? = nil)
      indent = namespace ? 2 : 0
      File.open(file, mode: "w+") do |str|
        if header
          str << header
          str << "\n\n"
        end

        if namespace
          str << "#{namespace}\n"
        end

        self.api.types.each do |_, type|
          next if type.name.in?(SKIPPED_TYPES)
          str << self.class.generate_class_for(type, indent)
          str << "\n\n"
        end

        if namespace
          str << "end"
        end
      end
    end

    def write_methods(file : String, header : String? = nil, namespace : String? = nil)
      indent = namespace ? 2 : 0
      File.open(file, mode: "w+") do |str|
        if header
          str << header
          str << "\n\n"
        end

        if namespace
          str << "#{namespace}\n"
        end

        self.api.methods.each do |_, method|
          str << self.class.generate_method_for(method, indent)
          str << "\n\n"
        end

        if namespace
          str << "end"
        end
      end
    end

    def self.generate_class_for(type : Type, indent : Int32 = 0)
      lines = [] of String

      unless type.description.empty?
        type.chunked_description.each do |line|
          lines << "# #{line}"
        end
      end

      lines << "class #{type.name} < Telegram::API::Type"

      # Fields
      type.fields.each do |field|
        field.chunked_description.each do |line|
          lines << "  # #{line}"
        end

        if annotations = FIELD_ANNOTATIONS[field.name]?
          annotations.each do |ann|
            lines << "  #{ann}"
          end
        end

        line = "  property #{field.name} : #{field.crystal_type}"
        if field.crystal_type.starts_with?("Array")
          line += " = #{field.crystal_type}.new"
        elsif !field.required
          line += "? = nil"
        end
        lines << line + "\n"
      end

      # Initializer
      if type.fields.size > 0
        lines << "  def initialize("
        type.sorted_fields.each do |field|
          line = "    @#{field.name} : #{field.crystal_type}"
          if field.crystal_type.starts_with?("Array")
            line += " = #{field.crystal_type}.new"
          elsif !field.required
            line += "? = nil"
          end
          line += ","
          lines << line
        end
        lines << "  )"
        lines << "  end"
      end

      lines << "end"
      lines.map { |line| (" " * indent) + line }.join('\n')
    end

    def self.generate_method_for(method : Method, indent : Int32 = 0)
      lines = [] of String

      unless method.description.empty?
        method.chunked_description.each do |line|
          lines << "  # #{line}"
        end
      end

      if method.fields.size > 0
        lines << "  def #{method.name.underscore}("
        method.sorted_fields.each do |field|
          line = "    #{field.name} : #{field.crystal_type}"
          if !field.required
            line += "? = nil"
          end
          line += ","
          lines << line
        end
        lines << "  )"
      else
        lines << "  def #{method.name.underscore}"
      end

      if method.fields.size > 0
        lines << "    request(#{method.crystal_type}, \"#{method.name}\", {"
        method.fields.each do |field|
          lines << "      #{field.name}: #{field.name},"
        end
        lines << "    })"
      else
        lines << "    request(#{method.crystal_type}, \"#{method.name}\")"
      end

      lines << "  end"
      lines.map { |line| (" " * indent) + line }.join('\n')
    end

    def self.parse_type(type : String, field : String? = nil)
      if field && field.in?(FIELD_OVERRIDES.keys)
        return FIELD_OVERRIDES[field]
      end

      case type
      when "String"
        "String"
      when "Integer"
        if field && field.in?(INT64_FIELDS)
          "Int64"
        else
          "Int32"
        end
      when "Float"
        "Float64"
      when "Boolean"
        "Bool"
      when /Array of (.*)/
        "Array(#{parse_type($1, field)})"
      else
        type
      end
    end

    def self.fetch_api_json(hash : String? = nil)
      url = hash ?
        "https://raw.githubusercontent.com/PaulSonOfLars/telegram-bot-api-spec/#{hash}/api.json" :
        "https://raw.githubusercontent.com/PaulSonOfLars/telegram-bot-api-spec/main/api.json"

      response = HTTP::Client.get(url)
      if response.status.ok?
        response.body
      else
        raise "Failed to fetch API JSON: status code #{response.status_code} - #{response.status_message}"
      end
    end

    record TelegramAPI, methods : Hash(String, Method), types : Hash(String, Type) do
      include JSON::Serializable
    end

    record Field, name : String, types : Array(String), required : Bool, description : String do
      include JSON::Serializable

      def chunked_description(max_len = 90)
        Helpers.chunk_text([description], max_len)
      end

      def crystal_type
        String.build do |str|
          str << "(" if types.size > 1
          str << types.map { |t| Generator.parse_type(t, name) }.join(" | ")
          str << ")" if types.size > 1
        end
      end
    end

    record Method, name : String, href : String, returns : Array(String), description : Array(String), fields : Array(Field) = [] of Field do
      include JSON::Serializable

      def crystal_type
        String.build do |str|
          str << "(" if returns.size > 1
          str << returns.map { |t| Generator.parse_type(t, name) }.join(" | ")
          str << ")" if returns.size > 1
        end
      end

      def chunked_description(max_len = 90)
        Helpers.chunk_text(description, max_len)
      end

      def sorted_fields
        fields.sort_by do |field|
          v = 0
          v -= 1 if field.required
          v += 1 if field.types.any?(&.starts_with?("Array"))
          v
        end
      end
    end

    record Type, name : String, href : String, description : Array(String), fields : Array(Field) = [] of Field do
      include JSON::Serializable

      def chunked_description(max_len = 90)
        Helpers.chunk_text(description, max_len)
      end

      def sorted_fields
        fields.sort_by do |field|
          v = 0
          v -= 1 if field.required
          v += 1 if field.types.any?(&.starts_with?("Array"))
          v
        end
      end
    end
  end
end
