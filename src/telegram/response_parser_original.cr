# Comprehensive response parsing module for Telegram Bot API client
# Provides robust parsing for all Telegram API response types with error handling
require "json"
require "./http_client_wrapper"

module Telegram
  # Comprehensive response parsing utilities for Telegram Bot API
  #
  # This module provides robust parsing capabilities for all types of responses
  # from the Telegram Bot API, including complex nested structures, arrays,
  # and optional fields. It includes comprehensive error handling and validation.
  #
  # ## Features
  #
  # - Primitive type parsing with null safety
  # - Nested array parsing (Array(Array(MessageEntity)))
  # - Hash and NamedTuple response parsing
  # - Mixed type array parsing with dynamic type detection
  # - Recursive parsing for arbitrary depth structures
  # - Comprehensive error handling and validation
  #
  # ## Example
  #
  # ```
  # class MyClient
  #   include Telegram::ResponseParser
  #
  #   def some_method
  #     response = HTTP::Client.get("...")
  #     json_response = JSON.parse(response.body)
  #
  #     # Parse complex response type
  #     result = parse_response(json_response, "Array(Array(MessageEntity))")
  #   end
  # end
  # ```
  module ResponseParser
    # Parse a Telegram API response based on the expected return type
    # This is the main entry point for response parsing
    #
    # ## Parameters
    #
    # - **json_response** (`JSON::Any`): The parsed JSON response from Telegram API
    # - **return_type** (`String`): The expected return type (e.g., "String", "Array(Message)", "Array(Array(MessageEntity))")
    #
    # ## Returns
    #
    # The parsed response converted to the appropriate Crystal type
    #
    # ## Raises
    #
    # - `Telegram::APIError` if the API returned an error
    # - `JSON::ParseException` if response parsing fails
    # - `ArgumentError` if the return type is unsupported
    #
    # ## Example
    #
    # ```
    # # Parse a simple string response
    # result = parse_response(json_response, "String")
    #
    # # Parse an array of messages
    # messages = parse_response(json_response, "Array(Message)")
    #
    # # Parse nested array structure
    # entities = parse_response(json_response, "Array(Array(MessageEntity))")
    # ```
    protected def parse_response(json_response : JSON::Any, return_type : String)
      # Check for API errors first
      unless json_response["ok"]?.try(&.as_bool)
        error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
        error_code = json_response["error_code"]?.try(&.as_i)
        raise Telegram::APIError.new("#{error_desc} (code: #{error_code})")
      end

      # Extract the result field
      result = json_response["result"]?

      # Handle null results based on expected type
      if result.nil?
        return handle_null_result(return_type)
      end

      # Parse based on the return type
      parse_typed_result(result, return_type)
    rescue ex : JSON::ParseException
      raise JSON::ParseException.new("Failed to parse #{return_type} response: #{ex.message}", ex.line_number, ex.column_number, ex)
    rescue ex : TypeCastError
      raise TypeCastError.new("Type mismatch in #{return_type} response: #{ex.message}")
    end

    # Parse a typed result from JSON::Any based on the expected type
    # This method handles all supported Telegram API return types
    private def parse_typed_result(result : JSON::Any, return_type : String)
      case return_type
      when "Bool"
        parse_bool(result)
      when "Int32"
        parse_int32(result)
      when "Int64"
        parse_int64(result)
      when "Float64"
        parse_float64(result)
      when "String"
        parse_string(result)
      when "JSON::Any"
        result
      when .starts_with?("Array(")
        parse_array(result, return_type)
      when .includes?("|")
        parse_union_type(result, return_type)
      else
        # Assume it's a complex Telegram type
        parse_complex_type(result, return_type)
      end
    rescue ex
      raise ArgumentError.new("Failed to parse #{return_type}: #{ex.message}")
    end

    # Parse boolean values with validation
    private def parse_bool(value : JSON::Any) : Bool
      case value.raw
      when Nil
        false
      when Bool
        value.as_bool
      when String
        case value.as_s.downcase
        when "true", "1", "yes", "on"
          true
        when "false", "0", "no", "off"
          false
        else
          raise TypeCastError.new("Cannot convert '#{value.as_s}' to Bool")
        end
      when Int
        value.as_i != 0
      else
        raise TypeCastError.new("Cannot convert #{value.class} to Bool")
      end
    end

    # Parse 32-bit integers with validation
    private def parse_int32(value : JSON::Any) : Int32
      case value.raw
      when Nil
        0
      when Int32
        value.as_i
      when Int64
        int_val = value.as_i64
        if int_val > Int32::MAX || int_val < Int32::MIN
          raise TypeCastError.new("Value #{int_val} is outside Int32 range")
        end
        int_val.to_i32
      when String
        begin
          value.as_s.to_i32
        rescue ArgumentError
          raise TypeCastError.new("Cannot convert '#{value.as_s}' to Int32")
        end
      else
        raise TypeCastError.new("Cannot convert #{value.class} to Int32")
      end
    end

    # Parse 64-bit integers with validation
    private def parse_int64(value : JSON::Any) : Int64
      case value.raw
      when Nil
        0_i64
      when Int32, Int64
        value.as_i64
      when String
        begin
          value.as_s.to_i64
        rescue ArgumentError
          raise TypeCastError.new("Cannot convert '#{value.as_s}' to Int64")
        end
      else
        raise TypeCastError.new("Cannot convert #{value.class} to Int64")
      end
    end

    # Parse float values with validation
    private def parse_float64(value : JSON::Any) : Float64
      case value.raw
      when Nil
        0.0
      when Float64, Float32
        value.as_f
      when Int32, Int64
        value.as_i.to_f64
      when String
        begin
          value.as_s.to_f64
        rescue ArgumentError
          raise TypeCastError.new("Cannot convert '#{value.as_s}' to Float64")
        end
      else
        raise TypeCastError.new("Cannot convert #{value.class} to Float64")
      end
    end

    # Parse string values with validation
    private def parse_string(value : JSON::Any) : String
      case value.raw
      when Nil
        ""  # Convert nil to empty string for compatibility
      when String
        value.as_s
      when Bool, Int32, Int64, Float64
        value.to_s
      else
        raise TypeCastError.new("Cannot convert #{value.class} to String")
      end
    end

    # Parse array values with support for nested arrays and complex types
    private def parse_array(value : JSON::Any, return_type : String) : Array
      unless value.as_a?
        raise TypeCastError.new("Expected array, got #{value.class}")
      end

      # Extract element type from Array(Type) syntax
      element_type = extract_array_element_type(return_type)
      array = value.as_a

      if is_nested_array_type?(return_type)
        # Handle nested arrays like Array(Array(MessageEntity))
        parse_nested_array(array, element_type)
      elsif is_basic_type?(element_type)
        # Handle arrays of basic types
        parse_basic_array(array, element_type)
      else
        # Handle arrays of complex types
        parse_complex_array(array, element_type)
      end
    end

    # Extract the element type from an array type string
    # Handles both simple and nested array types
    private def extract_array_element_type(array_type : String) : String
      # Remove "Array(" prefix and ")" suffix
      return array_type unless array_type.starts_with?("Array(")

      content = array_type["Array(".size..-2]

      # Handle nested arrays recursively
      if content.starts_with?("Array(")
        nested_count = 1
        end_pos = content.size - 1

        content.each_char_with_index do |char, index|
          case char
          when '('
            nested_count += 1
          when ')'
            nested_count -= 1
            if nested_count == 0
              end_pos = index
              break
            end
          end
        end

        return content[0..end_pos]
      end

      content
    end

    # Check if this is a nested array type (e.g., Array(Array(Type)))
    private def is_nested_array_type?(array_type : String) : Bool
      content = extract_array_element_type(array_type)
      content.starts_with?("Array(")
    end

    # Parse nested arrays like Array(Array(MessageEntity))
    private def parse_nested_array(array : Array(JSON::Any), element_type : String)
      result = [] of Array(JSON::Any)
      array.each do |item|
        begin
          parsed_item = parse_typed_result(item, "Array(#{element_type})")
          result << parsed_item.as(Array(JSON::Any))
        rescue
          # If parsing fails, add an empty array
          result << [] of JSON::Any
        end
      end
      result
    end

    # Parse arrays of basic types (Int32, String, Bool, etc.)
    private def parse_basic_array(array : Array(JSON::Any), element_type : String)
      case element_type
      when "Bool"
        bool_result = [] of Bool
        array.each { |item| bool_result << parse_bool(item) }
        bool_result
      when "Int32"
        int_result = [] of Int32
        array.each { |item| int_result << parse_int32(item) }
        int_result
      when "Int64"
        int64_result = [] of Int64
        array.each { |item| int64_result << parse_int64(item) }
        int64_result
      when "Float64"
        float_result = [] of Float64
        array.each { |item| float_result << parse_float64(item) }
        float_result
      when "String"
        string_result = [] of String
        array.each { |item| string_result << parse_string(item) }
        string_result
      else
        raise ArgumentError.new("Unsupported basic array element type: #{element_type}")
      end
    end

    # Parse arrays of complex types (Message, User, etc.)
    private def parse_complex_array(array : Array(JSON::Any), element_type : String)
      # Use specific type parsing based on the element type
      # This provides better type safety and performance
      class_name = resolve_type_class_name(element_type)

      case class_name
      when "Telegram::User"
        parse_specific_array(array, ->(value : JSON::Any) { Telegram::User.from_json(value.to_json) })
      when "Telegram::Message"
        parse_specific_array(array, ->(value : JSON::Any) { Telegram::Message.from_json(value.to_json) })
      when "Telegram::Update"
        parse_specific_array(array, ->(value : JSON::Any) { Telegram::Update.from_json(value.to_json) })
      when "Telegram::Chat"
        parse_specific_array(array, ->(value : JSON::Any) { Telegram::Chat.from_json(value.to_json) })
      when "Telegram::PhotoSize"
        parse_specific_array(array, ->(value : JSON::Any) { Telegram::PhotoSize.from_json(value.to_json) })
      when "Telegram::Audio"
        parse_specific_array(array, ->(value : JSON::Any) { Telegram::Audio.from_json(value.to_json) })
      when "Telegram::Document"
        parse_specific_array(array, ->(value : JSON::Any) { Telegram::Document.from_json(value.to_json) })
      when "Telegram::Video"
        parse_specific_array(array, ->(value : JSON::Any) { Telegram::Video.from_json(value.to_json) })
      when "Telegram::Animation"
        parse_specific_array(array, ->(value : JSON::Any) { Telegram::Animation.from_json(value.to_json) })
      when "Telegram::Voice"
        parse_specific_array(array, ->(value : JSON::Any) { Telegram::Voice.from_json(value.to_json) })
      when "Telegram::VideoNote"
        parse_specific_array(array, ->(value : JSON::Any) { Telegram::VideoNote.from_json(value.to_json) })
      when "Telegram::Sticker"
        parse_specific_array(array, ->(value : JSON::Any) { Telegram::Sticker.from_json(value.to_json) })
      when "Telegram::Contact"
        parse_specific_array(array, ->(value : JSON::Any) { Telegram::Contact.from_json(value.to_json) })
      when "Telegram::Location"
        parse_specific_array(array, ->(value : JSON::Any) { Telegram::Location.from_json(value.to_json) })
      when "Telegram::Venue"
        parse_specific_array(array, ->(value : JSON::Any) { Telegram::Venue.from_json(value.to_json) })
      when "Telegram::MessageEntity"
        parse_specific_array(array, ->(value : JSON::Any) { Telegram::MessageEntity.from_json(value.to_json) })
      when "Telegram::PollOption"
        parse_specific_array(array, ->(value : JSON::Any) { Telegram::PollOption.from_json(value.to_json) })
      when "Telegram::Poll"
        parse_specific_array(array, ->(value : JSON::Any) { Telegram::Poll.from_json(value.to_json) })
      else
        # For unknown types, fall back to the original behavior
        array
      end
    rescue ex
      # If parsing fails for any reason, return the original array
      array
    end

    # Helper method to parse arrays with a specific deserialization function
    private def parse_specific_array(array : Array(JSON::Any), deserializer : JSON::Any -> T) forall T
      result = [] of T

      array.each do |element|
        begin
          parsed_element = deserializer.call(element)
          result << parsed_element
        rescue ex
          # If any element fails to parse, fall back to returning the original array
          return array
        end
      end

      result
    end

    # Parse union types (e.g., "String | Int32")
    private def parse_union_type(value : JSON::Any, return_type : String)
      types = return_type.split("|").map(&.strip)

      types.each do |type|
        begin
          return parse_typed_result(value, type)
        rescue ex
          # Try the next type
          next
        end
      end

      raise TypeCastError.new("Value could not be parsed as any of the types in #{return_type}")
    end

    # Parse complex custom types using from_json
    private def parse_complex_type(value : JSON::Any, type_name : String)
      begin
        # Resolve the full class name (handle both namespaced and non-namespaced types)
        class_name = resolve_type_class_name(type_name)

        # Convert JSON::Any back to JSON string for deserialization
        json_string = value.to_json

        # Use Crystal's built-in JSON deserialization
        case class_name
        when "Telegram::User"
          Telegram::User.from_json(json_string)
        when "Telegram::Message"
          Telegram::Message.from_json(json_string)
        when "Telegram::Update"
          Telegram::Update.from_json(json_string)
        when "Telegram::Chat"
          Telegram::Chat.from_json(json_string)
        when "Telegram::PhotoSize"
          Telegram::PhotoSize.from_json(json_string)
        when "Telegram::Audio"
          Telegram::Audio.from_json(json_string)
        when "Telegram::Document"
          Telegram::Document.from_json(json_string)
        when "Telegram::Video"
          Telegram::Video.from_json(json_string)
        when "Telegram::Animation"
          Telegram::Animation.from_json(json_string)
        when "Telegram::Voice"
          Telegram::Voice.from_json(json_string)
        when "Telegram::VideoNote"
          Telegram::VideoNote.from_json(json_string)
        when "Telegram::Sticker"
          Telegram::Sticker.from_json(json_string)
        when "Telegram::Contact"
          Telegram::Contact.from_json(json_string)
        when "Telegram::Dice"
          Telegram::Dice.from_json(json_string)
        when "Telegram::PollOption"
          Telegram::PollOption.from_json(json_string)
        when "Telegram::Poll"
          Telegram::Poll.from_json(json_string)
        when "Telegram::Venue"
          Telegram::Venue.from_json(json_string)
        when "Telegram::Location"
          Telegram::Location.from_json(json_string)
        when "Telegram::NewChatMembers"
          Telegram::NewChatMembers.from_json(json_string)
        when "Telegram::LeftChatMember"
          Telegram::LeftChatMember.from_json(json_string)
        when "Telegram::NewChatTitle"
          Telegram::NewChatTitle.from_json(json_string)
        when "Telegram::NewChatPhoto"
          Telegram::NewChatPhoto.from_json(json_string)
        when "Telegram::DeleteChatPhoto"
          Telegram::DeleteChatPhoto.from_json(json_string)
        when "Telegram::GroupChatCreated"
          Telegram::GroupChatCreated.from_json(json_string)
        when "Telegram::SupergroupChatCreated"
          Telegram::SupergroupChatCreated.from_json(json_string)
        when "Telegram::ChannelChatCreated"
          Telegram::ChannelChatCreated.from_json(json_string)
        when "Telegram::MessageAutoDeleteTimerChanged"
          Telegram::MessageAutoDeleteTimerChanged.from_json(json_string)
        when "Telegram::MigrateToChatId"
          Telegram::MigrateToChatId.from_json(json_string)
        when "Telegram::MigrateFromChatId"
          Telegram::MigrateFromChatId.from_json(json_string)
        when "Telegram::PinnedMessage"
          Telegram::PinnedMessage.from_json(json_string)
        when "Telegram::Invoice"
          Telegram::Invoice.from_json(json_string)
        when "Telegram::SuccessfulPayment"
          Telegram::SuccessfulPayment.from_json(json_string)
        when "Telegram::RefundedPayment"
          Telegram::RefundedPayment.from_json(json_string)
        when "Telegram::UsersShared"
          Telegram::UsersShared.from_json(json_string)
        when "Telegram::ChatShared"
          Telegram::ChatShared.from_json(json_string)
        when "Telegram::ConnectedWebsite"
          Telegram::ConnectedWebsite.from_json(json_string)
        when "Telegram::WriteAccessAllowed"
          Telegram::WriteAccessAllowed.from_json(json_string)
        when "Telegram::PassportData"
          Telegram::PassportData.from_json(json_string)
        when "Telegram::ProximityAlertTriggered"
          Telegram::ProximityAlertTriggered.from_json(json_string)
        when "Telegram::VideoChatStarted"
          Telegram::VideoChatStarted.from_json(json_string)
        when "Telegram::VideoChatEnded"
          Telegram::VideoChatEnded.from_json(json_string)
        when "Telegram::VideoChatParticipantsInvited"
          Telegram::VideoChatParticipantsInvited.from_json(json_string)
        when "Telegram::VideoChatScheduled"
          Telegram::VideoChatScheduled.from_json(json_string)
        when "Telegram::MessageEntity"
          Telegram::MessageEntity.from_json(json_string)
        when "Telegram::ReplyParameters"
          Telegram::ReplyParameters.from_json(json_string)
        when "Telegram::InlineKeyboardMarkup"
          Telegram::InlineKeyboardMarkup.from_json(json_string)
        when "Telegram::ReplyKeyboardMarkup"
          Telegram::ReplyKeyboardMarkup.from_json(json_string)
        when "Telegram::ReplyKeyboardRemove"
          Telegram::ReplyKeyboardRemove.from_json(json_string)
        when "Telegram::ForceReply"
          Telegram::ForceReply.from_json(json_string)
        when "Telegram::CallbackQuery"
          Telegram::CallbackQuery.from_json(json_string)
        when "Telegram::BotCommand"
          Telegram::BotCommand.from_json(json_string)
        when "Telegram::BotName"
          Telegram::BotName.from_json(json_string)
        when "Telegram::BotDescription"
          Telegram::BotDescription.from_json(json_string)
        when "Telegram::MenuButtonCommands"
          Telegram::MenuButtonCommands.from_json(json_string)
        when "Telegram::MenuButtonWebApp"
          Telegram::MenuButtonWebApp.from_json(json_string)
        when "Telegram::MenuButtonDefault"
          Telegram::MenuButtonDefault.from_json(json_string)
        when "Telegram::ChatPhoto"
          Telegram::ChatPhoto.from_json(json_string)
        when "Telegram::ChatInviteLink"
          Telegram::ChatInviteLink.from_json(json_string)
        when "Telegram::ChatAdministratorRights"
          Telegram::ChatAdministratorRights.from_json(json_string)
        when "Telegram::ChatMemberUpdated"
          Telegram::ChatMemberUpdated.from_json(json_string)
        when "Telegram::ChatMember"
          Telegram::ChatMember.from_json(json_string)
        when "Telegram::ChatJoinRequest"
          Telegram::ChatJoinRequest.from_json(json_string)
        when "Telegram::ChatPermissions"
          Telegram::ChatPermissions.from_json(json_string)
        when "Telegram::ChatLocation"
          Telegram::ChatLocation.from_json(json_string)
        when "Telegram::ChatBackground"
          Telegram::ChatBackground.from_json(json_string)
        when "Telegram::ForumTopicCreated"
          Telegram::ForumTopicCreated.from_json(json_string)
        when "Telegram::ForumTopicEdited"
          Telegram::ForumTopicEdited.from_json(json_string)
        when "Telegram::ForumTopicClosed"
          Telegram::ForumTopicClosed.from_json(json_string)
        when "Telegram::ForumTopicReopened"
          Telegram::ForumTopicReopened.from_json(json_string)
        when "Telegram::GeneralForumTopicHidden"
          Telegram::GeneralForumTopicHidden.from_json(json_string)
        when "Telegram::GeneralForumTopicUnhidden"
          Telegram::GeneralForumTopicUnhidden.from_json(json_string)
        when "Telegram::UserShared"
          Telegram::UserShared.from_json(json_string)
        when "Telegram::Story"
          Telegram::Story.from_json(json_string)
        when "Telegram::SentWebAppMessage"
          Telegram::SentWebAppMessage.from_json(json_string)
        when "Telegram::GiveawayCreated"
          Telegram::GiveawayCreated.from_json(json_string)
        when "Telegram::Giveaway"
          Telegram::Giveaway.from_json(json_string)
        when "Telegram::GiveawayWinners"
          Telegram::GiveawayWinners.from_json(json_string)
        when "Telegram::ChatBoostAdded"
          Telegram::ChatBoostAdded.from_json(json_string)
        when "Telegram::ChatBoost"
          Telegram::ChatBoost.from_json(json_string)
        when "Telegram::ChatBoostUpdated"
          Telegram::ChatBoostUpdated.from_json(json_string)
        when "Telegram::ChatBoostRemoved"
          Telegram::ChatBoostRemoved.from_json(json_string)
        when "Telegram::BusinessConnection"
          Telegram::BusinessConnection.from_json(json_string)
        when "Telegram::BusinessMessagesDeleted"
          Telegram::BusinessMessagesDeleted.from_json(json_string)
        when "Telegram::ResponseParameters"
          Telegram::ResponseParameters.from_json(json_string)
        when "Telegram::InputMedia"
          Telegram::InputMedia.from_json(json_string)
        when "Telegram::InputMediaPhoto"
          Telegram::InputMediaPhoto.from_json(json_string)
        when "Telegram::InputMediaVideo"
          Telegram::InputMediaVideo.from_json(json_string)
        when "Telegram::InputMediaAnimation"
          Telegram::InputMediaAnimation.from_json(json_string)
        when "Telegram::InputMediaAudio"
          Telegram::InputMediaAudio.from_json(json_string)
        when "Telegram::InputMediaDocument"
          Telegram::InputMediaDocument.from_json(json_string)
        when "Telegram::InputFile"
          Telegram::InputFile.from_json(json_string)
        when "Telegram::CallbackGame"
          Telegram::CallbackGame.from_json(json_string)
        when "Telegram::Game"
          Telegram::Game.from_json(json_string)
        when "Telegram::GameHighScore"
          Telegram::GameHighScore.from_json(json_string)
        when "Telegram::LabeledPrice"
          Telegram::LabeledPrice.from_json(json_string)
        when "Telegram::ShippingAddress"
          Telegram::ShippingAddress.from_json(json_string)
        when "Telegram::OrderInfo"
          Telegram::OrderInfo.from_json(json_string)
        when "Telegram::ShippingOption"
          Telegram::ShippingOption.from_json(json_string)
        when "Telegram::PreCheckoutQuery"
          Telegram::PreCheckoutQuery.from_json(json_string)
        when "Telegram::ShippingQuery"
          Telegram::ShippingQuery.from_json(json_string)
        when "Telegram::PassportFile"
          Telegram::PassportFile.from_json(json_string)
        when "Telegram::EncryptedPassportElement"
          Telegram::EncryptedPassportElement.from_json(json_string)
        when "Telegram::EncryptedCredentials"
          Telegram::EncryptedCredentials.from_json(json_string)
        when "Telegram::PassportElementError"
          Telegram::PassportElementError.from_json(json_string)
        when "Telegram::PassportElementErrorDataField"
          Telegram::PassportElementErrorDataField.from_json(json_string)
        when "Telegram::PassportElementErrorFrontSide"
          Telegram::PassportElementErrorFrontSide.from_json(json_string)
        when "Telegram::PassportElementErrorReverseSide"
          Telegram::PassportElementErrorReverseSide.from_json(json_string)
        when "Telegram::PassportElementErrorSelfie"
          Telegram::PassportElementErrorSelfie.from_json(json_string)
        when "Telegram::PassportElementErrorFile"
          Telegram::PassportElementErrorFile.from_json(json_string)
        when "Telegram::PassportElementErrorFiles"
          Telegram::PassportElementErrorFiles.from_json(json_string)
        when "Telegram::PassportElementErrorTranslationFile"
          Telegram::PassportElementErrorTranslationFile.from_json(json_string)
        when "Telegram::PassportElementErrorTranslationFiles"
          Telegram::PassportElementErrorTranslationFiles.from_json(json_string)
        when "Telegram::PassportElementErrorUnspecified"
          Telegram::PassportElementErrorUnspecified.from_json(json_string)
        when "Telegram::WebAppInfo"
          Telegram::WebAppInfo.from_json(json_string)
        when "Telegram::InlineQuery"
          Telegram::InlineQuery.from_json(json_string)
        when "Telegram::InlineQueryResult"
          Telegram::InlineQueryResult.from_json(json_string)
        when "Telegram::InlineQueryResultArticle"
          Telegram::InlineQueryResultArticle.from_json(json_string)
        when "Telegram::InlineQueryResultPhoto"
          Telegram::InlineQueryResultPhoto.from_json(json_string)
        when "Telegram::InlineQueryResultVideo"
          Telegram::InlineQueryResultVideo.from_json(json_string)
        when "Telegram::InlineQueryResultAudio"
          Telegram::InlineQueryResultAudio.from_json(json_string)
        when "Telegram::InlineQueryResultVoice"
          Telegram::InlineQueryResultVoice.from_json(json_string)
        when "Telegram::InlineQueryResultDocument"
          Telegram::InlineQueryResultDocument.from_json(json_string)
        when "Telegram::InlineQueryResultLocation"
          Telegram::InlineQueryResultLocation.from_json(json_string)
        when "Telegram::InlineQueryResultVenue"
          Telegram::InlineQueryResultVenue.from_json(json_string)
        when "Telegram::InlineQueryResultContact"
          Telegram::InlineQueryResultContact.from_json(json_string)
        when "Telegram::InlineQueryResultGame"
          Telegram::InlineQueryResultGame.from_json(json_string)
        when "Telegram::InlineQueryResultCachedPhoto"
          Telegram::InlineQueryResultCachedPhoto.from_json(json_string)
        when "Telegram::InlineQueryResultCachedVideo"
          Telegram::InlineQueryResultCachedVideo.from_json(json_string)
        when "Telegram::InlineQueryResultCachedAudio"
          Telegram::InlineQueryResultCachedAudio.from_json(json_string)
        when "Telegram::InlineQueryResultCachedVoice"
          Telegram::InlineQueryResultCachedVoice.from_json(json_string)
        when "Telegram::InlineQueryResultCachedDocument"
          Telegram::InlineQueryResultCachedDocument.from_json(json_string)
        when "Telegram::InlineQueryResultCachedSticker"
          Telegram::InlineQueryResultCachedSticker.from_json(json_string)
        when "Telegram::InlineQueryResultCachedAnimation"
          Telegram::InlineQueryResultCachedAnimation.from_json(json_string)
        when "Telegram::InlineQueryResultCachedVenue"
          Telegram::InlineQueryResultCachedVenue.from_json(json_string)
        when "Telegram::ChosenInlineResult"
          Telegram::ChosenInlineResult.from_json(json_string)
        when "Telegram::InputMessageContent"
          Telegram::InputMessageContent.from_json(json_string)
        when "Telegram::InputTextMessageContent"
          Telegram::InputTextMessageContent.from_json(json_string)
        when "Telegram::InputLocationMessageContent"
          Telegram::InputLocationMessageContent.from_json(json_string)
        when "Telegram::InputVenueMessageContent"
          Telegram::InputVenueMessageContent.from_json(json_string)
        when "Telegram::InputContactMessageContent"
          Telegram::InputContactMessageContent.from_json(json_string)
        when "Telegram::InputInvoiceMessageContent"
          Telegram::InputInvoiceMessageContent.from_json(json_string)
        when "Telegram::LoginUrl"
          Telegram::LoginUrl.from_json(json_string)
        else
          # Fallback: try to resolve the class dynamically for unknown types
          resolve_and_deserialize_type(json_string, class_name)
        end
      rescue ex : JSON::ParseException
        raise JSON::ParseException.new("Failed to parse #{type_name} from JSON: #{ex.message}", ex.line_number, ex.column_number, ex)
      rescue ex : TypeCastError
        raise TypeCastError.new("Type mismatch while parsing #{type_name}: #{ex.message}")
      rescue ex
        raise ArgumentError.new("Unknown error parsing #{type_name}: #{ex.message}")
      end
    end

    # Resolve the full class name for a type (handles both namespaced and non-namespaced types)
    private def resolve_type_class_name(type_name : String) : String
      # If already namespaced, return as-is
      if type_name.includes?("::")
        type_name
      else
        # Assume it's a Telegram type and add the namespace
        "Telegram::#{type_name}"
      end
    end

    # Fallback method to resolve and deserialize types dynamically
    private def resolve_and_deserialize_type(json_string : String, class_name : String)
      begin
        # Try to resolve the class using constant lookup
        klass = Object.const_get(class_name)

        # Check if the class responds to from_json (should be true for JSON::Serializable classes)
        if klass.responds_to?(:from_json)
          klass.from_json(json_string)
        else
          raise ArgumentError.new("Class #{class_name} does not support JSON deserialization")
        end
      rescue ex : NameError
        # If the class doesn't exist, try to fall back to JSON::Any
        # This maintains backward compatibility for unknown types
        JSON.parse(json_string)
      rescue ex
        raise ArgumentError.new("Failed to resolve and deserialize #{class_name}: #{ex.message}")
      end
    end

    # Handle null results based on expected type
    private def handle_null_result(return_type : String)
      case return_type
      when "Bool"
        false
      when "Int32"
        0
      when "Int64"
        0_i64
      when "Float64"
        0.0
      when "String"
        ""
      when .starts_with?("Array(")
        [] of JSON::Any
      when "JSON::Any"
        JSON::Any.new(nil)
      else
        # For complex types, we can't return nil safely, so raise an error
        raise ArgumentError.new("Null result received for #{return_type}")
      end
    end

    # Check if a type is a basic primitive type
    private def is_basic_type?(type : String) : Bool
      ["Bool", "Int32", "Int64", "Float64", "String"].includes?(type)
    end

    # Dynamic type detection for mixed content arrays
    # Attempts to determine the most appropriate type for each element
    private def detect_and_parse_element(element : JSON::Any) : typeof(element)
      case element.raw
      when Nil
        nil
      when Bool
        element.as_bool
      when Int32
        element.as_i
      when Int64
        element.as_i64
      when Float64
        element.as_f
      when String
        element.as_s
      when Array
        element.as_a.map { |item| detect_and_parse_element(item) }
      when Hash
        element.as_h
      else
        element
      end
    end

    # Parse mixed content arrays with dynamic type detection
    private def parse_mixed_array(array : Array(JSON::Any)) : Array
      array.map { |element| detect_and_parse_element(element) }
    end

    # Deep parse a nested structure with arbitrary depth
    # Recursively parses all nested arrays and hashes
    private def deep_parse_structure(value : JSON::Any) : typeof(value)
      case value.raw
      when Array
        value.as_a.map { |item| deep_parse_structure(item) }
      when Hash
        value.as_h.transform_values { |v| deep_parse_structure(v) }
      else
        value
      end
    end

    # Validate response structure matches expected format
    private def validate_response_structure(json_response : JSON::Any) : Nil
      unless json_response.as_h?
        raise ArgumentError.new("Expected JSON object as response, got #{json_response.class}")
      end

      response = json_response.as_h

      # Check for required fields
      unless response.has_key?("ok")
        raise ArgumentError.new("Missing 'ok' field in Telegram API response")
      end

      unless response.has_key?("result")
        raise ArgumentError.new("Missing 'result' field in Telegram API response")
      end
    end

    # Extract error information from failed API responses
    private def extract_error_info(json_response : JSON::Any) : {String, Int32?}
      description = json_response["description"]?.try(&.as_s) || "Unknown error"
      error_code = json_response["error_code"]?.try(&.as_i)
      {description, error_code}
    end

    # Parse response with detailed error information
    # Enhanced version that provides more context in error messages
    protected def parse_response_with_details(json_response : JSON::Any, return_type : String, context : String? = nil)
      validate_response_structure(json_response)

      unless json_response["ok"]?.try(&.as_bool)
        description, error_code = extract_error_info(json_response)
        context_msg = context ? " (context: #{context})" : ""
        raise Telegram::APIError.new("#{description} (code: #{error_code})#{context_msg}")
      end

      result = json_response["result"]?

      if result.nil?
        handle_null_result(return_type)
      else
        parse_typed_result(result, return_type)
      end
    rescue ex
      context_msg = context ? " (context: #{context})" : ""
      raise ArgumentError.new("Response parsing failed for #{return_type}#{context_msg}: #{ex.message}")
    end

    # Batch parse multiple responses (for pagination or batch operations)
    protected def parse_responses_batch(json_responses : Array(JSON::Any), return_type : String) : Array
      json_responses.map do |response|
        parse_response(response, return_type)
      end
    end

    # Parse paginated response with total count information
    protected def parse_paginated_response(json_response : JSON::Any, return_type : String) : {Array, Int32}
      validate_response_structure(json_response)

      unless json_response["ok"]?.try(&.as_bool)
        description, error_code = extract_error_info(json_response)
        raise Telegram::APIError.new("#{description} (code: #{error_code})")
      end

      result = json_response["result"]?

      if result.nil?
        return {[] of typeof(parse_typed_result(JSON::Any.new(nil), return_type)), 0}
      end

      # Try to extract total count if present
      total_count = json_response["total_count"]?.try(&.as_i) ||
                   json_response["total"]?.try(&.as_i) || 0

      # Parse the actual results
      if return_type.starts_with?("Array(")
        items = parse_typed_result(result, return_type)
      else
        # If single item expected, wrap in array
        item = parse_typed_result(result, return_type)
        items = [item]
      end

      {items, total_count}
    end
  end
end

