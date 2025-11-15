# HTTP client for Telegram Bot API
# Generated for Telegram Bot API Bot API 9.2 (August 15, 2025)
require "http/client"
require "mime/multipart"
require "../json_helper"
require "../response_parser"
require "../http_client_wrapper"

module Telegram
  module Client

    # Main API client for Telegram Bot API with enhanced HTTP features
    # Features: persistent connections, retries, timeouts, proxy support
    class APIClient
      include Telegram::JSONHelper
      include Telegram::ResponseParser

      # Bot token from @BotFather
      property token : String

      # Base API URL
      property api_url : String = "https://api.telegram.org"

      # HTTP client configuration
      property http_config : Telegram::HTTPClientConfig

      # HTTP client wrapper
      @http_client : Telegram::HTTPClientWrapper

      # Initialize with default configuration
      def initialize(@token : String, @api_url : String = "https://api.telegram.org")
        @http_config = Telegram::HTTPClientConfig.new
        @http_client = Telegram::HTTPClientWrapper.new(@http_config)
      end

      # Initialize with custom configuration
      def initialize(@token : String, @api_url : String, @http_config : Telegram::HTTPClientConfig)
        @http_client = Telegram::HTTPClientWrapper.new(@http_config)
      end

      # Initialize with custom HTTP client (for advanced use cases)
      def initialize(@token : String, @api_url : String, custom_client : HTTP::Client, @http_config : Telegram::HTTPClientConfig = Telegram::HTTPClientConfig.new)
        @http_client = Telegram::HTTPClientWrapper.new(custom_client, @http_config)
      end

      # Configure the HTTP client
      def configure_http(&block : Telegram::HTTPClientConfig ->)
        yield @http_config
        # Recreate the HTTP client with new configuration
        @http_client.close
        @http_client = Telegram::HTTPClientWrapper.new(@http_config)
      end

      # Close the HTTP client and cleanup resources
      def close
        @http_client.close
      end

      # getUpdates
      # Use this method to receive incoming updates using long polling (wiki). Returns an Array of Update objects.
      #
      # Returns: Array(Update)
      # See: https://core.telegram.org/bots/api#getupdates
      def get_updates(offset : Int32? = nil, limit : Int32? = nil, timeout : Int32? = nil, allowed_updates : Array(String)? = nil) : Array(Update)
        # Collect parameters for file detection
        params_hash = {
          "offset" => offset,
          "limit" => limit,
          "timeout" => timeout,
          "allowed_updates" => allowed_updates,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          offset: offset,
          limit: limit,
          timeout: timeout,
          allowed_updates: allowed_updates,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/getUpdates"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Array(Update).from_json(result_data.to_json)
      end

      # setWebhook
      # Use this method to specify a URL and receive incoming updates via an outgoing webhook. Whenever there is an update for the bot, we will send an HTTPS POST request to the specified URL, containing a JSON-serialized Update. In case of an unsuccessful request (a request with response HTTP status code different from 2XY), we will repeat the request and give up after a reasonable amount of attempts. Returns True on success.
      # If you'd like to make sure that the webhook was set by you, you can specify secret data in the parameter secret_token. If specified, the request will contain a header "X-Telegram-Bot-Api-Secret-Token" with the secret token as content.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setwebhook
      def set_webhook(url : String, certificate : Telegram::InputFile | File | IO? = nil, ip_address : String? = nil, max_connections : Int32? = nil, allowed_updates : Array(String)? = nil, drop_pending_updates : Bool? = nil, secret_token : String? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "url" => url,
          "certificate" => certificate,
          "ip_address" => ip_address,
          "max_connections" => max_connections,
          "allowed_updates" => allowed_updates,
          "drop_pending_updates" => drop_pending_updates,
          "secret_token" => secret_token,
        }

        # Runtime detection: check if any parameters contain actual file data
        has_files = contains_file_data?(params_hash)

        if has_files
          # Use multipart form data for file uploads
          boundary, form_body = build_multipart_form_with_files(params_hash)
          
          # Make HTTP request with multipart form using enhanced client
          url = "#{@api_url}/bot#{@token}/setWebhook"
          response = @http_client.post_multipart(url, {boundary, form_body})
        else
          # Use JSON request when no files are present
          params = build_request_hash_from_hash(params_hash)
          
          # Make HTTP request using enhanced client
          url = "#{@api_url}/bot#{@token}/setWebhook"
          response = @http_client.post(url,
            headers: HTTP::Headers{"Content-Type" => "application/json"},
            body: params.to_json
          )
        end

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # deleteWebhook
      # Use this method to remove webhook integration if you decide to switch back to getUpdates. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#deletewebhook
      def delete_webhook(drop_pending_updates : Bool? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "drop_pending_updates" => drop_pending_updates,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          drop_pending_updates: drop_pending_updates,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/deleteWebhook"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # getWebhookInfo
      # Use this method to get current webhook status. Requires no parameters. On success, returns a WebhookInfo object. If the bot is using getUpdates, will return an object with the url field empty.
      #
      # Returns: WebhookInfo
      # See: https://core.telegram.org/bots/api#getwebhookinfo
      def get_webhook_info() : WebhookInfo
        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/getWebhookInfo"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        WebhookInfo.from_json(result_data.to_json)
      end

      # getMe
      # A simple method for testing your bot's authentication token. Requires no parameters. Returns basic information about the bot in form of a User object.
      #
      # Returns: User
      # See: https://core.telegram.org/bots/api#getme
      def get_me() : User
        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/getMe"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        User.from_json(result_data.to_json)
      end

      # logOut
      # Use this method to log out from the cloud Bot API server before launching the bot locally. You must log out the bot before running it locally, otherwise there is no guarantee that the bot will receive updates. After a successful call, you can immediately log in on a local server, but will not be able to log in back to the cloud Bot API server for 10 minutes. Returns True on success. Requires no parameters.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#logout
      def log_out() : Bool
        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/logOut"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # close
      # Use this method to close the bot instance before moving it from one local server to another. You need to delete the webhook before calling this method to ensure that the bot isn't launched again after server restart. The method will return error 429 in the first 10 minutes after the bot is launched. Returns True on success. Requires no parameters.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#close
      def close() : Bool
        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/close"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # sendMessage
      # Use this method to send text messages. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendmessage
      def send_message(chat_id : Int32 | String, text : String, business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, parse_mode : String? = nil, entities : Array(MessageEntity)? = nil, link_preview_options : LinkPreviewOptions? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
          "direct_messages_topic_id" => direct_messages_topic_id,
          "text" => text,
          "parse_mode" => parse_mode,
          "entities" => entities,
          "link_preview_options" => link_preview_options,
          "disable_notification" => disable_notification,
          "protect_content" => protect_content,
          "allow_paid_broadcast" => allow_paid_broadcast,
          "message_effect_id" => message_effect_id,
          "suggested_post_parameters" => suggested_post_parameters,
          "reply_parameters" => reply_parameters,
          "reply_markup" => reply_markup,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          chat_id: chat_id,
          message_thread_id: message_thread_id,
          direct_messages_topic_id: direct_messages_topic_id,
          text: text,
          parse_mode: parse_mode,
          entities: entities,
          link_preview_options: link_preview_options,
          disable_notification: disable_notification,
          protect_content: protect_content,
          allow_paid_broadcast: allow_paid_broadcast,
          message_effect_id: message_effect_id,
          suggested_post_parameters: suggested_post_parameters,
          reply_parameters: reply_parameters,
          reply_markup: reply_markup,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/sendMessage"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Message.from_json(result_data.to_json)
      end

      # forwardMessage
      # Use this method to forward messages of any kind. Service messages and messages with protected content can't be forwarded. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#forwardmessage
      def forward_message(chat_id : Int32 | String, from_chat_id : Int32 | String, message_id : Int32, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, video_start_timestamp : Int32? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, suggested_post_parameters : SuggestedPostParameters? = nil) : Message
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
          "direct_messages_topic_id" => direct_messages_topic_id,
          "from_chat_id" => from_chat_id,
          "video_start_timestamp" => video_start_timestamp,
          "disable_notification" => disable_notification,
          "protect_content" => protect_content,
          "suggested_post_parameters" => suggested_post_parameters,
          "message_id" => message_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          message_thread_id: message_thread_id,
          direct_messages_topic_id: direct_messages_topic_id,
          from_chat_id: from_chat_id,
          video_start_timestamp: video_start_timestamp,
          disable_notification: disable_notification,
          protect_content: protect_content,
          suggested_post_parameters: suggested_post_parameters,
          message_id: message_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/forwardMessage"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Message.from_json(result_data.to_json)
      end

      # forwardMessages
      # Use this method to forward multiple messages of any kind. If some of the specified messages can't be found or forwarded, they are skipped. Service messages and messages with protected content can't be forwarded. Album grouping is kept for forwarded messages. On success, an array of MessageId of the sent messages is returned.
      #
      # Returns: Array(MessageId)
      # See: https://core.telegram.org/bots/api#forwardmessages
      def forward_messages(chat_id : Int32 | String, from_chat_id : Int32 | String, message_ids : Array(Int32), message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil) : Array(MessageId)
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
          "direct_messages_topic_id" => direct_messages_topic_id,
          "from_chat_id" => from_chat_id,
          "message_ids" => message_ids,
          "disable_notification" => disable_notification,
          "protect_content" => protect_content,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          message_thread_id: message_thread_id,
          direct_messages_topic_id: direct_messages_topic_id,
          from_chat_id: from_chat_id,
          message_ids: message_ids,
          disable_notification: disable_notification,
          protect_content: protect_content,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/forwardMessages"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Array(MessageId).from_json(result_data.to_json)
      end

      # copyMessage
      # Use this method to copy messages of any kind. Service messages, paid media messages, giveaway messages, giveaway winners messages, and invoice messages can't be copied. A quiz poll can be copied only if the value of the field correct_option_id is known to the bot. The method is analogous to the method forwardMessage, but the copied message doesn't have a link to the original message. Returns the MessageId of the sent message on success.
      #
      # Returns: MessageId
      # See: https://core.telegram.org/bots/api#copymessage
      def copy_message(chat_id : Int32 | String, from_chat_id : Int32 | String, message_id : Int32, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, video_start_timestamp : Int32? = nil, caption : String? = nil, parse_mode : String? = nil, caption_entities : Array(MessageEntity)? = nil, show_caption_above_media : Bool? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : MessageId
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
          "direct_messages_topic_id" => direct_messages_topic_id,
          "from_chat_id" => from_chat_id,
          "message_id" => message_id,
          "video_start_timestamp" => video_start_timestamp,
          "caption" => caption,
          "parse_mode" => parse_mode,
          "caption_entities" => caption_entities,
          "show_caption_above_media" => show_caption_above_media,
          "disable_notification" => disable_notification,
          "protect_content" => protect_content,
          "allow_paid_broadcast" => allow_paid_broadcast,
          "suggested_post_parameters" => suggested_post_parameters,
          "reply_parameters" => reply_parameters,
          "reply_markup" => reply_markup,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          message_thread_id: message_thread_id,
          direct_messages_topic_id: direct_messages_topic_id,
          from_chat_id: from_chat_id,
          message_id: message_id,
          video_start_timestamp: video_start_timestamp,
          caption: caption,
          parse_mode: parse_mode,
          caption_entities: caption_entities,
          show_caption_above_media: show_caption_above_media,
          disable_notification: disable_notification,
          protect_content: protect_content,
          allow_paid_broadcast: allow_paid_broadcast,
          suggested_post_parameters: suggested_post_parameters,
          reply_parameters: reply_parameters,
          reply_markup: reply_markup,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/copyMessage"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        MessageId.from_json(result_data.to_json)
      end

      # copyMessages
      # Use this method to copy messages of any kind. If some of the specified messages can't be found or copied, they are skipped. Service messages, paid media messages, giveaway messages, giveaway winners messages, and invoice messages can't be copied. A quiz poll can be copied only if the value of the field correct_option_id is known to the bot. The method is analogous to the method forwardMessages, but the copied messages don't have a link to the original message. Album grouping is kept for copied messages. On success, an array of MessageId of the sent messages is returned.
      #
      # Returns: Array(MessageId)
      # See: https://core.telegram.org/bots/api#copymessages
      def copy_messages(chat_id : Int32 | String, from_chat_id : Int32 | String, message_ids : Array(Int32), message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, remove_caption : Bool? = nil) : Array(MessageId)
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
          "direct_messages_topic_id" => direct_messages_topic_id,
          "from_chat_id" => from_chat_id,
          "message_ids" => message_ids,
          "disable_notification" => disable_notification,
          "protect_content" => protect_content,
          "remove_caption" => remove_caption,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          message_thread_id: message_thread_id,
          direct_messages_topic_id: direct_messages_topic_id,
          from_chat_id: from_chat_id,
          message_ids: message_ids,
          disable_notification: disable_notification,
          protect_content: protect_content,
          remove_caption: remove_caption,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/copyMessages"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Array(MessageId).from_json(result_data.to_json)
      end

      # sendPhoto
      # Use this method to send photos. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendphoto
      def send_photo(chat_id : Int32 | String, photo : Telegram::InputFile | File | IO | String, business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, caption : String? = nil, parse_mode : String? = nil, caption_entities : Array(MessageEntity)? = nil, show_caption_above_media : Bool? = nil, has_spoiler : Bool? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
          "direct_messages_topic_id" => direct_messages_topic_id,
          "photo" => photo,
          "caption" => caption,
          "parse_mode" => parse_mode,
          "caption_entities" => caption_entities,
          "show_caption_above_media" => show_caption_above_media,
          "has_spoiler" => has_spoiler,
          "disable_notification" => disable_notification,
          "protect_content" => protect_content,
          "allow_paid_broadcast" => allow_paid_broadcast,
          "message_effect_id" => message_effect_id,
          "suggested_post_parameters" => suggested_post_parameters,
          "reply_parameters" => reply_parameters,
          "reply_markup" => reply_markup,
        }

        # Runtime detection: check if any parameters contain actual file data
        has_files = contains_file_data?(params_hash)

        if has_files
          # Use multipart form data for file uploads
          boundary, form_body = build_multipart_form_with_files(params_hash)
          
          # Make HTTP request with multipart form using enhanced client
          url = "#{@api_url}/bot#{@token}/sendPhoto"
          response = @http_client.post_multipart(url, {boundary, form_body})
        else
          # Use JSON request when no files are present
          params = build_request_hash_from_hash(params_hash)
          
          # Make HTTP request using enhanced client
          url = "#{@api_url}/bot#{@token}/sendPhoto"
          response = @http_client.post(url,
            headers: HTTP::Headers{"Content-Type" => "application/json"},
            body: params.to_json
          )
        end

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Message.from_json(result_data.to_json)
      end

      # sendAudio
      # Use this method to send audio files, if you want Telegram clients to display them in the music player. Your audio must be in the .MP3 or .M4A format. On success, the sent Message is returned. Bots can currently send audio files of up to 50 MB in size, this limit may be changed in the future.
      # For sending voice messages, use the sendVoice method instead.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendaudio
      def send_audio(chat_id : Int32 | String, audio : Telegram::InputFile | File | IO | String, business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, caption : String? = nil, parse_mode : String? = nil, caption_entities : Array(MessageEntity)? = nil, duration : Int32? = nil, performer : String? = nil, title : String? = nil, thumbnail : Telegram::InputFile | File | IO | String? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
          "direct_messages_topic_id" => direct_messages_topic_id,
          "audio" => audio,
          "caption" => caption,
          "parse_mode" => parse_mode,
          "caption_entities" => caption_entities,
          "duration" => duration,
          "performer" => performer,
          "title" => title,
          "thumbnail" => thumbnail,
          "disable_notification" => disable_notification,
          "protect_content" => protect_content,
          "allow_paid_broadcast" => allow_paid_broadcast,
          "message_effect_id" => message_effect_id,
          "suggested_post_parameters" => suggested_post_parameters,
          "reply_parameters" => reply_parameters,
          "reply_markup" => reply_markup,
        }

        # Runtime detection: check if any parameters contain actual file data
        has_files = contains_file_data?(params_hash)

        if has_files
          # Use multipart form data for file uploads
          boundary, form_body = build_multipart_form_with_files(params_hash)
          
          # Make HTTP request with multipart form using enhanced client
          url = "#{@api_url}/bot#{@token}/sendAudio"
          response = @http_client.post_multipart(url, {boundary, form_body})
        else
          # Use JSON request when no files are present
          params = build_request_hash_from_hash(params_hash)
          
          # Make HTTP request using enhanced client
          url = "#{@api_url}/bot#{@token}/sendAudio"
          response = @http_client.post(url,
            headers: HTTP::Headers{"Content-Type" => "application/json"},
            body: params.to_json
          )
        end

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Message.from_json(result_data.to_json)
      end

      # sendDocument
      # Use this method to send general files. On success, the sent Message is returned. Bots can currently send files of any type of up to 50 MB in size, this limit may be changed in the future.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#senddocument
      def send_document(chat_id : Int32 | String, document : Telegram::InputFile | File | IO | String, business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, thumbnail : Telegram::InputFile | File | IO | String? = nil, caption : String? = nil, parse_mode : String? = nil, caption_entities : Array(MessageEntity)? = nil, disable_content_type_detection : Bool? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
          "direct_messages_topic_id" => direct_messages_topic_id,
          "document" => document,
          "thumbnail" => thumbnail,
          "caption" => caption,
          "parse_mode" => parse_mode,
          "caption_entities" => caption_entities,
          "disable_content_type_detection" => disable_content_type_detection,
          "disable_notification" => disable_notification,
          "protect_content" => protect_content,
          "allow_paid_broadcast" => allow_paid_broadcast,
          "message_effect_id" => message_effect_id,
          "suggested_post_parameters" => suggested_post_parameters,
          "reply_parameters" => reply_parameters,
          "reply_markup" => reply_markup,
        }

        # Runtime detection: check if any parameters contain actual file data
        has_files = contains_file_data?(params_hash)

        if has_files
          # Use multipart form data for file uploads
          boundary, form_body = build_multipart_form_with_files(params_hash)
          
          # Make HTTP request with multipart form using enhanced client
          url = "#{@api_url}/bot#{@token}/sendDocument"
          response = @http_client.post_multipart(url, {boundary, form_body})
        else
          # Use JSON request when no files are present
          params = build_request_hash_from_hash(params_hash)
          
          # Make HTTP request using enhanced client
          url = "#{@api_url}/bot#{@token}/sendDocument"
          response = @http_client.post(url,
            headers: HTTP::Headers{"Content-Type" => "application/json"},
            body: params.to_json
          )
        end

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Message.from_json(result_data.to_json)
      end

      # sendVideo
      # Use this method to send video files, Telegram clients support MPEG4 videos (other formats may be sent as Document). On success, the sent Message is returned. Bots can currently send video files of up to 50 MB in size, this limit may be changed in the future.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendvideo
      def send_video(chat_id : Int32 | String, video : Telegram::InputFile | File | IO | String, business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, duration : Int32? = nil, width : Int32? = nil, height : Int32? = nil, thumbnail : Telegram::InputFile | File | IO | String? = nil, cover : Telegram::InputFile | File | IO | String? = nil, start_timestamp : Int32? = nil, caption : String? = nil, parse_mode : String? = nil, caption_entities : Array(MessageEntity)? = nil, show_caption_above_media : Bool? = nil, has_spoiler : Bool? = nil, supports_streaming : Bool? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
          "direct_messages_topic_id" => direct_messages_topic_id,
          "video" => video,
          "duration" => duration,
          "width" => width,
          "height" => height,
          "thumbnail" => thumbnail,
          "cover" => cover,
          "start_timestamp" => start_timestamp,
          "caption" => caption,
          "parse_mode" => parse_mode,
          "caption_entities" => caption_entities,
          "show_caption_above_media" => show_caption_above_media,
          "has_spoiler" => has_spoiler,
          "supports_streaming" => supports_streaming,
          "disable_notification" => disable_notification,
          "protect_content" => protect_content,
          "allow_paid_broadcast" => allow_paid_broadcast,
          "message_effect_id" => message_effect_id,
          "suggested_post_parameters" => suggested_post_parameters,
          "reply_parameters" => reply_parameters,
          "reply_markup" => reply_markup,
        }

        # Runtime detection: check if any parameters contain actual file data
        has_files = contains_file_data?(params_hash)

        if has_files
          # Use multipart form data for file uploads
          boundary, form_body = build_multipart_form_with_files(params_hash)
          
          # Make HTTP request with multipart form using enhanced client
          url = "#{@api_url}/bot#{@token}/sendVideo"
          response = @http_client.post_multipart(url, {boundary, form_body})
        else
          # Use JSON request when no files are present
          params = build_request_hash_from_hash(params_hash)
          
          # Make HTTP request using enhanced client
          url = "#{@api_url}/bot#{@token}/sendVideo"
          response = @http_client.post(url,
            headers: HTTP::Headers{"Content-Type" => "application/json"},
            body: params.to_json
          )
        end

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Message.from_json(result_data.to_json)
      end

      # sendAnimation
      # Use this method to send animation files (GIF or H.264/MPEG-4 AVC video without sound). On success, the sent Message is returned. Bots can currently send animation files of up to 50 MB in size, this limit may be changed in the future.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendanimation
      def send_animation(chat_id : Int32 | String, animation : Telegram::InputFile | File | IO | String, business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, duration : Int32? = nil, width : Int32? = nil, height : Int32? = nil, thumbnail : Telegram::InputFile | File | IO | String? = nil, caption : String? = nil, parse_mode : String? = nil, caption_entities : Array(MessageEntity)? = nil, show_caption_above_media : Bool? = nil, has_spoiler : Bool? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
          "direct_messages_topic_id" => direct_messages_topic_id,
          "animation" => animation,
          "duration" => duration,
          "width" => width,
          "height" => height,
          "thumbnail" => thumbnail,
          "caption" => caption,
          "parse_mode" => parse_mode,
          "caption_entities" => caption_entities,
          "show_caption_above_media" => show_caption_above_media,
          "has_spoiler" => has_spoiler,
          "disable_notification" => disable_notification,
          "protect_content" => protect_content,
          "allow_paid_broadcast" => allow_paid_broadcast,
          "message_effect_id" => message_effect_id,
          "suggested_post_parameters" => suggested_post_parameters,
          "reply_parameters" => reply_parameters,
          "reply_markup" => reply_markup,
        }

        # Runtime detection: check if any parameters contain actual file data
        has_files = contains_file_data?(params_hash)

        if has_files
          # Use multipart form data for file uploads
          boundary, form_body = build_multipart_form_with_files(params_hash)
          
          # Make HTTP request with multipart form using enhanced client
          url = "#{@api_url}/bot#{@token}/sendAnimation"
          response = @http_client.post_multipart(url, {boundary, form_body})
        else
          # Use JSON request when no files are present
          params = build_request_hash_from_hash(params_hash)
          
          # Make HTTP request using enhanced client
          url = "#{@api_url}/bot#{@token}/sendAnimation"
          response = @http_client.post(url,
            headers: HTTP::Headers{"Content-Type" => "application/json"},
            body: params.to_json
          )
        end

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Message.from_json(result_data.to_json)
      end

      # sendVoice
      # Use this method to send audio files, if you want Telegram clients to display the file as a playable voice message. For this to work, your audio must be in an .OGG file encoded with OPUS, or in .MP3 format, or in .M4A format (other formats may be sent as Audio or Document). On success, the sent Message is returned. Bots can currently send voice messages of up to 50 MB in size, this limit may be changed in the future.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendvoice
      def send_voice(chat_id : Int32 | String, voice : Telegram::InputFile | File | IO | String, business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, caption : String? = nil, parse_mode : String? = nil, caption_entities : Array(MessageEntity)? = nil, duration : Int32? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
          "direct_messages_topic_id" => direct_messages_topic_id,
          "voice" => voice,
          "caption" => caption,
          "parse_mode" => parse_mode,
          "caption_entities" => caption_entities,
          "duration" => duration,
          "disable_notification" => disable_notification,
          "protect_content" => protect_content,
          "allow_paid_broadcast" => allow_paid_broadcast,
          "message_effect_id" => message_effect_id,
          "suggested_post_parameters" => suggested_post_parameters,
          "reply_parameters" => reply_parameters,
          "reply_markup" => reply_markup,
        }

        # Runtime detection: check if any parameters contain actual file data
        has_files = contains_file_data?(params_hash)

        if has_files
          # Use multipart form data for file uploads
          boundary, form_body = build_multipart_form_with_files(params_hash)
          
          # Make HTTP request with multipart form using enhanced client
          url = "#{@api_url}/bot#{@token}/sendVoice"
          response = @http_client.post_multipart(url, {boundary, form_body})
        else
          # Use JSON request when no files are present
          params = build_request_hash_from_hash(params_hash)
          
          # Make HTTP request using enhanced client
          url = "#{@api_url}/bot#{@token}/sendVoice"
          response = @http_client.post(url,
            headers: HTTP::Headers{"Content-Type" => "application/json"},
            body: params.to_json
          )
        end

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Message.from_json(result_data.to_json)
      end

      # sendVideoNote
      # As of v.4.0, Telegram clients support rounded square MPEG4 videos of up to 1 minute long. Use this method to send video messages. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendvideonote
      def send_video_note(chat_id : Int32 | String, video_note : Telegram::InputFile | File | IO | String, business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, duration : Int32? = nil, length : Int32? = nil, thumbnail : Telegram::InputFile | File | IO | String? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
          "direct_messages_topic_id" => direct_messages_topic_id,
          "video_note" => video_note,
          "duration" => duration,
          "length" => length,
          "thumbnail" => thumbnail,
          "disable_notification" => disable_notification,
          "protect_content" => protect_content,
          "allow_paid_broadcast" => allow_paid_broadcast,
          "message_effect_id" => message_effect_id,
          "suggested_post_parameters" => suggested_post_parameters,
          "reply_parameters" => reply_parameters,
          "reply_markup" => reply_markup,
        }

        # Runtime detection: check if any parameters contain actual file data
        has_files = contains_file_data?(params_hash)

        if has_files
          # Use multipart form data for file uploads
          boundary, form_body = build_multipart_form_with_files(params_hash)
          
          # Make HTTP request with multipart form using enhanced client
          url = "#{@api_url}/bot#{@token}/sendVideoNote"
          response = @http_client.post_multipart(url, {boundary, form_body})
        else
          # Use JSON request when no files are present
          params = build_request_hash_from_hash(params_hash)
          
          # Make HTTP request using enhanced client
          url = "#{@api_url}/bot#{@token}/sendVideoNote"
          response = @http_client.post(url,
            headers: HTTP::Headers{"Content-Type" => "application/json"},
            body: params.to_json
          )
        end

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Message.from_json(result_data.to_json)
      end

      # sendPaidMedia
      # Use this method to send paid media. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendpaidmedia
      def send_paid_media(chat_id : Int32 | String, star_count : Int32, media : Array(InputPaidMedia), business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, payload : String? = nil, caption : String? = nil, parse_mode : String? = nil, caption_entities : Array(MessageEntity)? = nil, show_caption_above_media : Bool? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
          "direct_messages_topic_id" => direct_messages_topic_id,
          "star_count" => star_count,
          "media" => media,
          "payload" => payload,
          "caption" => caption,
          "parse_mode" => parse_mode,
          "caption_entities" => caption_entities,
          "show_caption_above_media" => show_caption_above_media,
          "disable_notification" => disable_notification,
          "protect_content" => protect_content,
          "allow_paid_broadcast" => allow_paid_broadcast,
          "suggested_post_parameters" => suggested_post_parameters,
          "reply_parameters" => reply_parameters,
          "reply_markup" => reply_markup,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          chat_id: chat_id,
          message_thread_id: message_thread_id,
          direct_messages_topic_id: direct_messages_topic_id,
          star_count: star_count,
          media: media,
          payload: payload,
          caption: caption,
          parse_mode: parse_mode,
          caption_entities: caption_entities,
          show_caption_above_media: show_caption_above_media,
          disable_notification: disable_notification,
          protect_content: protect_content,
          allow_paid_broadcast: allow_paid_broadcast,
          suggested_post_parameters: suggested_post_parameters,
          reply_parameters: reply_parameters,
          reply_markup: reply_markup,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/sendPaidMedia"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Message.from_json(result_data.to_json)
      end

      # sendMediaGroup
      # Use this method to send a group of photos, videos, documents or audios as an album. Documents and audio files can be only grouped in an album with messages of the same type. On success, an array of Message objects that were sent is returned.
      #
      # Returns: Array(Message)
      # See: https://core.telegram.org/bots/api#sendmediagroup
      def send_media_group(chat_id : Int32 | String, media : Array(InputMediaAudio) | Array(InputMediaDocument) | Array(InputMediaPhoto) | Array(InputMediaVideo), business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, reply_parameters : ReplyParameters? = nil) : Array(Message)
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
          "direct_messages_topic_id" => direct_messages_topic_id,
          "media" => media,
          "disable_notification" => disable_notification,
          "protect_content" => protect_content,
          "allow_paid_broadcast" => allow_paid_broadcast,
          "message_effect_id" => message_effect_id,
          "reply_parameters" => reply_parameters,
        }

        # Runtime detection: check if any parameters contain actual file data
        has_files = contains_file_data?(params_hash)

        if has_files
          # Use multipart form data for file uploads
          boundary, form_body = build_multipart_form_with_files(params_hash)
          
          # Make HTTP request with multipart form using enhanced client
          url = "#{@api_url}/bot#{@token}/sendMediaGroup"
          response = @http_client.post_multipart(url, {boundary, form_body})
        else
          # Use JSON request when no files are present
          params = build_request_hash_from_hash(params_hash)
          
          # Make HTTP request using enhanced client
          url = "#{@api_url}/bot#{@token}/sendMediaGroup"
          response = @http_client.post(url,
            headers: HTTP::Headers{"Content-Type" => "application/json"},
            body: params.to_json
          )
        end

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Array(Message).from_json(result_data.to_json)
      end

      # sendLocation
      # Use this method to send point on the map. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendlocation
      def send_location(chat_id : Int32 | String, latitude : Float64, longitude : Float64, business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, horizontal_accuracy : Float64? = nil, live_period : Int32? = nil, heading : Int32? = nil, proximity_alert_radius : Int32? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
          "direct_messages_topic_id" => direct_messages_topic_id,
          "latitude" => latitude,
          "longitude" => longitude,
          "horizontal_accuracy" => horizontal_accuracy,
          "live_period" => live_period,
          "heading" => heading,
          "proximity_alert_radius" => proximity_alert_radius,
          "disable_notification" => disable_notification,
          "protect_content" => protect_content,
          "allow_paid_broadcast" => allow_paid_broadcast,
          "message_effect_id" => message_effect_id,
          "suggested_post_parameters" => suggested_post_parameters,
          "reply_parameters" => reply_parameters,
          "reply_markup" => reply_markup,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          chat_id: chat_id,
          message_thread_id: message_thread_id,
          direct_messages_topic_id: direct_messages_topic_id,
          latitude: latitude,
          longitude: longitude,
          horizontal_accuracy: horizontal_accuracy,
          live_period: live_period,
          heading: heading,
          proximity_alert_radius: proximity_alert_radius,
          disable_notification: disable_notification,
          protect_content: protect_content,
          allow_paid_broadcast: allow_paid_broadcast,
          message_effect_id: message_effect_id,
          suggested_post_parameters: suggested_post_parameters,
          reply_parameters: reply_parameters,
          reply_markup: reply_markup,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/sendLocation"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Message.from_json(result_data.to_json)
      end

      # sendVenue
      # Use this method to send information about a venue. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendvenue
      def send_venue(chat_id : Int32 | String, latitude : Float64, longitude : Float64, title : String, address : String, business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, foursquare_id : String? = nil, foursquare_type : String? = nil, google_place_id : String? = nil, google_place_type : String? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
          "direct_messages_topic_id" => direct_messages_topic_id,
          "latitude" => latitude,
          "longitude" => longitude,
          "title" => title,
          "address" => address,
          "foursquare_id" => foursquare_id,
          "foursquare_type" => foursquare_type,
          "google_place_id" => google_place_id,
          "google_place_type" => google_place_type,
          "disable_notification" => disable_notification,
          "protect_content" => protect_content,
          "allow_paid_broadcast" => allow_paid_broadcast,
          "message_effect_id" => message_effect_id,
          "suggested_post_parameters" => suggested_post_parameters,
          "reply_parameters" => reply_parameters,
          "reply_markup" => reply_markup,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          chat_id: chat_id,
          message_thread_id: message_thread_id,
          direct_messages_topic_id: direct_messages_topic_id,
          latitude: latitude,
          longitude: longitude,
          title: title,
          address: address,
          foursquare_id: foursquare_id,
          foursquare_type: foursquare_type,
          google_place_id: google_place_id,
          google_place_type: google_place_type,
          disable_notification: disable_notification,
          protect_content: protect_content,
          allow_paid_broadcast: allow_paid_broadcast,
          message_effect_id: message_effect_id,
          suggested_post_parameters: suggested_post_parameters,
          reply_parameters: reply_parameters,
          reply_markup: reply_markup,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/sendVenue"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Message.from_json(result_data.to_json)
      end

      # sendContact
      # Use this method to send phone contacts. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendcontact
      def send_contact(chat_id : Int32 | String, phone_number : String, first_name : String, business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, last_name : String? = nil, vcard : String? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
          "direct_messages_topic_id" => direct_messages_topic_id,
          "phone_number" => phone_number,
          "first_name" => first_name,
          "last_name" => last_name,
          "vcard" => vcard,
          "disable_notification" => disable_notification,
          "protect_content" => protect_content,
          "allow_paid_broadcast" => allow_paid_broadcast,
          "message_effect_id" => message_effect_id,
          "suggested_post_parameters" => suggested_post_parameters,
          "reply_parameters" => reply_parameters,
          "reply_markup" => reply_markup,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          chat_id: chat_id,
          message_thread_id: message_thread_id,
          direct_messages_topic_id: direct_messages_topic_id,
          phone_number: phone_number,
          first_name: first_name,
          last_name: last_name,
          vcard: vcard,
          disable_notification: disable_notification,
          protect_content: protect_content,
          allow_paid_broadcast: allow_paid_broadcast,
          message_effect_id: message_effect_id,
          suggested_post_parameters: suggested_post_parameters,
          reply_parameters: reply_parameters,
          reply_markup: reply_markup,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/sendContact"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Message.from_json(result_data.to_json)
      end

      # sendPoll
      # Use this method to send a native poll. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendpoll
      def send_poll(chat_id : Int32 | String, question : String, options : Array(InputPollOption), business_connection_id : String? = nil, message_thread_id : Int32? = nil, question_parse_mode : String? = nil, question_entities : Array(MessageEntity)? = nil, is_anonymous : Bool? = nil, type : String? = nil, allows_multiple_answers : Bool? = nil, correct_option_id : Int32? = nil, explanation : String? = nil, explanation_parse_mode : String? = nil, explanation_entities : Array(MessageEntity)? = nil, open_period : Int32? = nil, close_date : Int32? = nil, is_closed : Bool? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
          "question" => question,
          "question_parse_mode" => question_parse_mode,
          "question_entities" => question_entities,
          "options" => options,
          "is_anonymous" => is_anonymous,
          "type" => type,
          "allows_multiple_answers" => allows_multiple_answers,
          "correct_option_id" => correct_option_id,
          "explanation" => explanation,
          "explanation_parse_mode" => explanation_parse_mode,
          "explanation_entities" => explanation_entities,
          "open_period" => open_period,
          "close_date" => close_date,
          "is_closed" => is_closed,
          "disable_notification" => disable_notification,
          "protect_content" => protect_content,
          "allow_paid_broadcast" => allow_paid_broadcast,
          "message_effect_id" => message_effect_id,
          "reply_parameters" => reply_parameters,
          "reply_markup" => reply_markup,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          chat_id: chat_id,
          message_thread_id: message_thread_id,
          question: question,
          question_parse_mode: question_parse_mode,
          question_entities: question_entities,
          options: options,
          is_anonymous: is_anonymous,
          type: type,
          allows_multiple_answers: allows_multiple_answers,
          correct_option_id: correct_option_id,
          explanation: explanation,
          explanation_parse_mode: explanation_parse_mode,
          explanation_entities: explanation_entities,
          open_period: open_period,
          close_date: close_date,
          is_closed: is_closed,
          disable_notification: disable_notification,
          protect_content: protect_content,
          allow_paid_broadcast: allow_paid_broadcast,
          message_effect_id: message_effect_id,
          reply_parameters: reply_parameters,
          reply_markup: reply_markup,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/sendPoll"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Message.from_json(result_data.to_json)
      end

      # sendChecklist
      # Use this method to send a checklist on behalf of a connected business account. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendchecklist
      def send_checklist(business_connection_id : String, chat_id : Int32, checklist : InputChecklist, disable_notification : Bool? = nil, protect_content : Bool? = nil, message_effect_id : String? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup? = nil) : Message
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "checklist" => checklist,
          "disable_notification" => disable_notification,
          "protect_content" => protect_content,
          "message_effect_id" => message_effect_id,
          "reply_parameters" => reply_parameters,
          "reply_markup" => reply_markup,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          chat_id: chat_id,
          checklist: checklist,
          disable_notification: disable_notification,
          protect_content: protect_content,
          message_effect_id: message_effect_id,
          reply_parameters: reply_parameters,
          reply_markup: reply_markup,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/sendChecklist"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Message.from_json(result_data.to_json)
      end

      # sendDice
      # Use this method to send an animated emoji that will display a random value. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#senddice
      def send_dice(chat_id : Int32 | String, business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, emoji : String? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
          "direct_messages_topic_id" => direct_messages_topic_id,
          "emoji" => emoji,
          "disable_notification" => disable_notification,
          "protect_content" => protect_content,
          "allow_paid_broadcast" => allow_paid_broadcast,
          "message_effect_id" => message_effect_id,
          "suggested_post_parameters" => suggested_post_parameters,
          "reply_parameters" => reply_parameters,
          "reply_markup" => reply_markup,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          chat_id: chat_id,
          message_thread_id: message_thread_id,
          direct_messages_topic_id: direct_messages_topic_id,
          emoji: emoji,
          disable_notification: disable_notification,
          protect_content: protect_content,
          allow_paid_broadcast: allow_paid_broadcast,
          message_effect_id: message_effect_id,
          suggested_post_parameters: suggested_post_parameters,
          reply_parameters: reply_parameters,
          reply_markup: reply_markup,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/sendDice"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Message.from_json(result_data.to_json)
      end

      # sendChatAction
      # Use this method when you need to tell the user that something is happening on the bot's side. The status is set for 5 seconds or less (when a message arrives from your bot, Telegram clients clear its typing status). Returns True on success.
      # We only recommend using this method when a response from the bot will take a noticeable amount of time to arrive.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#sendchataction
      def send_chat_action(chat_id : Int32 | String, action : String, business_connection_id : String? = nil, message_thread_id : Int32? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
          "action" => action,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          chat_id: chat_id,
          message_thread_id: message_thread_id,
          action: action,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/sendChatAction"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # setMessageReaction
      # Use this method to change the chosen reactions on a message. Service messages of some types can't be reacted to. Automatically forwarded messages from a channel to its discussion group have the same available reactions as messages in the channel. Bots can't use paid reactions. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setmessagereaction
      def set_message_reaction(chat_id : Int32 | String, message_id : Int32, reaction : Array(ReactionType)? = nil, is_big : Bool? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "message_id" => message_id,
          "reaction" => reaction,
          "is_big" => is_big,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          message_id: message_id,
          reaction: reaction,
          is_big: is_big,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/setMessageReaction"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # getUserProfilePhotos
      # Use this method to get a list of profile pictures for a user. Returns a UserProfilePhotos object.
      #
      # Returns: UserProfilePhotos
      # See: https://core.telegram.org/bots/api#getuserprofilephotos
      def get_user_profile_photos(user_id : Int32, offset : Int32? = nil, limit : Int32? = nil) : UserProfilePhotos
        # Collect parameters for file detection
        params_hash = {
          "user_id" => user_id,
          "offset" => offset,
          "limit" => limit,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          user_id: user_id,
          offset: offset,
          limit: limit,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/getUserProfilePhotos"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        UserProfilePhotos.from_json(result_data.to_json)
      end

      # setUserEmojiStatus
      # Changes the emoji status for a given user that previously allowed the bot to manage their emoji status via the Mini App method requestEmojiStatusAccess. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setuseremojistatus
      def set_user_emoji_status(user_id : Int32, emoji_status_custom_emoji_id : String? = nil, emoji_status_expiration_date : Int32? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "user_id" => user_id,
          "emoji_status_custom_emoji_id" => emoji_status_custom_emoji_id,
          "emoji_status_expiration_date" => emoji_status_expiration_date,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          user_id: user_id,
          emoji_status_custom_emoji_id: emoji_status_custom_emoji_id,
          emoji_status_expiration_date: emoji_status_expiration_date,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/setUserEmojiStatus"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # getFile
      # Use this method to get basic information about a file and prepare it for downloading. For the moment, bots can download files of up to 20MB in size. On success, a File object is returned. The file can then be downloaded via the link https://api.telegram.org/file/bot<token>/<file_path>, where <file_path> is taken from the response. It is guaranteed that the link will be valid for at least 1 hour. When the link expires, a new one can be requested by calling getFile again.
      # Note: This function may not preserve the original file name and MIME type. You should save the file's MIME type and name (if available) when the File object is received.
      #
      # Returns: TelegramFile
      # See: https://core.telegram.org/bots/api#getfile
      def get_file(file_id : String) : TelegramFile
        # Collect parameters for file detection
        params_hash = {
          "file_id" => file_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          file_id: file_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/getFile"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        TelegramFile.from_json(result_data.to_json)
      end

      # banChatMember
      # Use this method to ban a user in a group, a supergroup or a channel. In the case of supergroups and channels, the user will not be able to return to the chat on their own using invite links, etc., unless unbanned first. The bot must be an administrator in the chat for this to work and must have the appropriate administrator rights. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#banchatmember
      def ban_chat_member(chat_id : Int32 | String, user_id : Int32, until_date : Int32? = nil, revoke_messages : Bool? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "user_id" => user_id,
          "until_date" => until_date,
          "revoke_messages" => revoke_messages,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          user_id: user_id,
          until_date: until_date,
          revoke_messages: revoke_messages,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/banChatMember"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # unbanChatMember
      # Use this method to unban a previously banned user in a supergroup or channel. The user will not return to the group or channel automatically, but will be able to join via link, etc. The bot must be an administrator for this to work. By default, this method guarantees that after the call the user is not a member of the chat, but will be able to join it. So if the user is a member of the chat they will also be removed from the chat. If you don't want this, use the parameter only_if_banned. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#unbanchatmember
      def unban_chat_member(chat_id : Int32 | String, user_id : Int32, only_if_banned : Bool? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "user_id" => user_id,
          "only_if_banned" => only_if_banned,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          user_id: user_id,
          only_if_banned: only_if_banned,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/unbanChatMember"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # restrictChatMember
      # Use this method to restrict a user in a supergroup. The bot must be an administrator in the supergroup for this to work and must have the appropriate administrator rights. Pass True for all permissions to lift restrictions from a user. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#restrictchatmember
      def restrict_chat_member(chat_id : Int32 | String, user_id : Int32, permissions : ChatPermissions, use_independent_chat_permissions : Bool? = nil, until_date : Int32? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "user_id" => user_id,
          "permissions" => permissions,
          "use_independent_chat_permissions" => use_independent_chat_permissions,
          "until_date" => until_date,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          user_id: user_id,
          permissions: permissions,
          use_independent_chat_permissions: use_independent_chat_permissions,
          until_date: until_date,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/restrictChatMember"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # promoteChatMember
      # Use this method to promote or demote a user in a supergroup or a channel. The bot must be an administrator in the chat for this to work and must have the appropriate administrator rights. Pass False for all boolean parameters to demote a user. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#promotechatmember
      def promote_chat_member(chat_id : Int32 | String, user_id : Int32, is_anonymous : Bool? = nil, can_manage_chat : Bool? = nil, can_delete_messages : Bool? = nil, can_manage_video_chats : Bool? = nil, can_restrict_members : Bool? = nil, can_promote_members : Bool? = nil, can_change_info : Bool? = nil, can_invite_users : Bool? = nil, can_post_stories : Bool? = nil, can_edit_stories : Bool? = nil, can_delete_stories : Bool? = nil, can_post_messages : Bool? = nil, can_edit_messages : Bool? = nil, can_pin_messages : Bool? = nil, can_manage_topics : Bool? = nil, can_manage_direct_messages : Bool? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "user_id" => user_id,
          "is_anonymous" => is_anonymous,
          "can_manage_chat" => can_manage_chat,
          "can_delete_messages" => can_delete_messages,
          "can_manage_video_chats" => can_manage_video_chats,
          "can_restrict_members" => can_restrict_members,
          "can_promote_members" => can_promote_members,
          "can_change_info" => can_change_info,
          "can_invite_users" => can_invite_users,
          "can_post_stories" => can_post_stories,
          "can_edit_stories" => can_edit_stories,
          "can_delete_stories" => can_delete_stories,
          "can_post_messages" => can_post_messages,
          "can_edit_messages" => can_edit_messages,
          "can_pin_messages" => can_pin_messages,
          "can_manage_topics" => can_manage_topics,
          "can_manage_direct_messages" => can_manage_direct_messages,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          user_id: user_id,
          is_anonymous: is_anonymous,
          can_manage_chat: can_manage_chat,
          can_delete_messages: can_delete_messages,
          can_manage_video_chats: can_manage_video_chats,
          can_restrict_members: can_restrict_members,
          can_promote_members: can_promote_members,
          can_change_info: can_change_info,
          can_invite_users: can_invite_users,
          can_post_stories: can_post_stories,
          can_edit_stories: can_edit_stories,
          can_delete_stories: can_delete_stories,
          can_post_messages: can_post_messages,
          can_edit_messages: can_edit_messages,
          can_pin_messages: can_pin_messages,
          can_manage_topics: can_manage_topics,
          can_manage_direct_messages: can_manage_direct_messages,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/promoteChatMember"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # setChatAdministratorCustomTitle
      # Use this method to set a custom title for an administrator in a supergroup promoted by the bot. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setchatadministratorcustomtitle
      def set_chat_administrator_custom_title(chat_id : Int32 | String, user_id : Int32, custom_title : String) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "user_id" => user_id,
          "custom_title" => custom_title,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          user_id: user_id,
          custom_title: custom_title,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/setChatAdministratorCustomTitle"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # banChatSenderChat
      # Use this method to ban a channel chat in a supergroup or a channel. Until the chat is unbanned, the owner of the banned chat won't be able to send messages on behalf of any of their channels. The bot must be an administrator in the supergroup or channel for this to work and must have the appropriate administrator rights. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#banchatsenderchat
      def ban_chat_sender_chat(chat_id : Int32 | String, sender_chat_id : Int32) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "sender_chat_id" => sender_chat_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          sender_chat_id: sender_chat_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/banChatSenderChat"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # unbanChatSenderChat
      # Use this method to unban a previously banned channel chat in a supergroup or channel. The bot must be an administrator for this to work and must have the appropriate administrator rights. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#unbanchatsenderchat
      def unban_chat_sender_chat(chat_id : Int32 | String, sender_chat_id : Int32) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "sender_chat_id" => sender_chat_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          sender_chat_id: sender_chat_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/unbanChatSenderChat"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # setChatPermissions
      # Use this method to set default chat permissions for all members. The bot must be an administrator in the group or a supergroup for this to work and must have the can_restrict_members administrator rights. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setchatpermissions
      def set_chat_permissions(chat_id : Int32 | String, permissions : ChatPermissions, use_independent_chat_permissions : Bool? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "permissions" => permissions,
          "use_independent_chat_permissions" => use_independent_chat_permissions,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          permissions: permissions,
          use_independent_chat_permissions: use_independent_chat_permissions,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/setChatPermissions"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # exportChatInviteLink
      # Use this method to generate a new primary invite link for a chat; any previously generated primary link is revoked. The bot must be an administrator in the chat for this to work and must have the appropriate administrator rights. Returns the new invite link as String on success.
      #
      # Returns: String
      # See: https://core.telegram.org/bots/api#exportchatinvitelink
      def export_chat_invite_link(chat_id : Int32 | String) : String
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/exportChatInviteLink"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        String.from_json(result_data.to_json)
      end

      # createChatInviteLink
      # Use this method to create an additional invite link for a chat. The bot must be an administrator in the chat for this to work and must have the appropriate administrator rights. The link can be revoked using the method revokeChatInviteLink. Returns the new invite link as ChatInviteLink object.
      #
      # Returns: ChatInviteLink
      # See: https://core.telegram.org/bots/api#createchatinvitelink
      def create_chat_invite_link(chat_id : Int32 | String, name : String? = nil, expire_date : Int32? = nil, member_limit : Int32? = nil, creates_join_request : Bool? = nil) : ChatInviteLink
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "name" => name,
          "expire_date" => expire_date,
          "member_limit" => member_limit,
          "creates_join_request" => creates_join_request,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          name: name,
          expire_date: expire_date,
          member_limit: member_limit,
          creates_join_request: creates_join_request,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/createChatInviteLink"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        ChatInviteLink.from_json(result_data.to_json)
      end

      # editChatInviteLink
      # Use this method to edit a non-primary invite link created by the bot. The bot must be an administrator in the chat for this to work and must have the appropriate administrator rights. Returns the edited invite link as a ChatInviteLink object.
      #
      # Returns: ChatInviteLink
      # See: https://core.telegram.org/bots/api#editchatinvitelink
      def edit_chat_invite_link(chat_id : Int32 | String, invite_link : String, name : String? = nil, expire_date : Int32? = nil, member_limit : Int32? = nil, creates_join_request : Bool? = nil) : ChatInviteLink
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "invite_link" => invite_link,
          "name" => name,
          "expire_date" => expire_date,
          "member_limit" => member_limit,
          "creates_join_request" => creates_join_request,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          invite_link: invite_link,
          name: name,
          expire_date: expire_date,
          member_limit: member_limit,
          creates_join_request: creates_join_request,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/editChatInviteLink"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        ChatInviteLink.from_json(result_data.to_json)
      end

      # createChatSubscriptionInviteLink
      # Use this method to create a subscription invite link for a channel chat. The bot must have the can_invite_users administrator rights. The link can be edited using the method editChatSubscriptionInviteLink or revoked using the method revokeChatInviteLink. Returns the new invite link as a ChatInviteLink object.
      #
      # Returns: ChatInviteLink
      # See: https://core.telegram.org/bots/api#createchatsubscriptioninvitelink
      def create_chat_subscription_invite_link(chat_id : Int32 | String, subscription_period : Int32, subscription_price : Int32, name : String? = nil) : ChatInviteLink
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "name" => name,
          "subscription_period" => subscription_period,
          "subscription_price" => subscription_price,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          name: name,
          subscription_period: subscription_period,
          subscription_price: subscription_price,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/createChatSubscriptionInviteLink"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        ChatInviteLink.from_json(result_data.to_json)
      end

      # editChatSubscriptionInviteLink
      # Use this method to edit a subscription invite link created by the bot. The bot must have the can_invite_users administrator rights. Returns the edited invite link as a ChatInviteLink object.
      #
      # Returns: ChatInviteLink
      # See: https://core.telegram.org/bots/api#editchatsubscriptioninvitelink
      def edit_chat_subscription_invite_link(chat_id : Int32 | String, invite_link : String, name : String? = nil) : ChatInviteLink
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "invite_link" => invite_link,
          "name" => name,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          invite_link: invite_link,
          name: name,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/editChatSubscriptionInviteLink"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        ChatInviteLink.from_json(result_data.to_json)
      end

      # revokeChatInviteLink
      # Use this method to revoke an invite link created by the bot. If the primary link is revoked, a new link is automatically generated. The bot must be an administrator in the chat for this to work and must have the appropriate administrator rights. Returns the revoked invite link as ChatInviteLink object.
      #
      # Returns: ChatInviteLink
      # See: https://core.telegram.org/bots/api#revokechatinvitelink
      def revoke_chat_invite_link(chat_id : Int32 | String, invite_link : String) : ChatInviteLink
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "invite_link" => invite_link,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          invite_link: invite_link,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/revokeChatInviteLink"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        ChatInviteLink.from_json(result_data.to_json)
      end

      # approveChatJoinRequest
      # Use this method to approve a chat join request. The bot must be an administrator in the chat for this to work and must have the can_invite_users administrator right. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#approvechatjoinrequest
      def approve_chat_join_request(chat_id : Int32 | String, user_id : Int32) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "user_id" => user_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          user_id: user_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/approveChatJoinRequest"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # declineChatJoinRequest
      # Use this method to decline a chat join request. The bot must be an administrator in the chat for this to work and must have the can_invite_users administrator right. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#declinechatjoinrequest
      def decline_chat_join_request(chat_id : Int32 | String, user_id : Int32) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "user_id" => user_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          user_id: user_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/declineChatJoinRequest"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # setChatPhoto
      # Use this method to set a new profile photo for the chat. Photos can't be changed for private chats. The bot must be an administrator in the chat for this to work and must have the appropriate administrator rights. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setchatphoto
      def set_chat_photo(chat_id : Int32 | String, photo : Telegram::InputFile | File | IO) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "photo" => photo,
        }

        # Runtime detection: check if any parameters contain actual file data
        has_files = contains_file_data?(params_hash)

        if has_files
          # Use multipart form data for file uploads
          boundary, form_body = build_multipart_form_with_files(params_hash)
          
          # Make HTTP request with multipart form using enhanced client
          url = "#{@api_url}/bot#{@token}/setChatPhoto"
          response = @http_client.post_multipart(url, {boundary, form_body})
        else
          # Use JSON request when no files are present
          params = build_request_hash_from_hash(params_hash)
          
          # Make HTTP request using enhanced client
          url = "#{@api_url}/bot#{@token}/setChatPhoto"
          response = @http_client.post(url,
            headers: HTTP::Headers{"Content-Type" => "application/json"},
            body: params.to_json
          )
        end

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # deleteChatPhoto
      # Use this method to delete a chat photo. Photos can't be changed for private chats. The bot must be an administrator in the chat for this to work and must have the appropriate administrator rights. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#deletechatphoto
      def delete_chat_photo(chat_id : Int32 | String) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/deleteChatPhoto"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # setChatTitle
      # Use this method to change the title of a chat. Titles can't be changed for private chats. The bot must be an administrator in the chat for this to work and must have the appropriate administrator rights. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setchattitle
      def set_chat_title(chat_id : Int32 | String, title : String) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "title" => title,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          title: title,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/setChatTitle"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # setChatDescription
      # Use this method to change the description of a group, a supergroup or a channel. The bot must be an administrator in the chat for this to work and must have the appropriate administrator rights. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setchatdescription
      def set_chat_description(chat_id : Int32 | String, description : String? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "description" => description,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          description: description,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/setChatDescription"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # pinChatMessage
      # Use this method to add a message to the list of pinned messages in a chat. In private chats and channel direct messages chats, all non-service messages can be pinned. Conversely, the bot must be an administrator with the 'can_pin_messages' right or the 'can_edit_messages' right to pin messages in groups and channels respectively. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#pinchatmessage
      def pin_chat_message(chat_id : Int32 | String, message_id : Int32, business_connection_id : String? = nil, disable_notification : Bool? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_id" => message_id,
          "disable_notification" => disable_notification,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          chat_id: chat_id,
          message_id: message_id,
          disable_notification: disable_notification,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/pinChatMessage"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # unpinChatMessage
      # Use this method to remove a message from the list of pinned messages in a chat. In private chats and channel direct messages chats, all messages can be unpinned. Conversely, the bot must be an administrator with the 'can_pin_messages' right or the 'can_edit_messages' right to unpin messages in groups and channels respectively. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#unpinchatmessage
      def unpin_chat_message(chat_id : Int32 | String, business_connection_id : String? = nil, message_id : Int32? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_id" => message_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          chat_id: chat_id,
          message_id: message_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/unpinChatMessage"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # unpinAllChatMessages
      # Use this method to clear the list of pinned messages in a chat. In private chats and channel direct messages chats, no additional rights are required to unpin all pinned messages. Conversely, the bot must be an administrator with the 'can_pin_messages' right or the 'can_edit_messages' right to unpin all pinned messages in groups and channels respectively. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#unpinallchatmessages
      def unpin_all_chat_messages(chat_id : Int32 | String) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/unpinAllChatMessages"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # leaveChat
      # Use this method for your bot to leave a group, supergroup or channel. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#leavechat
      def leave_chat(chat_id : Int32 | String) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/leaveChat"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # getChat
      # Use this method to get up-to-date information about the chat. Returns a ChatFullInfo object on success.
      #
      # Returns: ChatFullInfo
      # See: https://core.telegram.org/bots/api#getchat
      def get_chat(chat_id : Int32 | String) : ChatFullInfo
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/getChat"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        ChatFullInfo.from_json(result_data.to_json)
      end

      # getChatAdministrators
      # Use this method to get a list of administrators in a chat, which aren't bots. Returns an Array of ChatMember objects.
      #
      # Returns: Array(ChatMember)
      # See: https://core.telegram.org/bots/api#getchatadministrators
      def get_chat_administrators(chat_id : Int32 | String) : Array(ChatMember)
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/getChatAdministrators"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Array(ChatMember).from_json(result_data.to_json)
      end

      # getChatMemberCount
      # Use this method to get the number of members in a chat. Returns Int on success.
      #
      # Returns: Int32
      # See: https://core.telegram.org/bots/api#getchatmembercount
      def get_chat_member_count(chat_id : Int32 | String) : Int32
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/getChatMemberCount"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Int32.from_json(result_data.to_json)
      end

      # getChatMember
      # Use this method to get information about a member of a chat. The method is only guaranteed to work for other users if the bot is an administrator in the chat. Returns a ChatMember object on success.
      #
      # Returns: ChatMember
      # See: https://core.telegram.org/bots/api#getchatmember
      def get_chat_member(chat_id : Int32 | String, user_id : Int32) : ChatMember
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "user_id" => user_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          user_id: user_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/getChatMember"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        ChatMember.from_json(result_data.to_json)
      end

      # setChatStickerSet
      # Use this method to set a new group sticker set for a supergroup. The bot must be an administrator in the chat for this to work and must have the appropriate administrator rights. Use the field can_set_sticker_set optionally returned in getChat requests to check if the bot can use this method. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setchatstickerset
      def set_chat_sticker_set(chat_id : Int32 | String, sticker_set_name : String) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "sticker_set_name" => sticker_set_name,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          sticker_set_name: sticker_set_name,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/setChatStickerSet"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # deleteChatStickerSet
      # Use this method to delete a group sticker set from a supergroup. The bot must be an administrator in the chat for this to work and must have the appropriate administrator rights. Use the field can_set_sticker_set optionally returned in getChat requests to check if the bot can use this method. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#deletechatstickerset
      def delete_chat_sticker_set(chat_id : Int32 | String) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/deleteChatStickerSet"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # getForumTopicIconStickers
      # Use this method to get custom emoji stickers, which can be used as a forum topic icon by any user. Requires no parameters. Returns an Array of Sticker objects.
      #
      # Returns: Array(Sticker)
      # See: https://core.telegram.org/bots/api#getforumtopiciconstickers
      def get_forum_topic_icon_stickers() : Array(Sticker)
        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/getForumTopicIconStickers"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Array(Sticker).from_json(result_data.to_json)
      end

      # createForumTopic
      # Use this method to create a topic in a forum supergroup chat. The bot must be an administrator in the chat for this to work and must have the can_manage_topics administrator rights. Returns information about the created topic as a ForumTopic object.
      #
      # Returns: ForumTopic
      # See: https://core.telegram.org/bots/api#createforumtopic
      def create_forum_topic(chat_id : Int32 | String, name : String, icon_color : Int32? = nil, icon_custom_emoji_id : String? = nil) : ForumTopic
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "name" => name,
          "icon_color" => icon_color,
          "icon_custom_emoji_id" => icon_custom_emoji_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          name: name,
          icon_color: icon_color,
          icon_custom_emoji_id: icon_custom_emoji_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/createForumTopic"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        ForumTopic.from_json(result_data.to_json)
      end

      # editForumTopic
      # Use this method to edit name and icon of a topic in a forum supergroup chat. The bot must be an administrator in the chat for this to work and must have the can_manage_topics administrator rights, unless it is the creator of the topic. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#editforumtopic
      def edit_forum_topic(chat_id : Int32 | String, message_thread_id : Int32, name : String? = nil, icon_custom_emoji_id : String? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
          "name" => name,
          "icon_custom_emoji_id" => icon_custom_emoji_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          message_thread_id: message_thread_id,
          name: name,
          icon_custom_emoji_id: icon_custom_emoji_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/editForumTopic"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # closeForumTopic
      # Use this method to close an open topic in a forum supergroup chat. The bot must be an administrator in the chat for this to work and must have the can_manage_topics administrator rights, unless it is the creator of the topic. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#closeforumtopic
      def close_forum_topic(chat_id : Int32 | String, message_thread_id : Int32) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          message_thread_id: message_thread_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/closeForumTopic"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # reopenForumTopic
      # Use this method to reopen a closed topic in a forum supergroup chat. The bot must be an administrator in the chat for this to work and must have the can_manage_topics administrator rights, unless it is the creator of the topic. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#reopenforumtopic
      def reopen_forum_topic(chat_id : Int32 | String, message_thread_id : Int32) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          message_thread_id: message_thread_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/reopenForumTopic"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # deleteForumTopic
      # Use this method to delete a forum topic along with all its messages in a forum supergroup chat. The bot must be an administrator in the chat for this to work and must have the can_delete_messages administrator rights. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#deleteforumtopic
      def delete_forum_topic(chat_id : Int32 | String, message_thread_id : Int32) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          message_thread_id: message_thread_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/deleteForumTopic"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # unpinAllForumTopicMessages
      # Use this method to clear the list of pinned messages in a forum topic. The bot must be an administrator in the chat for this to work and must have the can_pin_messages administrator right in the supergroup. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#unpinallforumtopicmessages
      def unpin_all_forum_topic_messages(chat_id : Int32 | String, message_thread_id : Int32) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          message_thread_id: message_thread_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/unpinAllForumTopicMessages"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # editGeneralForumTopic
      # Use this method to edit the name of the 'General' topic in a forum supergroup chat. The bot must be an administrator in the chat for this to work and must have the can_manage_topics administrator rights. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#editgeneralforumtopic
      def edit_general_forum_topic(chat_id : Int32 | String, name : String) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "name" => name,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          name: name,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/editGeneralForumTopic"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # closeGeneralForumTopic
      # Use this method to close an open 'General' topic in a forum supergroup chat. The bot must be an administrator in the chat for this to work and must have the can_manage_topics administrator rights. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#closegeneralforumtopic
      def close_general_forum_topic(chat_id : Int32 | String) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/closeGeneralForumTopic"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # reopenGeneralForumTopic
      # Use this method to reopen a closed 'General' topic in a forum supergroup chat. The bot must be an administrator in the chat for this to work and must have the can_manage_topics administrator rights. The topic will be automatically unhidden if it was hidden. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#reopengeneralforumtopic
      def reopen_general_forum_topic(chat_id : Int32 | String) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/reopenGeneralForumTopic"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # hideGeneralForumTopic
      # Use this method to hide the 'General' topic in a forum supergroup chat. The bot must be an administrator in the chat for this to work and must have the can_manage_topics administrator rights. The topic will be automatically closed if it was open. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#hidegeneralforumtopic
      def hide_general_forum_topic(chat_id : Int32 | String) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/hideGeneralForumTopic"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # unhideGeneralForumTopic
      # Use this method to unhide the 'General' topic in a forum supergroup chat. The bot must be an administrator in the chat for this to work and must have the can_manage_topics administrator rights. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#unhidegeneralforumtopic
      def unhide_general_forum_topic(chat_id : Int32 | String) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/unhideGeneralForumTopic"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # unpinAllGeneralForumTopicMessages
      # Use this method to clear the list of pinned messages in a General forum topic. The bot must be an administrator in the chat for this to work and must have the can_pin_messages administrator right in the supergroup. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#unpinallgeneralforumtopicmessages
      def unpin_all_general_forum_topic_messages(chat_id : Int32 | String) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/unpinAllGeneralForumTopicMessages"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # answerCallbackQuery
      # Use this method to send answers to callback queries sent from inline keyboards. The answer will be displayed to the user as a notification at the top of the chat screen or as an alert. On success, True is returned.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#answercallbackquery
      def answer_callback_query(callback_query_id : String, text : String? = nil, show_alert : Bool? = nil, url : String? = nil, cache_time : Int32? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "callback_query_id" => callback_query_id,
          "text" => text,
          "show_alert" => show_alert,
          "url" => url,
          "cache_time" => cache_time,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          callback_query_id: callback_query_id,
          text: text,
          show_alert: show_alert,
          url: url,
          cache_time: cache_time,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/answerCallbackQuery"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # getUserChatBoosts
      # Use this method to get the list of boosts added to a chat by a user. Requires administrator rights in the chat. Returns a UserChatBoosts object.
      #
      # Returns: UserChatBoosts
      # See: https://core.telegram.org/bots/api#getuserchatboosts
      def get_user_chat_boosts(chat_id : Int32 | String, user_id : Int32) : UserChatBoosts
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "user_id" => user_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          user_id: user_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/getUserChatBoosts"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        UserChatBoosts.from_json(result_data.to_json)
      end

      # getBusinessConnection
      # Use this method to get information about the connection of the bot with a business account. Returns a BusinessConnection object on success.
      #
      # Returns: BusinessConnection
      # See: https://core.telegram.org/bots/api#getbusinessconnection
      def get_business_connection(business_connection_id : String) : BusinessConnection
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/getBusinessConnection"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        BusinessConnection.from_json(result_data.to_json)
      end

      # setMyCommands
      # Use this method to change the list of the bot's commands. See this manual for more details about bot commands. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setmycommands
      def set_my_commands(commands : Array(BotCommand), scope : BotCommandScope? = nil, language_code : String? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "commands" => commands,
          "scope" => scope,
          "language_code" => language_code,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          commands: commands,
          scope: scope,
          language_code: language_code,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/setMyCommands"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # deleteMyCommands
      # Use this method to delete the list of the bot's commands for the given scope and user language. After deletion, higher level commands will be shown to affected users. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#deletemycommands
      def delete_my_commands(scope : BotCommandScope? = nil, language_code : String? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "scope" => scope,
          "language_code" => language_code,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          scope: scope,
          language_code: language_code,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/deleteMyCommands"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # getMyCommands
      # Use this method to get the current list of the bot's commands for the given scope and user language. Returns an Array of BotCommand objects. If commands aren't set, an empty list is returned.
      #
      # Returns: Array(BotCommand)
      # See: https://core.telegram.org/bots/api#getmycommands
      def get_my_commands(scope : BotCommandScope? = nil, language_code : String? = nil) : Array(BotCommand)
        # Collect parameters for file detection
        params_hash = {
          "scope" => scope,
          "language_code" => language_code,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          scope: scope,
          language_code: language_code,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/getMyCommands"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Array(BotCommand).from_json(result_data.to_json)
      end

      # setMyName
      # Use this method to change the bot's name. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setmyname
      def set_my_name(name : String? = nil, language_code : String? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "name" => name,
          "language_code" => language_code,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          name: name,
          language_code: language_code,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/setMyName"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # getMyName
      # Use this method to get the current bot name for the given user language. Returns BotName on success.
      #
      # Returns: BotName
      # See: https://core.telegram.org/bots/api#getmyname
      def get_my_name(language_code : String? = nil) : BotName
        # Collect parameters for file detection
        params_hash = {
          "language_code" => language_code,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          language_code: language_code,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/getMyName"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        BotName.from_json(result_data.to_json)
      end

      # setMyDescription
      # Use this method to change the bot's description, which is shown in the chat with the bot if the chat is empty. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setmydescription
      def set_my_description(description : String? = nil, language_code : String? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "description" => description,
          "language_code" => language_code,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          description: description,
          language_code: language_code,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/setMyDescription"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # getMyDescription
      # Use this method to get the current bot description for the given user language. Returns BotDescription on success.
      #
      # Returns: BotDescription
      # See: https://core.telegram.org/bots/api#getmydescription
      def get_my_description(language_code : String? = nil) : BotDescription
        # Collect parameters for file detection
        params_hash = {
          "language_code" => language_code,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          language_code: language_code,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/getMyDescription"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        BotDescription.from_json(result_data.to_json)
      end

      # setMyShortDescription
      # Use this method to change the bot's short description, which is shown on the bot's profile page and is sent together with the link when users share the bot. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setmyshortdescription
      def set_my_short_description(short_description : String? = nil, language_code : String? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "short_description" => short_description,
          "language_code" => language_code,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          short_description: short_description,
          language_code: language_code,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/setMyShortDescription"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # getMyShortDescription
      # Use this method to get the current bot short description for the given user language. Returns BotShortDescription on success.
      #
      # Returns: BotShortDescription
      # See: https://core.telegram.org/bots/api#getmyshortdescription
      def get_my_short_description(language_code : String? = nil) : BotShortDescription
        # Collect parameters for file detection
        params_hash = {
          "language_code" => language_code,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          language_code: language_code,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/getMyShortDescription"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        BotShortDescription.from_json(result_data.to_json)
      end

      # setChatMenuButton
      # Use this method to change the bot's menu button in a private chat, or the default menu button. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setchatmenubutton
      def set_chat_menu_button(chat_id : Int32? = nil, menu_button : MenuButton? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "menu_button" => menu_button,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          menu_button: menu_button,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/setChatMenuButton"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # getChatMenuButton
      # Use this method to get the current value of the bot's menu button in a private chat, or the default menu button. Returns MenuButton on success.
      #
      # Returns: MenuButton
      # See: https://core.telegram.org/bots/api#getchatmenubutton
      def get_chat_menu_button(chat_id : Int32? = nil) : MenuButton
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/getChatMenuButton"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        MenuButton.from_json(result_data.to_json)
      end

      # setMyDefaultAdministratorRights
      # Use this method to change the default administrator rights requested by the bot when it's added as an administrator to groups or channels. These rights will be suggested to users, but they are free to modify the list before adding the bot. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setmydefaultadministratorrights
      def set_my_default_administrator_rights(rights : ChatAdministratorRights? = nil, for_channels : Bool? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "rights" => rights,
          "for_channels" => for_channels,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          rights: rights,
          for_channels: for_channels,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/setMyDefaultAdministratorRights"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # getMyDefaultAdministratorRights
      # Use this method to get the current default administrator rights of the bot. Returns ChatAdministratorRights on success.
      #
      # Returns: ChatAdministratorRights
      # See: https://core.telegram.org/bots/api#getmydefaultadministratorrights
      def get_my_default_administrator_rights(for_channels : Bool? = nil) : ChatAdministratorRights
        # Collect parameters for file detection
        params_hash = {
          "for_channels" => for_channels,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          for_channels: for_channels,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/getMyDefaultAdministratorRights"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        ChatAdministratorRights.from_json(result_data.to_json)
      end

      # getAvailableGifts
      # Returns the list of gifts that can be sent by the bot to users and channel chats. Requires no parameters. Returns a Gifts object.
      #
      # Returns: Gifts
      # See: https://core.telegram.org/bots/api#getavailablegifts
      def get_available_gifts() : Gifts
        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/getAvailableGifts"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Gifts.from_json(result_data.to_json)
      end

      # sendGift
      # Sends a gift to the given user or channel chat. The gift can't be converted to Telegram Stars by the receiver. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#sendgift
      def send_gift(gift_id : String, user_id : Int32? = nil, chat_id : Int32 | String? = nil, pay_for_upgrade : Bool? = nil, text : String? = nil, text_parse_mode : String? = nil, text_entities : Array(MessageEntity)? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "user_id" => user_id,
          "chat_id" => chat_id,
          "gift_id" => gift_id,
          "pay_for_upgrade" => pay_for_upgrade,
          "text" => text,
          "text_parse_mode" => text_parse_mode,
          "text_entities" => text_entities,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          user_id: user_id,
          chat_id: chat_id,
          gift_id: gift_id,
          pay_for_upgrade: pay_for_upgrade,
          text: text,
          text_parse_mode: text_parse_mode,
          text_entities: text_entities,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/sendGift"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # giftPremiumSubscription
      # Gifts a Telegram Premium subscription to the given user. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#giftpremiumsubscription
      def gift_premium_subscription(user_id : Int32, month_count : Int32, star_count : Int32, text : String? = nil, text_parse_mode : String? = nil, text_entities : Array(MessageEntity)? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "user_id" => user_id,
          "month_count" => month_count,
          "star_count" => star_count,
          "text" => text,
          "text_parse_mode" => text_parse_mode,
          "text_entities" => text_entities,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          user_id: user_id,
          month_count: month_count,
          star_count: star_count,
          text: text,
          text_parse_mode: text_parse_mode,
          text_entities: text_entities,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/giftPremiumSubscription"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # verifyUser
      # Verifies a user on behalf of the organization which is represented by the bot. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#verifyuser
      def verify_user(user_id : Int32, custom_description : String? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "user_id" => user_id,
          "custom_description" => custom_description,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          user_id: user_id,
          custom_description: custom_description,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/verifyUser"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # verifyChat
      # Verifies a chat on behalf of the organization which is represented by the bot. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#verifychat
      def verify_chat(chat_id : Int32 | String, custom_description : String? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "custom_description" => custom_description,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          custom_description: custom_description,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/verifyChat"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # removeUserVerification
      # Removes verification from a user who is currently verified on behalf of the organization represented by the bot. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#removeuserverification
      def remove_user_verification(user_id : Int32) : Bool
        # Collect parameters for file detection
        params_hash = {
          "user_id" => user_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          user_id: user_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/removeUserVerification"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # removeChatVerification
      # Removes verification from a chat that is currently verified on behalf of the organization represented by the bot. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#removechatverification
      def remove_chat_verification(chat_id : Int32 | String) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/removeChatVerification"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # readBusinessMessage
      # Marks incoming message as read on behalf of a business account. Requires the can_read_messages business bot right. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#readbusinessmessage
      def read_business_message(business_connection_id : String, chat_id : Int32, message_id : Int32) : Bool
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_id" => message_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          chat_id: chat_id,
          message_id: message_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/readBusinessMessage"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # deleteBusinessMessages
      # Delete messages on behalf of a business account. Requires the can_delete_sent_messages business bot right to delete messages sent by the bot itself, or the can_delete_all_messages business bot right to delete any message. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#deletebusinessmessages
      def delete_business_messages(business_connection_id : String, message_ids : Array(Int32)) : Bool
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "message_ids" => message_ids,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          message_ids: message_ids,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/deleteBusinessMessages"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # setBusinessAccountName
      # Changes the first and last name of a managed business account. Requires the can_change_name business bot right. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setbusinessaccountname
      def set_business_account_name(business_connection_id : String, first_name : String, last_name : String? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "first_name" => first_name,
          "last_name" => last_name,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          first_name: first_name,
          last_name: last_name,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/setBusinessAccountName"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # setBusinessAccountUsername
      # Changes the username of a managed business account. Requires the can_change_username business bot right. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setbusinessaccountusername
      def set_business_account_username(business_connection_id : String, username : String? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "username" => username,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          username: username,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/setBusinessAccountUsername"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # setBusinessAccountBio
      # Changes the bio of a managed business account. Requires the can_change_bio business bot right. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setbusinessaccountbio
      def set_business_account_bio(business_connection_id : String, bio : String? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "bio" => bio,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          bio: bio,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/setBusinessAccountBio"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # setBusinessAccountProfilePhoto
      # Changes the profile photo of a managed business account. Requires the can_edit_profile_photo business bot right. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setbusinessaccountprofilephoto
      def set_business_account_profile_photo(business_connection_id : String, photo : InputProfilePhoto, is_public : Bool? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "photo" => photo,
          "is_public" => is_public,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          photo: photo,
          is_public: is_public,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/setBusinessAccountProfilePhoto"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # removeBusinessAccountProfilePhoto
      # Removes the current profile photo of a managed business account. Requires the can_edit_profile_photo business bot right. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#removebusinessaccountprofilephoto
      def remove_business_account_profile_photo(business_connection_id : String, is_public : Bool? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "is_public" => is_public,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          is_public: is_public,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/removeBusinessAccountProfilePhoto"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # setBusinessAccountGiftSettings
      # Changes the privacy settings pertaining to incoming gifts in a managed business account. Requires the can_change_gift_settings business bot right. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setbusinessaccountgiftsettings
      def set_business_account_gift_settings(business_connection_id : String, show_gift_button : Bool, accepted_gift_types : AcceptedGiftTypes) : Bool
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "show_gift_button" => show_gift_button,
          "accepted_gift_types" => accepted_gift_types,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          show_gift_button: show_gift_button,
          accepted_gift_types: accepted_gift_types,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/setBusinessAccountGiftSettings"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # getBusinessAccountStarBalance
      # Returns the amount of Telegram Stars owned by a managed business account. Requires the can_view_gifts_and_stars business bot right. Returns StarAmount on success.
      #
      # Returns: StarAmount
      # See: https://core.telegram.org/bots/api#getbusinessaccountstarbalance
      def get_business_account_star_balance(business_connection_id : String) : StarAmount
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/getBusinessAccountStarBalance"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        StarAmount.from_json(result_data.to_json)
      end

      # transferBusinessAccountStars
      # Transfers Telegram Stars from the business account balance to the bot's balance. Requires the can_transfer_stars business bot right. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#transferbusinessaccountstars
      def transfer_business_account_stars(business_connection_id : String, star_count : Int32) : Bool
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "star_count" => star_count,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          star_count: star_count,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/transferBusinessAccountStars"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # getBusinessAccountGifts
      # Returns the gifts received and owned by a managed business account. Requires the can_view_gifts_and_stars business bot right. Returns OwnedGifts on success.
      #
      # Returns: OwnedGifts
      # See: https://core.telegram.org/bots/api#getbusinessaccountgifts
      def get_business_account_gifts(business_connection_id : String, exclude_unsaved : Bool? = nil, exclude_saved : Bool? = nil, exclude_unlimited : Bool? = nil, exclude_limited : Bool? = nil, exclude_unique : Bool? = nil, sort_by_price : Bool? = nil, offset : String? = nil, limit : Int32? = nil) : OwnedGifts
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "exclude_unsaved" => exclude_unsaved,
          "exclude_saved" => exclude_saved,
          "exclude_unlimited" => exclude_unlimited,
          "exclude_limited" => exclude_limited,
          "exclude_unique" => exclude_unique,
          "sort_by_price" => sort_by_price,
          "offset" => offset,
          "limit" => limit,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          exclude_unsaved: exclude_unsaved,
          exclude_saved: exclude_saved,
          exclude_unlimited: exclude_unlimited,
          exclude_limited: exclude_limited,
          exclude_unique: exclude_unique,
          sort_by_price: sort_by_price,
          offset: offset,
          limit: limit,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/getBusinessAccountGifts"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        OwnedGifts.from_json(result_data.to_json)
      end

      # convertGiftToStars
      # Converts a given regular gift to Telegram Stars. Requires the can_convert_gifts_to_stars business bot right. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#convertgifttostars
      def convert_gift_to_stars(business_connection_id : String, owned_gift_id : String) : Bool
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "owned_gift_id" => owned_gift_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          owned_gift_id: owned_gift_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/convertGiftToStars"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # upgradeGift
      # Upgrades a given regular gift to a unique gift. Requires the can_transfer_and_upgrade_gifts business bot right. Additionally requires the can_transfer_stars business bot right if the upgrade is paid. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#upgradegift
      def upgrade_gift(business_connection_id : String, owned_gift_id : String, keep_original_details : Bool? = nil, star_count : Int32? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "owned_gift_id" => owned_gift_id,
          "keep_original_details" => keep_original_details,
          "star_count" => star_count,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          owned_gift_id: owned_gift_id,
          keep_original_details: keep_original_details,
          star_count: star_count,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/upgradeGift"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # transferGift
      # Transfers an owned unique gift to another user. Requires the can_transfer_and_upgrade_gifts business bot right. Requires can_transfer_stars business bot right if the transfer is paid. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#transfergift
      def transfer_gift(business_connection_id : String, owned_gift_id : String, new_owner_chat_id : Int32, star_count : Int32? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "owned_gift_id" => owned_gift_id,
          "new_owner_chat_id" => new_owner_chat_id,
          "star_count" => star_count,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          owned_gift_id: owned_gift_id,
          new_owner_chat_id: new_owner_chat_id,
          star_count: star_count,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/transferGift"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # postStory
      # Posts a story on behalf of a managed business account. Requires the can_manage_stories business bot right. Returns Story on success.
      #
      # Returns: Story
      # See: https://core.telegram.org/bots/api#poststory
      def post_story(business_connection_id : String, content : InputStoryContent, active_period : Int32, caption : String? = nil, parse_mode : String? = nil, caption_entities : Array(MessageEntity)? = nil, areas : Array(StoryArea)? = nil, post_to_chat_page : Bool? = nil, protect_content : Bool? = nil) : Story
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "content" => content,
          "active_period" => active_period,
          "caption" => caption,
          "parse_mode" => parse_mode,
          "caption_entities" => caption_entities,
          "areas" => areas,
          "post_to_chat_page" => post_to_chat_page,
          "protect_content" => protect_content,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          content: content,
          active_period: active_period,
          caption: caption,
          parse_mode: parse_mode,
          caption_entities: caption_entities,
          areas: areas,
          post_to_chat_page: post_to_chat_page,
          protect_content: protect_content,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/postStory"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Story.from_json(result_data.to_json)
      end

      # editStory
      # Edits a story previously posted by the bot on behalf of a managed business account. Requires the can_manage_stories business bot right. Returns Story on success.
      #
      # Returns: Story
      # See: https://core.telegram.org/bots/api#editstory
      def edit_story(business_connection_id : String, story_id : Int32, content : InputStoryContent, caption : String? = nil, parse_mode : String? = nil, caption_entities : Array(MessageEntity)? = nil, areas : Array(StoryArea)? = nil) : Story
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "story_id" => story_id,
          "content" => content,
          "caption" => caption,
          "parse_mode" => parse_mode,
          "caption_entities" => caption_entities,
          "areas" => areas,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          story_id: story_id,
          content: content,
          caption: caption,
          parse_mode: parse_mode,
          caption_entities: caption_entities,
          areas: areas,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/editStory"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Story.from_json(result_data.to_json)
      end

      # deleteStory
      # Deletes a story previously posted by the bot on behalf of a managed business account. Requires the can_manage_stories business bot right. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#deletestory
      def delete_story(business_connection_id : String, story_id : Int32) : Bool
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "story_id" => story_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          story_id: story_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/deleteStory"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # editMessageText
      # Use this method to edit text and game messages. On success, if the edited message is not an inline message, the edited Message is returned, otherwise True is returned. Note that business messages that were not sent by the bot and do not contain an inline keyboard can only be edited within 48 hours from the time they were sent.
      #
      # Returns: JSON::Any
      # See: https://core.telegram.org/bots/api#editmessagetext
      def edit_message_text(text : String, business_connection_id : String? = nil, chat_id : Int32 | String? = nil, message_id : Int32? = nil, inline_message_id : String? = nil, parse_mode : String? = nil, entities : Array(MessageEntity)? = nil, link_preview_options : LinkPreviewOptions? = nil, reply_markup : InlineKeyboardMarkup? = nil) : JSON::Any
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_id" => message_id,
          "inline_message_id" => inline_message_id,
          "text" => text,
          "parse_mode" => parse_mode,
          "entities" => entities,
          "link_preview_options" => link_preview_options,
          "reply_markup" => reply_markup,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          chat_id: chat_id,
          message_id: message_id,
          inline_message_id: inline_message_id,
          text: text,
          parse_mode: parse_mode,
          entities: entities,
          link_preview_options: link_preview_options,
          reply_markup: reply_markup,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/editMessageText"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        JSON::Any.from_json(result_data.to_json)
      end

      # editMessageCaption
      # Use this method to edit captions of messages. On success, if the edited message is not an inline message, the edited Message is returned, otherwise True is returned. Note that business messages that were not sent by the bot and do not contain an inline keyboard can only be edited within 48 hours from the time they were sent.
      #
      # Returns: JSON::Any
      # See: https://core.telegram.org/bots/api#editmessagecaption
      def edit_message_caption(business_connection_id : String? = nil, chat_id : Int32 | String? = nil, message_id : Int32? = nil, inline_message_id : String? = nil, caption : String? = nil, parse_mode : String? = nil, caption_entities : Array(MessageEntity)? = nil, show_caption_above_media : Bool? = nil, reply_markup : InlineKeyboardMarkup? = nil) : JSON::Any
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_id" => message_id,
          "inline_message_id" => inline_message_id,
          "caption" => caption,
          "parse_mode" => parse_mode,
          "caption_entities" => caption_entities,
          "show_caption_above_media" => show_caption_above_media,
          "reply_markup" => reply_markup,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          chat_id: chat_id,
          message_id: message_id,
          inline_message_id: inline_message_id,
          caption: caption,
          parse_mode: parse_mode,
          caption_entities: caption_entities,
          show_caption_above_media: show_caption_above_media,
          reply_markup: reply_markup,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/editMessageCaption"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        JSON::Any.from_json(result_data.to_json)
      end

      # editMessageMedia
      # Use this method to edit animation, audio, document, photo, or video messages, or to add media to text messages. If a message is part of a message album, then it can be edited only to an audio for audio albums, only to a document for document albums and to a photo or a video otherwise. When an inline message is edited, a new file can't be uploaded; use a previously uploaded file via its file_id or specify a URL. On success, if the edited message is not an inline message, the edited Message is returned, otherwise True is returned. Note that business messages that were not sent by the bot and do not contain an inline keyboard can only be edited within 48 hours from the time they were sent.
      #
      # Returns: JSON::Any
      # See: https://core.telegram.org/bots/api#editmessagemedia
      def edit_message_media(media : InputMedia, business_connection_id : String? = nil, chat_id : Int32 | String? = nil, message_id : Int32? = nil, inline_message_id : String? = nil, reply_markup : InlineKeyboardMarkup? = nil) : JSON::Any
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_id" => message_id,
          "inline_message_id" => inline_message_id,
          "media" => media,
          "reply_markup" => reply_markup,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          chat_id: chat_id,
          message_id: message_id,
          inline_message_id: inline_message_id,
          media: media,
          reply_markup: reply_markup,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/editMessageMedia"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        JSON::Any.from_json(result_data.to_json)
      end

      # editMessageLiveLocation
      # Use this method to edit live location messages. A location can be edited until its live_period expires or editing is explicitly disabled by a call to stopMessageLiveLocation. On success, if the edited message is not an inline message, the edited Message is returned, otherwise True is returned.
      #
      # Returns: JSON::Any
      # See: https://core.telegram.org/bots/api#editmessagelivelocation
      def edit_message_live_location(latitude : Float64, longitude : Float64, business_connection_id : String? = nil, chat_id : Int32 | String? = nil, message_id : Int32? = nil, inline_message_id : String? = nil, live_period : Int32? = nil, horizontal_accuracy : Float64? = nil, heading : Int32? = nil, proximity_alert_radius : Int32? = nil, reply_markup : InlineKeyboardMarkup? = nil) : JSON::Any
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_id" => message_id,
          "inline_message_id" => inline_message_id,
          "latitude" => latitude,
          "longitude" => longitude,
          "live_period" => live_period,
          "horizontal_accuracy" => horizontal_accuracy,
          "heading" => heading,
          "proximity_alert_radius" => proximity_alert_radius,
          "reply_markup" => reply_markup,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          chat_id: chat_id,
          message_id: message_id,
          inline_message_id: inline_message_id,
          latitude: latitude,
          longitude: longitude,
          live_period: live_period,
          horizontal_accuracy: horizontal_accuracy,
          heading: heading,
          proximity_alert_radius: proximity_alert_radius,
          reply_markup: reply_markup,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/editMessageLiveLocation"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        JSON::Any.from_json(result_data.to_json)
      end

      # stopMessageLiveLocation
      # Use this method to stop updating a live location message before live_period expires. On success, if the message is not an inline message, the edited Message is returned, otherwise True is returned.
      #
      # Returns: JSON::Any
      # See: https://core.telegram.org/bots/api#stopmessagelivelocation
      def stop_message_live_location(business_connection_id : String? = nil, chat_id : Int32 | String? = nil, message_id : Int32? = nil, inline_message_id : String? = nil, reply_markup : InlineKeyboardMarkup? = nil) : JSON::Any
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_id" => message_id,
          "inline_message_id" => inline_message_id,
          "reply_markup" => reply_markup,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          chat_id: chat_id,
          message_id: message_id,
          inline_message_id: inline_message_id,
          reply_markup: reply_markup,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/stopMessageLiveLocation"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        JSON::Any.from_json(result_data.to_json)
      end

      # editMessageChecklist
      # Use this method to edit a checklist on behalf of a connected business account. On success, the edited Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#editmessagechecklist
      def edit_message_checklist(business_connection_id : String, chat_id : Int32, message_id : Int32, checklist : InputChecklist, reply_markup : InlineKeyboardMarkup? = nil) : Message
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_id" => message_id,
          "checklist" => checklist,
          "reply_markup" => reply_markup,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          chat_id: chat_id,
          message_id: message_id,
          checklist: checklist,
          reply_markup: reply_markup,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/editMessageChecklist"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Message.from_json(result_data.to_json)
      end

      # editMessageReplyMarkup
      # Use this method to edit only the reply markup of messages. On success, if the edited message is not an inline message, the edited Message is returned, otherwise True is returned. Note that business messages that were not sent by the bot and do not contain an inline keyboard can only be edited within 48 hours from the time they were sent.
      #
      # Returns: JSON::Any
      # See: https://core.telegram.org/bots/api#editmessagereplymarkup
      def edit_message_reply_markup(business_connection_id : String? = nil, chat_id : Int32 | String? = nil, message_id : Int32? = nil, inline_message_id : String? = nil, reply_markup : InlineKeyboardMarkup? = nil) : JSON::Any
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_id" => message_id,
          "inline_message_id" => inline_message_id,
          "reply_markup" => reply_markup,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          chat_id: chat_id,
          message_id: message_id,
          inline_message_id: inline_message_id,
          reply_markup: reply_markup,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/editMessageReplyMarkup"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        JSON::Any.from_json(result_data.to_json)
      end

      # stopPoll
      # Use this method to stop a poll which was sent by the bot. On success, the stopped Poll is returned.
      #
      # Returns: Poll
      # See: https://core.telegram.org/bots/api#stoppoll
      def stop_poll(chat_id : Int32 | String, message_id : Int32, business_connection_id : String? = nil, reply_markup : InlineKeyboardMarkup? = nil) : Poll
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_id" => message_id,
          "reply_markup" => reply_markup,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          chat_id: chat_id,
          message_id: message_id,
          reply_markup: reply_markup,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/stopPoll"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Poll.from_json(result_data.to_json)
      end

      # approveSuggestedPost
      # Use this method to approve a suggested post in a direct messages chat. The bot must have the 'can_post_messages' administrator right in the corresponding channel chat. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#approvesuggestedpost
      def approve_suggested_post(chat_id : Int32, message_id : Int32, send_date : Int32? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "message_id" => message_id,
          "send_date" => send_date,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          message_id: message_id,
          send_date: send_date,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/approveSuggestedPost"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # declineSuggestedPost
      # Use this method to decline a suggested post in a direct messages chat. The bot must have the 'can_manage_direct_messages' administrator right in the corresponding channel chat. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#declinesuggestedpost
      def decline_suggested_post(chat_id : Int32, message_id : Int32, comment : String? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "message_id" => message_id,
          "comment" => comment,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          message_id: message_id,
          comment: comment,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/declineSuggestedPost"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # deleteMessage
      # Use this method to delete a message, including service messages, with the following limitations:
      # - A message can only be deleted if it was sent less than 48 hours ago.
      # - Service messages about a supergroup, channel, or forum topic creation can't be deleted.
      # - A dice message in a private chat can only be deleted if it was sent more than 24 hours ago.
      # - Bots can delete outgoing messages in private chats, groups, and supergroups.
      # - Bots can delete incoming messages in private chats.
      # - Bots granted can_post_messages permissions can delete outgoing messages in channels.
      # - If the bot is an administrator of a group, it can delete any message there.
      # - If the bot has can_delete_messages administrator right in a supergroup or a channel, it can delete any message there.
      # - If the bot has can_manage_direct_messages administrator right in a channel, it can delete any message in the corresponding direct messages chat.
      # Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#deletemessage
      def delete_message(chat_id : Int32 | String, message_id : Int32) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "message_id" => message_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          message_id: message_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/deleteMessage"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # deleteMessages
      # Use this method to delete multiple messages simultaneously. If some of the specified messages can't be found, they are skipped. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#deletemessages
      def delete_messages(chat_id : Int32 | String, message_ids : Array(Int32)) : Bool
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "message_ids" => message_ids,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          message_ids: message_ids,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/deleteMessages"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # sendSticker
      # Use this method to send static .WEBP, animated .TGS, or video .WEBM stickers. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendsticker
      def send_sticker(chat_id : Int32 | String, sticker : Telegram::InputFile | File | IO | String, business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, emoji : String? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
          "direct_messages_topic_id" => direct_messages_topic_id,
          "sticker" => sticker,
          "emoji" => emoji,
          "disable_notification" => disable_notification,
          "protect_content" => protect_content,
          "allow_paid_broadcast" => allow_paid_broadcast,
          "message_effect_id" => message_effect_id,
          "suggested_post_parameters" => suggested_post_parameters,
          "reply_parameters" => reply_parameters,
          "reply_markup" => reply_markup,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          chat_id: chat_id,
          message_thread_id: message_thread_id,
          direct_messages_topic_id: direct_messages_topic_id,
          sticker: sticker,
          emoji: emoji,
          disable_notification: disable_notification,
          protect_content: protect_content,
          allow_paid_broadcast: allow_paid_broadcast,
          message_effect_id: message_effect_id,
          suggested_post_parameters: suggested_post_parameters,
          reply_parameters: reply_parameters,
          reply_markup: reply_markup,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/sendSticker"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Message.from_json(result_data.to_json)
      end

      # getStickerSet
      # Use this method to get a sticker set. On success, a StickerSet object is returned.
      #
      # Returns: StickerSet
      # See: https://core.telegram.org/bots/api#getstickerset
      def get_sticker_set(name : String) : StickerSet
        # Collect parameters for file detection
        params_hash = {
          "name" => name,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          name: name,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/getStickerSet"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        StickerSet.from_json(result_data.to_json)
      end

      # getCustomEmojiStickers
      # Use this method to get information about custom emoji stickers by their identifiers. Returns an Array of Sticker objects.
      #
      # Returns: Array(Sticker)
      # See: https://core.telegram.org/bots/api#getcustomemojistickers
      def get_custom_emoji_stickers(custom_emoji_ids : Array(String)) : Array(Sticker)
        # Collect parameters for file detection
        params_hash = {
          "custom_emoji_ids" => custom_emoji_ids,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          custom_emoji_ids: custom_emoji_ids,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/getCustomEmojiStickers"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Array(Sticker).from_json(result_data.to_json)
      end

      # uploadStickerFile
      # Use this method to upload a file with a sticker for later use in the createNewStickerSet, addStickerToSet, or replaceStickerInSet methods (the file can be used multiple times). Returns the uploaded File on success.
      #
      # Returns: TelegramFile
      # See: https://core.telegram.org/bots/api#uploadstickerfile
      def upload_sticker_file(user_id : Int32, sticker : Telegram::InputFile | File | IO, sticker_format : String) : TelegramFile
        # Collect parameters for file detection
        params_hash = {
          "user_id" => user_id,
          "sticker" => sticker,
          "sticker_format" => sticker_format,
        }

        # Runtime detection: check if any parameters contain actual file data
        has_files = contains_file_data?(params_hash)

        if has_files
          # Use multipart form data for file uploads
          boundary, form_body = build_multipart_form_with_files(params_hash)
          
          # Make HTTP request with multipart form using enhanced client
          url = "#{@api_url}/bot#{@token}/uploadStickerFile"
          response = @http_client.post_multipart(url, {boundary, form_body})
        else
          # Use JSON request when no files are present
          params = build_request_hash_from_hash(params_hash)
          
          # Make HTTP request using enhanced client
          url = "#{@api_url}/bot#{@token}/uploadStickerFile"
          response = @http_client.post(url,
            headers: HTTP::Headers{"Content-Type" => "application/json"},
            body: params.to_json
          )
        end

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        TelegramFile.from_json(result_data.to_json)
      end

      # createNewStickerSet
      # Use this method to create a new sticker set owned by a user. The bot will be able to edit the sticker set thus created. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#createnewstickerset
      def create_new_sticker_set(user_id : Int32, name : String, title : String, stickers : Array(InputSticker), sticker_type : String? = nil, needs_repainting : Bool? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "user_id" => user_id,
          "name" => name,
          "title" => title,
          "stickers" => stickers,
          "sticker_type" => sticker_type,
          "needs_repainting" => needs_repainting,
        }

        # Runtime detection: check if any parameters contain actual file data
        has_files = contains_file_data?(params_hash)

        if has_files
          # Use multipart form data for file uploads
          boundary, form_body = build_multipart_form_with_files(params_hash)
          
          # Make HTTP request with multipart form using enhanced client
          url = "#{@api_url}/bot#{@token}/createNewStickerSet"
          response = @http_client.post_multipart(url, {boundary, form_body})
        else
          # Use JSON request when no files are present
          params = build_request_hash_from_hash(params_hash)
          
          # Make HTTP request using enhanced client
          url = "#{@api_url}/bot#{@token}/createNewStickerSet"
          response = @http_client.post(url,
            headers: HTTP::Headers{"Content-Type" => "application/json"},
            body: params.to_json
          )
        end

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # addStickerToSet
      # Use this method to add a new sticker to a set created by the bot. Emoji sticker sets can have up to 200 stickers. Other sticker sets can have up to 120 stickers. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#addstickertoset
      def add_sticker_to_set(user_id : Int32, name : String, sticker : InputSticker) : Bool
        # Collect parameters for file detection
        params_hash = {
          "user_id" => user_id,
          "name" => name,
          "sticker" => sticker,
        }

        # Runtime detection: check if any parameters contain actual file data
        has_files = contains_file_data?(params_hash)

        if has_files
          # Use multipart form data for file uploads
          boundary, form_body = build_multipart_form_with_files(params_hash)
          
          # Make HTTP request with multipart form using enhanced client
          url = "#{@api_url}/bot#{@token}/addStickerToSet"
          response = @http_client.post_multipart(url, {boundary, form_body})
        else
          # Use JSON request when no files are present
          params = build_request_hash_from_hash(params_hash)
          
          # Make HTTP request using enhanced client
          url = "#{@api_url}/bot#{@token}/addStickerToSet"
          response = @http_client.post(url,
            headers: HTTP::Headers{"Content-Type" => "application/json"},
            body: params.to_json
          )
        end

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # setStickerPositionInSet
      # Use this method to move a sticker in a set created by the bot to a specific position. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setstickerpositioninset
      def set_sticker_position_in_set(sticker : String, position : Int32) : Bool
        # Collect parameters for file detection
        params_hash = {
          "sticker" => sticker,
          "position" => position,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          sticker: sticker,
          position: position,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/setStickerPositionInSet"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # deleteStickerFromSet
      # Use this method to delete a sticker from a set created by the bot. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#deletestickerfromset
      def delete_sticker_from_set(sticker : String) : Bool
        # Collect parameters for file detection
        params_hash = {
          "sticker" => sticker,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          sticker: sticker,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/deleteStickerFromSet"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # replaceStickerInSet
      # Use this method to replace an existing sticker in a sticker set with a new one. The method is equivalent to calling deleteStickerFromSet, then addStickerToSet, then setStickerPositionInSet. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#replacestickerinset
      def replace_sticker_in_set(user_id : Int32, name : String, old_sticker : String, sticker : InputSticker) : Bool
        # Collect parameters for file detection
        params_hash = {
          "user_id" => user_id,
          "name" => name,
          "old_sticker" => old_sticker,
          "sticker" => sticker,
        }

        # Runtime detection: check if any parameters contain actual file data
        has_files = contains_file_data?(params_hash)

        if has_files
          # Use multipart form data for file uploads
          boundary, form_body = build_multipart_form_with_files(params_hash)
          
          # Make HTTP request with multipart form using enhanced client
          url = "#{@api_url}/bot#{@token}/replaceStickerInSet"
          response = @http_client.post_multipart(url, {boundary, form_body})
        else
          # Use JSON request when no files are present
          params = build_request_hash_from_hash(params_hash)
          
          # Make HTTP request using enhanced client
          url = "#{@api_url}/bot#{@token}/replaceStickerInSet"
          response = @http_client.post(url,
            headers: HTTP::Headers{"Content-Type" => "application/json"},
            body: params.to_json
          )
        end

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # setStickerEmojiList
      # Use this method to change the list of emoji assigned to a regular or custom emoji sticker. The sticker must belong to a sticker set created by the bot. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setstickeremojilist
      def set_sticker_emoji_list(sticker : String, emoji_list : Array(String)) : Bool
        # Collect parameters for file detection
        params_hash = {
          "sticker" => sticker,
          "emoji_list" => emoji_list,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          sticker: sticker,
          emoji_list: emoji_list,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/setStickerEmojiList"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # setStickerKeywords
      # Use this method to change search keywords assigned to a regular or custom emoji sticker. The sticker must belong to a sticker set created by the bot. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setstickerkeywords
      def set_sticker_keywords(sticker : String, keywords : Array(String)? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "sticker" => sticker,
          "keywords" => keywords,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          sticker: sticker,
          keywords: keywords,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/setStickerKeywords"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # setStickerMaskPosition
      # Use this method to change the mask position of a mask sticker. The sticker must belong to a sticker set that was created by the bot. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setstickermaskposition
      def set_sticker_mask_position(sticker : String, mask_position : MaskPosition? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "sticker" => sticker,
          "mask_position" => mask_position,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          sticker: sticker,
          mask_position: mask_position,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/setStickerMaskPosition"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # setStickerSetTitle
      # Use this method to set the title of a created sticker set. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setstickersettitle
      def set_sticker_set_title(name : String, title : String) : Bool
        # Collect parameters for file detection
        params_hash = {
          "name" => name,
          "title" => title,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          name: name,
          title: title,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/setStickerSetTitle"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # setStickerSetThumbnail
      # Use this method to set the thumbnail of a regular or mask sticker set. The format of the thumbnail file must match the format of the stickers in the set. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setstickersetthumbnail
      def set_sticker_set_thumbnail(name : String, user_id : Int32, format : String, thumbnail : Telegram::InputFile | File | IO | String? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "name" => name,
          "user_id" => user_id,
          "thumbnail" => thumbnail,
          "format" => format,
        }

        # Runtime detection: check if any parameters contain actual file data
        has_files = contains_file_data?(params_hash)

        if has_files
          # Use multipart form data for file uploads
          boundary, form_body = build_multipart_form_with_files(params_hash)
          
          # Make HTTP request with multipart form using enhanced client
          url = "#{@api_url}/bot#{@token}/setStickerSetThumbnail"
          response = @http_client.post_multipart(url, {boundary, form_body})
        else
          # Use JSON request when no files are present
          params = build_request_hash_from_hash(params_hash)
          
          # Make HTTP request using enhanced client
          url = "#{@api_url}/bot#{@token}/setStickerSetThumbnail"
          response = @http_client.post(url,
            headers: HTTP::Headers{"Content-Type" => "application/json"},
            body: params.to_json
          )
        end

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # setCustomEmojiStickerSetThumbnail
      # Use this method to set the thumbnail of a custom emoji sticker set. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setcustomemojistickersetthumbnail
      def set_custom_emoji_sticker_set_thumbnail(name : String, custom_emoji_id : String? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "name" => name,
          "custom_emoji_id" => custom_emoji_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          name: name,
          custom_emoji_id: custom_emoji_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/setCustomEmojiStickerSetThumbnail"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # deleteStickerSet
      # Use this method to delete a sticker set that was created by the bot. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#deletestickerset
      def delete_sticker_set(name : String) : Bool
        # Collect parameters for file detection
        params_hash = {
          "name" => name,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          name: name,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/deleteStickerSet"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # answerInlineQuery
      # Use this method to send answers to an inline query. On success, True is returned.
      # No more than 50 results per query are allowed.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#answerinlinequery
      def answer_inline_query(inline_query_id : String, results : Array(InlineQueryResult), cache_time : Int32? = nil, is_personal : Bool? = nil, next_offset : String? = nil, button : InlineQueryResultsButton? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "inline_query_id" => inline_query_id,
          "results" => results,
          "cache_time" => cache_time,
          "is_personal" => is_personal,
          "next_offset" => next_offset,
          "button" => button,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          inline_query_id: inline_query_id,
          results: results,
          cache_time: cache_time,
          is_personal: is_personal,
          next_offset: next_offset,
          button: button,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/answerInlineQuery"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # answerWebAppQuery
      # Use this method to set the result of an interaction with a Web App and send a corresponding message on behalf of the user to the chat from which the query originated. On success, a SentWebAppMessage object is returned.
      #
      # Returns: SentWebAppMessage
      # See: https://core.telegram.org/bots/api#answerwebappquery
      def answer_web_app_query(web_app_query_id : String, result : InlineQueryResult) : SentWebAppMessage
        # Collect parameters for file detection
        params_hash = {
          "web_app_query_id" => web_app_query_id,
          "result" => result,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          web_app_query_id: web_app_query_id,
          result: result,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/answerWebAppQuery"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        SentWebAppMessage.from_json(result_data.to_json)
      end

      # savePreparedInlineMessage
      # Stores a message that can be sent by a user of a Mini App. Returns a PreparedInlineMessage object.
      #
      # Returns: PreparedInlineMessage
      # See: https://core.telegram.org/bots/api#savepreparedinlinemessage
      def save_prepared_inline_message(user_id : Int32, result : InlineQueryResult, allow_user_chats : Bool? = nil, allow_bot_chats : Bool? = nil, allow_group_chats : Bool? = nil, allow_channel_chats : Bool? = nil) : PreparedInlineMessage
        # Collect parameters for file detection
        params_hash = {
          "user_id" => user_id,
          "result" => result,
          "allow_user_chats" => allow_user_chats,
          "allow_bot_chats" => allow_bot_chats,
          "allow_group_chats" => allow_group_chats,
          "allow_channel_chats" => allow_channel_chats,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          user_id: user_id,
          result: result,
          allow_user_chats: allow_user_chats,
          allow_bot_chats: allow_bot_chats,
          allow_group_chats: allow_group_chats,
          allow_channel_chats: allow_channel_chats,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/savePreparedInlineMessage"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        PreparedInlineMessage.from_json(result_data.to_json)
      end

      # sendInvoice
      # Use this method to send invoices. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendinvoice
      def send_invoice(chat_id : Int32 | String, title : String, description : String, payload : String, currency : String, prices : Array(LabeledPrice), message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, provider_token : String? = nil, max_tip_amount : Int32? = nil, suggested_tip_amounts : Array(Int32)? = nil, start_parameter : String? = nil, provider_data : String? = nil, photo_url : String? = nil, photo_size : Int32? = nil, photo_width : Int32? = nil, photo_height : Int32? = nil, need_name : Bool? = nil, need_phone_number : Bool? = nil, need_email : Bool? = nil, need_shipping_address : Bool? = nil, send_phone_number_to_provider : Bool? = nil, send_email_to_provider : Bool? = nil, is_flexible : Bool? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup? = nil) : Message
        # Collect parameters for file detection
        params_hash = {
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
          "direct_messages_topic_id" => direct_messages_topic_id,
          "title" => title,
          "description" => description,
          "payload" => payload,
          "provider_token" => provider_token,
          "currency" => currency,
          "prices" => prices,
          "max_tip_amount" => max_tip_amount,
          "suggested_tip_amounts" => suggested_tip_amounts,
          "start_parameter" => start_parameter,
          "provider_data" => provider_data,
          "photo_url" => photo_url,
          "photo_size" => photo_size,
          "photo_width" => photo_width,
          "photo_height" => photo_height,
          "need_name" => need_name,
          "need_phone_number" => need_phone_number,
          "need_email" => need_email,
          "need_shipping_address" => need_shipping_address,
          "send_phone_number_to_provider" => send_phone_number_to_provider,
          "send_email_to_provider" => send_email_to_provider,
          "is_flexible" => is_flexible,
          "disable_notification" => disable_notification,
          "protect_content" => protect_content,
          "allow_paid_broadcast" => allow_paid_broadcast,
          "message_effect_id" => message_effect_id,
          "suggested_post_parameters" => suggested_post_parameters,
          "reply_parameters" => reply_parameters,
          "reply_markup" => reply_markup,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          chat_id: chat_id,
          message_thread_id: message_thread_id,
          direct_messages_topic_id: direct_messages_topic_id,
          title: title,
          description: description,
          payload: payload,
          provider_token: provider_token,
          currency: currency,
          prices: prices,
          max_tip_amount: max_tip_amount,
          suggested_tip_amounts: suggested_tip_amounts,
          start_parameter: start_parameter,
          provider_data: provider_data,
          photo_url: photo_url,
          photo_size: photo_size,
          photo_width: photo_width,
          photo_height: photo_height,
          need_name: need_name,
          need_phone_number: need_phone_number,
          need_email: need_email,
          need_shipping_address: need_shipping_address,
          send_phone_number_to_provider: send_phone_number_to_provider,
          send_email_to_provider: send_email_to_provider,
          is_flexible: is_flexible,
          disable_notification: disable_notification,
          protect_content: protect_content,
          allow_paid_broadcast: allow_paid_broadcast,
          message_effect_id: message_effect_id,
          suggested_post_parameters: suggested_post_parameters,
          reply_parameters: reply_parameters,
          reply_markup: reply_markup,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/sendInvoice"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Message.from_json(result_data.to_json)
      end

      # createInvoiceLink
      # Use this method to create a link for an invoice. Returns the created invoice link as String on success.
      #
      # Returns: String
      # See: https://core.telegram.org/bots/api#createinvoicelink
      def create_invoice_link(title : String, description : String, payload : String, currency : String, prices : Array(LabeledPrice), business_connection_id : String? = nil, provider_token : String? = nil, subscription_period : Int32? = nil, max_tip_amount : Int32? = nil, suggested_tip_amounts : Array(Int32)? = nil, provider_data : String? = nil, photo_url : String? = nil, photo_size : Int32? = nil, photo_width : Int32? = nil, photo_height : Int32? = nil, need_name : Bool? = nil, need_phone_number : Bool? = nil, need_email : Bool? = nil, need_shipping_address : Bool? = nil, send_phone_number_to_provider : Bool? = nil, send_email_to_provider : Bool? = nil, is_flexible : Bool? = nil) : String
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "title" => title,
          "description" => description,
          "payload" => payload,
          "provider_token" => provider_token,
          "currency" => currency,
          "prices" => prices,
          "subscription_period" => subscription_period,
          "max_tip_amount" => max_tip_amount,
          "suggested_tip_amounts" => suggested_tip_amounts,
          "provider_data" => provider_data,
          "photo_url" => photo_url,
          "photo_size" => photo_size,
          "photo_width" => photo_width,
          "photo_height" => photo_height,
          "need_name" => need_name,
          "need_phone_number" => need_phone_number,
          "need_email" => need_email,
          "need_shipping_address" => need_shipping_address,
          "send_phone_number_to_provider" => send_phone_number_to_provider,
          "send_email_to_provider" => send_email_to_provider,
          "is_flexible" => is_flexible,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          title: title,
          description: description,
          payload: payload,
          provider_token: provider_token,
          currency: currency,
          prices: prices,
          subscription_period: subscription_period,
          max_tip_amount: max_tip_amount,
          suggested_tip_amounts: suggested_tip_amounts,
          provider_data: provider_data,
          photo_url: photo_url,
          photo_size: photo_size,
          photo_width: photo_width,
          photo_height: photo_height,
          need_name: need_name,
          need_phone_number: need_phone_number,
          need_email: need_email,
          need_shipping_address: need_shipping_address,
          send_phone_number_to_provider: send_phone_number_to_provider,
          send_email_to_provider: send_email_to_provider,
          is_flexible: is_flexible,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/createInvoiceLink"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        String.from_json(result_data.to_json)
      end

      # answerShippingQuery
      # If you sent an invoice requesting a shipping address and the parameter is_flexible was specified, the Bot API will send an Update with a shipping_query field to the bot. Use this method to reply to shipping queries. On success, True is returned.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#answershippingquery
      def answer_shipping_query(shipping_query_id : String, ok : Bool, shipping_options : Array(ShippingOption)? = nil, error_message : String? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "shipping_query_id" => shipping_query_id,
          "ok" => ok,
          "shipping_options" => shipping_options,
          "error_message" => error_message,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          shipping_query_id: shipping_query_id,
          ok: ok,
          shipping_options: shipping_options,
          error_message: error_message,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/answerShippingQuery"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # answerPreCheckoutQuery
      # Once the user has confirmed their payment and shipping details, the Bot API sends the final confirmation in the form of an Update with the field pre_checkout_query. Use this method to respond to such pre-checkout queries. On success, True is returned. Note: The Bot API must receive an answer within 10 seconds after the pre-checkout query was sent.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#answerprecheckoutquery
      def answer_pre_checkout_query(pre_checkout_query_id : String, ok : Bool, error_message : String? = nil) : Bool
        # Collect parameters for file detection
        params_hash = {
          "pre_checkout_query_id" => pre_checkout_query_id,
          "ok" => ok,
          "error_message" => error_message,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          pre_checkout_query_id: pre_checkout_query_id,
          ok: ok,
          error_message: error_message,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/answerPreCheckoutQuery"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # getMyStarBalance
      # A method to get the current Telegram Stars balance of the bot. Requires no parameters. On success, returns a StarAmount object.
      #
      # Returns: StarAmount
      # See: https://core.telegram.org/bots/api#getmystarbalance
      def get_my_star_balance() : StarAmount
        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/getMyStarBalance"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        StarAmount.from_json(result_data.to_json)
      end

      # getStarTransactions
      # Returns the bot's Telegram Star transactions in chronological order. On success, returns a StarTransactions object.
      #
      # Returns: StarTransactions
      # See: https://core.telegram.org/bots/api#getstartransactions
      def get_star_transactions(offset : Int32? = nil, limit : Int32? = nil) : StarTransactions
        # Collect parameters for file detection
        params_hash = {
          "offset" => offset,
          "limit" => limit,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          offset: offset,
          limit: limit,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/getStarTransactions"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        StarTransactions.from_json(result_data.to_json)
      end

      # refundStarPayment
      # Refunds a successful payment in Telegram Stars. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#refundstarpayment
      def refund_star_payment(user_id : Int32, telegram_payment_charge_id : String) : Bool
        # Collect parameters for file detection
        params_hash = {
          "user_id" => user_id,
          "telegram_payment_charge_id" => telegram_payment_charge_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          user_id: user_id,
          telegram_payment_charge_id: telegram_payment_charge_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/refundStarPayment"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # editUserStarSubscription
      # Allows the bot to cancel or re-enable extension of a subscription paid in Telegram Stars. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#edituserstarsubscription
      def edit_user_star_subscription(user_id : Int32, telegram_payment_charge_id : String, is_canceled : Bool) : Bool
        # Collect parameters for file detection
        params_hash = {
          "user_id" => user_id,
          "telegram_payment_charge_id" => telegram_payment_charge_id,
          "is_canceled" => is_canceled,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          user_id: user_id,
          telegram_payment_charge_id: telegram_payment_charge_id,
          is_canceled: is_canceled,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/editUserStarSubscription"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # setPassportDataErrors
      # Informs a user that some of the Telegram Passport elements they provided contains errors. The user will not be able to re-submit their Passport to you until the errors are fixed (the contents of the field for which you returned the error must change). Returns True on success.
      # Use this if the data submitted by the user doesn't satisfy the standards your service requires for any reason. For example, if a birthday date seems invalid, a submitted document is blurry, a scan shows evidence of tampering, etc. Supply some details in the error message to make sure the user knows how to correct the issues.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setpassportdataerrors
      def set_passport_data_errors(user_id : Int32, errors : Array(PassportElementError)) : Bool
        # Collect parameters for file detection
        params_hash = {
          "user_id" => user_id,
          "errors" => errors,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          user_id: user_id,
          errors: errors,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/setPassportDataErrors"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Bool.from_json(result_data.to_json)
      end

      # sendGame
      # Use this method to send a game. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendgame
      def send_game(chat_id : Int32, game_short_name : String, business_connection_id : String? = nil, message_thread_id : Int32? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup? = nil) : Message
        # Collect parameters for file detection
        params_hash = {
          "business_connection_id" => business_connection_id,
          "chat_id" => chat_id,
          "message_thread_id" => message_thread_id,
          "game_short_name" => game_short_name,
          "disable_notification" => disable_notification,
          "protect_content" => protect_content,
          "allow_paid_broadcast" => allow_paid_broadcast,
          "message_effect_id" => message_effect_id,
          "reply_parameters" => reply_parameters,
          "reply_markup" => reply_markup,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          business_connection_id: business_connection_id,
          chat_id: chat_id,
          message_thread_id: message_thread_id,
          game_short_name: game_short_name,
          disable_notification: disable_notification,
          protect_content: protect_content,
          allow_paid_broadcast: allow_paid_broadcast,
          message_effect_id: message_effect_id,
          reply_parameters: reply_parameters,
          reply_markup: reply_markup,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/sendGame"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Message.from_json(result_data.to_json)
      end

      # setGameScore
      # Use this method to set the score of the specified user in a game message. On success, if the message is not an inline message, the Message is returned, otherwise True is returned. Returns an error, if the new score is not greater than the user's current score in the chat and force is False.
      #
      # Returns: JSON::Any
      # See: https://core.telegram.org/bots/api#setgamescore
      def set_game_score(user_id : Int32, score : Int32, force : Bool? = nil, disable_edit_message : Bool? = nil, chat_id : Int32? = nil, message_id : Int32? = nil, inline_message_id : String? = nil) : JSON::Any
        # Collect parameters for file detection
        params_hash = {
          "user_id" => user_id,
          "score" => score,
          "force" => force,
          "disable_edit_message" => disable_edit_message,
          "chat_id" => chat_id,
          "message_id" => message_id,
          "inline_message_id" => inline_message_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          user_id: user_id,
          score: score,
          force: force,
          disable_edit_message: disable_edit_message,
          chat_id: chat_id,
          message_id: message_id,
          inline_message_id: inline_message_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/setGameScore"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        JSON::Any.from_json(result_data.to_json)
      end

      # getGameHighScores
      # Use this method to get data for high score tables. Will return the score of the specified user and several of their neighbors in a game. Returns an Array of GameHighScore objects.
      #
      # Returns: Array(GameHighScore)
      # See: https://core.telegram.org/bots/api#getgamehighscores
      def get_game_high_scores(user_id : Int32, chat_id : Int32? = nil, message_id : Int32? = nil, inline_message_id : String? = nil) : Array(GameHighScore)
        # Collect parameters for file detection
        params_hash = {
          "user_id" => user_id,
          "chat_id" => chat_id,
          "message_id" => message_id,
          "inline_message_id" => inline_message_id,
        }

        # Build JSON request parameters (method never accepts files)
        params = build_request_hash(
          user_id: user_id,
          chat_id: chat_id,
          message_id: message_id,
          inline_message_id: inline_message_id,
        )

        # Make HTTP request using enhanced client
        url = "#{@api_url}/bot#{@token}/getGameHighScores"
        response = @http_client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Parse response - extract and deserialize the result
        json_response = JSON.parse(response.body)
        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "API Error: " + error_desc
        end
        result_data = json_response["result"]
        Array(GameHighScore).from_json(result_data.to_json)
      end

    end
  end
end
