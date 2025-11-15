require "json"
require "./generated/telegram"

module Telegram
  # Basic response parsing that handles JSON::Any fallback safely
  # This is a simplified version that focuses on compilation safety
  module ResponseParser
    # Parse a response from the Telegram Bot API safely
    # Falls back to JSON::Any for complex types to avoid undefined constants
    protected def parse_response(json_response : JSON::Any, return_type : String)
      # Check for API errors first
      unless json_response["ok"]?.try(&.as_bool)
        error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
        error_code = json_response["error_code"]?.try(&.as_i)
        raise Telegram::APIError.new("#{error_desc} (code: #{error_code})")
      end

      # Extract the result field
      result = json_response["result"]?

      # Handle null results
      return nil if result.nil?

      # For basic types, do direct parsing
      case return_type
      when "Bool"
        result.as_bool
      when "Int32"
        result.as_i
      when "Int64"
        result.as_i64
      when "Float64"
        result.as_f
      when "String"
        result.as_s
      when .starts_with?("Array(")
        parse_array_response(result, return_type)
      else
        # For complex types, return JSON::Any to avoid type resolution issues
        # The caller can then deserialize as needed
        result
      end
    rescue ex : JSON::ParseException
      raise JSON::ParseException.new("Failed to parse #{return_type} response: #{ex.message}", ex.line_number, ex.column_number, ex)
    rescue ex : TypeCastError
      raise TypeCastError.new("Type mismatch in #{return_type} response: #{ex.message}")
    end

    private def parse_array_response(result : JSON::Any, return_type : String)
      elements = result.as_a
      match = return_type.match(/^Array\((.*)\)$/)
      return elements unless match
      element_type = match[1]

      case element_type
      when "Bool"
        elements.map(&.as_bool)
      when "Int32"
        elements.map(&.as_i)
      when "Int64"
        elements.map(&.as_i64)
      when "Float64"
        elements.map(&.as_f)
      when "String"
        elements.map(&.as_s)
      else
        # For complex array types, return as JSON::Any array
        elements
      end
    end
  end
end