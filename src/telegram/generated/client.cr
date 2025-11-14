# HTTP client for Telegram Bot API
# Generated for Telegram Bot API Bot API 9.2 (August 15, 2025)
require "http/client"
require "mime/multipart"

module Telegram
  module Client

    # Main API client for Telegram Bot API
    class APIClient

      # Bot token from @BotFather
      property token : String

      # Base API URL
      property api_url : String = "https://api.telegram.org"

      def initialize(@token : String, @api_url : String = "https://api.telegram.org")
      end

      # getUpdates
      # Use this method to receive incoming updates using long polling (wiki). Returns an Array of Update objects.
      #
      # Returns: Array(Update)
      # See: https://core.telegram.org/bots/api#getupdates
      def get_updates(offset : Int32? = nil, limit : Int32? = nil, timeout : Int32? = nil, allowed_updates : Array(String)? = nil) : Array(Update)
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["offset"] = JSON::Any.new(offset) if offset
        params["limit"] = JSON::Any.new(limit) if limit
        params["timeout"] = JSON::Any.new(timeout) if timeout
        params["allowed_updates"] = JSON::Any.new(allowed_updates) if allowed_updates

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/getUpdates"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_a.map { |item| Update.from_json(item.to_json) }
      end

      # setWebhook
      # Use this method to specify a URL and receive incoming updates via an outgoing webhook. Whenever there is an update for the bot, we will send an HTTPS POST request to the specified URL, containing a JSON-serialized Update. In case of an unsuccessful request (a request with response HTTP status code different from 2XY), we will repeat the request and give up after a reasonable amount of attempts. Returns True on success.
      # If you'd like to make sure that the webhook was set by you, you can specify secret data in the parameter secret_token. If specified, the request will contain a header "X-Telegram-Bot-Api-Secret-Token" with the secret token as content.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setwebhook
      def set_webhook(url : String, certificate : File | IO? = nil, ip_address : String? = nil, max_connections : Int32? = nil, allowed_updates : Array(String)? = nil, drop_pending_updates : Bool? = nil, secret_token : String? = nil) : Bool
        # Build multipart form data for file upload
        boundary = MIME::Multipart.generate_boundary
        form_body = MIME::Multipart.build(boundary) do |builder|
          if url
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"url\""}
            builder.body_part(headers, url.to_s)
          end
          if certificate
            if certificate.is_a?(File)
              file_io = certificate
              filename = File.basename(certificate.path)
            elsif certificate.is_a?(IO)
              file_io = certificate
              filename = "file"
            else
              file_io = IO::Memory.new(certificate.to_s)
              filename = "file"
            end
            headers = HTTP::Headers{
              "Content-Disposition" => "form-data; name=\"certificate\"; filename=\"#{filename}\"",
              "Content-Type" => "application/octet-stream"
            }
            builder.body_part(headers, file_io)
          end
          if ip_address
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"ip_address\""}
            builder.body_part(headers, ip_address.to_s)
          end
          if max_connections
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"max_connections\""}
            builder.body_part(headers, max_connections.to_s)
          end
          if allowed_updates
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"allowed_updates\""}
            builder.body_part(headers, allowed_updates.to_s)
          end
          if drop_pending_updates
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"drop_pending_updates\""}
            builder.body_part(headers, drop_pending_updates.to_s)
          end
          if secret_token
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"secret_token\""}
            builder.body_part(headers, secret_token.to_s)
          end
        end

        # Make HTTP request with multipart form
        url = "#{@api_url}/bot#{@token}/setWebhook"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "multipart/form-data; boundary=#{boundary}"},
          body: form_body
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # deleteWebhook
      # Use this method to remove webhook integration if you decide to switch back to getUpdates. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#deletewebhook
      def delete_webhook(drop_pending_updates : Bool? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["drop_pending_updates"] = JSON::Any.new(drop_pending_updates) if drop_pending_updates

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/deleteWebhook"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # getWebhookInfo
      # Use this method to get current webhook status. Requires no parameters. On success, returns a WebhookInfo object. If the bot is using getUpdates, will return an object with the url field empty.
      #
      # Returns: WebhookInfo
      # See: https://core.telegram.org/bots/api#getwebhookinfo
      def get_webhook_info() : WebhookInfo
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/getWebhookInfo"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        WebhookInfo.from_json(json_response["result"].to_json)
      end

      # getMe
      # A simple method for testing your bot's authentication token. Requires no parameters. Returns basic information about the bot in form of a User object.
      #
      # Returns: User
      # See: https://core.telegram.org/bots/api#getme
      def get_me() : User
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/getMe"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        User.from_json(json_response["result"].to_json)
      end

      # logOut
      # Use this method to log out from the cloud Bot API server before launching the bot locally. You must log out the bot before running it locally, otherwise there is no guarantee that the bot will receive updates. After a successful call, you can immediately log in on a local server, but will not be able to log in back to the cloud Bot API server for 10 minutes. Returns True on success. Requires no parameters.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#logout
      def log_out() : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/logOut"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # close
      # Use this method to close the bot instance before moving it from one local server to another. You need to delete the webhook before calling this method to ensure that the bot isn't launched again after server restart. The method will return error 429 in the first 10 minutes after the bot is launched. Returns True on success. Requires no parameters.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#close
      def close() : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/close"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # sendMessage
      # Use this method to send text messages. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendmessage
      def send_message(chat_id : Int32 | String, text : String, business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, parse_mode : String? = nil, entities : Array(MessageEntity)? = nil, link_preview_options : LinkPreviewOptions? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_thread_id"] = JSON::Any.new(message_thread_id) if message_thread_id
        params["direct_messages_topic_id"] = JSON::Any.new(direct_messages_topic_id) if direct_messages_topic_id
        params["text"] = JSON::Any.new(text) if text
        params["parse_mode"] = JSON::Any.new(parse_mode) if parse_mode
        params["entities"] = JSON::Any.new(entities) if entities
        params["link_preview_options"] = JSON::Any.new(link_preview_options) if link_preview_options
        params["disable_notification"] = JSON::Any.new(disable_notification) if disable_notification
        params["protect_content"] = JSON::Any.new(protect_content) if protect_content
        params["allow_paid_broadcast"] = JSON::Any.new(allow_paid_broadcast) if allow_paid_broadcast
        params["message_effect_id"] = JSON::Any.new(message_effect_id) if message_effect_id
        params["suggested_post_parameters"] = JSON::Any.new(suggested_post_parameters) if suggested_post_parameters
        params["reply_parameters"] = JSON::Any.new(reply_parameters) if reply_parameters
        params["reply_markup"] = JSON::Any.new(reply_markup) if reply_markup

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/sendMessage"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        Message.from_json(json_response["result"].to_json)
      end

      # forwardMessage
      # Use this method to forward messages of any kind. Service messages and messages with protected content can't be forwarded. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#forwardmessage
      def forward_message(chat_id : Int32 | String, from_chat_id : Int32 | String, message_id : Int32, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, video_start_timestamp : Int32? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, suggested_post_parameters : SuggestedPostParameters? = nil) : Message
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_thread_id"] = JSON::Any.new(message_thread_id) if message_thread_id
        params["direct_messages_topic_id"] = JSON::Any.new(direct_messages_topic_id) if direct_messages_topic_id
        params["from_chat_id"] = JSON::Any.new(from_chat_id) if from_chat_id
        params["video_start_timestamp"] = JSON::Any.new(video_start_timestamp) if video_start_timestamp
        params["disable_notification"] = JSON::Any.new(disable_notification) if disable_notification
        params["protect_content"] = JSON::Any.new(protect_content) if protect_content
        params["suggested_post_parameters"] = JSON::Any.new(suggested_post_parameters) if suggested_post_parameters
        params["message_id"] = JSON::Any.new(message_id) if message_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/forwardMessage"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        Message.from_json(json_response["result"].to_json)
      end

      # forwardMessages
      # Use this method to forward multiple messages of any kind. If some of the specified messages can't be found or forwarded, they are skipped. Service messages and messages with protected content can't be forwarded. Album grouping is kept for forwarded messages. On success, an array of MessageId of the sent messages is returned.
      #
      # Returns: Array(MessageId)
      # See: https://core.telegram.org/bots/api#forwardmessages
      def forward_messages(chat_id : Int32 | String, from_chat_id : Int32 | String, message_ids : Array(Int32), message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil) : Array(MessageId)
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_thread_id"] = JSON::Any.new(message_thread_id) if message_thread_id
        params["direct_messages_topic_id"] = JSON::Any.new(direct_messages_topic_id) if direct_messages_topic_id
        params["from_chat_id"] = JSON::Any.new(from_chat_id) if from_chat_id
        params["message_ids"] = JSON::Any.new(message_ids) if message_ids
        params["disable_notification"] = JSON::Any.new(disable_notification) if disable_notification
        params["protect_content"] = JSON::Any.new(protect_content) if protect_content

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/forwardMessages"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_a.map { |item| MessageId.from_json(item.to_json) }
      end

      # copyMessage
      # Use this method to copy messages of any kind. Service messages, paid media messages, giveaway messages, giveaway winners messages, and invoice messages can't be copied. A quiz poll can be copied only if the value of the field correct_option_id is known to the bot. The method is analogous to the method forwardMessage, but the copied message doesn't have a link to the original message. Returns the MessageId of the sent message on success.
      #
      # Returns: MessageId
      # See: https://core.telegram.org/bots/api#copymessage
      def copy_message(chat_id : Int32 | String, from_chat_id : Int32 | String, message_id : Int32, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, video_start_timestamp : Int32? = nil, caption : String? = nil, parse_mode : String? = nil, caption_entities : Array(MessageEntity)? = nil, show_caption_above_media : Bool? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : MessageId
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_thread_id"] = JSON::Any.new(message_thread_id) if message_thread_id
        params["direct_messages_topic_id"] = JSON::Any.new(direct_messages_topic_id) if direct_messages_topic_id
        params["from_chat_id"] = JSON::Any.new(from_chat_id) if from_chat_id
        params["message_id"] = JSON::Any.new(message_id) if message_id
        params["video_start_timestamp"] = JSON::Any.new(video_start_timestamp) if video_start_timestamp
        params["caption"] = JSON::Any.new(caption) if caption
        params["parse_mode"] = JSON::Any.new(parse_mode) if parse_mode
        params["caption_entities"] = JSON::Any.new(caption_entities) if caption_entities
        params["show_caption_above_media"] = JSON::Any.new(show_caption_above_media) if show_caption_above_media
        params["disable_notification"] = JSON::Any.new(disable_notification) if disable_notification
        params["protect_content"] = JSON::Any.new(protect_content) if protect_content
        params["allow_paid_broadcast"] = JSON::Any.new(allow_paid_broadcast) if allow_paid_broadcast
        params["suggested_post_parameters"] = JSON::Any.new(suggested_post_parameters) if suggested_post_parameters
        params["reply_parameters"] = JSON::Any.new(reply_parameters) if reply_parameters
        params["reply_markup"] = JSON::Any.new(reply_markup) if reply_markup

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/copyMessage"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        MessageId.from_json(json_response["result"].to_json)
      end

      # copyMessages
      # Use this method to copy messages of any kind. If some of the specified messages can't be found or copied, they are skipped. Service messages, paid media messages, giveaway messages, giveaway winners messages, and invoice messages can't be copied. A quiz poll can be copied only if the value of the field correct_option_id is known to the bot. The method is analogous to the method forwardMessages, but the copied messages don't have a link to the original message. Album grouping is kept for copied messages. On success, an array of MessageId of the sent messages is returned.
      #
      # Returns: Array(MessageId)
      # See: https://core.telegram.org/bots/api#copymessages
      def copy_messages(chat_id : Int32 | String, from_chat_id : Int32 | String, message_ids : Array(Int32), message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, remove_caption : Bool? = nil) : Array(MessageId)
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_thread_id"] = JSON::Any.new(message_thread_id) if message_thread_id
        params["direct_messages_topic_id"] = JSON::Any.new(direct_messages_topic_id) if direct_messages_topic_id
        params["from_chat_id"] = JSON::Any.new(from_chat_id) if from_chat_id
        params["message_ids"] = JSON::Any.new(message_ids) if message_ids
        params["disable_notification"] = JSON::Any.new(disable_notification) if disable_notification
        params["protect_content"] = JSON::Any.new(protect_content) if protect_content
        params["remove_caption"] = JSON::Any.new(remove_caption) if remove_caption

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/copyMessages"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_a.map { |item| MessageId.from_json(item.to_json) }
      end

      # sendPhoto
      # Use this method to send photos. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendphoto
      def send_photo(chat_id : Int32 | String, photo : File | IO | String, business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, caption : String? = nil, parse_mode : String? = nil, caption_entities : Array(MessageEntity)? = nil, show_caption_above_media : Bool? = nil, has_spoiler : Bool? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Build multipart form data for file upload
        boundary = MIME::Multipart.generate_boundary
        form_body = MIME::Multipart.build(boundary) do |builder|
          if business_connection_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"business_connection_id\""}
            builder.body_part(headers, business_connection_id.to_s)
          end
          if chat_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"chat_id\""}
            builder.body_part(headers, chat_id.to_s)
          end
          if message_thread_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"message_thread_id\""}
            builder.body_part(headers, message_thread_id.to_s)
          end
          if direct_messages_topic_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"direct_messages_topic_id\""}
            builder.body_part(headers, direct_messages_topic_id.to_s)
          end
          if photo
            if photo.is_a?(File)
              file_io = photo
              filename = File.basename(photo.path)
            elsif photo.is_a?(IO)
              file_io = photo
              filename = "file"
            else
              file_io = IO::Memory.new(photo.to_s)
              filename = "file"
            end
            headers = HTTP::Headers{
              "Content-Disposition" => "form-data; name=\"photo\"; filename=\"#{filename}\"",
              "Content-Type" => "application/octet-stream"
            }
            builder.body_part(headers, file_io)
          end
          if caption
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"caption\""}
            builder.body_part(headers, caption.to_s)
          end
          if parse_mode
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"parse_mode\""}
            builder.body_part(headers, parse_mode.to_s)
          end
          if caption_entities
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"caption_entities\""}
            builder.body_part(headers, caption_entities.to_s)
          end
          if show_caption_above_media
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"show_caption_above_media\""}
            builder.body_part(headers, show_caption_above_media.to_s)
          end
          if has_spoiler
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"has_spoiler\""}
            builder.body_part(headers, has_spoiler.to_s)
          end
          if disable_notification
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"disable_notification\""}
            builder.body_part(headers, disable_notification.to_s)
          end
          if protect_content
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"protect_content\""}
            builder.body_part(headers, protect_content.to_s)
          end
          if allow_paid_broadcast
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"allow_paid_broadcast\""}
            builder.body_part(headers, allow_paid_broadcast.to_s)
          end
          if message_effect_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"message_effect_id\""}
            builder.body_part(headers, message_effect_id.to_s)
          end
          if suggested_post_parameters
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"suggested_post_parameters\""}
            builder.body_part(headers, suggested_post_parameters.to_s)
          end
          if reply_parameters
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"reply_parameters\""}
            builder.body_part(headers, reply_parameters.to_s)
          end
          if reply_markup
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"reply_markup\""}
            builder.body_part(headers, reply_markup.to_s)
          end
        end

        # Make HTTP request with multipart form
        url = "#{@api_url}/bot#{@token}/sendPhoto"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "multipart/form-data; boundary=#{boundary}"},
          body: form_body
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        Message.from_json(json_response["result"].to_json)
      end

      # sendAudio
      # Use this method to send audio files, if you want Telegram clients to display them in the music player. Your audio must be in the .MP3 or .M4A format. On success, the sent Message is returned. Bots can currently send audio files of up to 50 MB in size, this limit may be changed in the future.
      # For sending voice messages, use the sendVoice method instead.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendaudio
      def send_audio(chat_id : Int32 | String, audio : File | IO | String, business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, caption : String? = nil, parse_mode : String? = nil, caption_entities : Array(MessageEntity)? = nil, duration : Int32? = nil, performer : String? = nil, title : String? = nil, thumbnail : File | IO | String? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Build multipart form data for file upload
        boundary = MIME::Multipart.generate_boundary
        form_body = MIME::Multipart.build(boundary) do |builder|
          if business_connection_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"business_connection_id\""}
            builder.body_part(headers, business_connection_id.to_s)
          end
          if chat_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"chat_id\""}
            builder.body_part(headers, chat_id.to_s)
          end
          if message_thread_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"message_thread_id\""}
            builder.body_part(headers, message_thread_id.to_s)
          end
          if direct_messages_topic_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"direct_messages_topic_id\""}
            builder.body_part(headers, direct_messages_topic_id.to_s)
          end
          if audio
            if audio.is_a?(File)
              file_io = audio
              filename = File.basename(audio.path)
            elsif audio.is_a?(IO)
              file_io = audio
              filename = "file"
            else
              file_io = IO::Memory.new(audio.to_s)
              filename = "file"
            end
            headers = HTTP::Headers{
              "Content-Disposition" => "form-data; name=\"audio\"; filename=\"#{filename}\"",
              "Content-Type" => "application/octet-stream"
            }
            builder.body_part(headers, file_io)
          end
          if caption
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"caption\""}
            builder.body_part(headers, caption.to_s)
          end
          if parse_mode
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"parse_mode\""}
            builder.body_part(headers, parse_mode.to_s)
          end
          if caption_entities
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"caption_entities\""}
            builder.body_part(headers, caption_entities.to_s)
          end
          if duration
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"duration\""}
            builder.body_part(headers, duration.to_s)
          end
          if performer
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"performer\""}
            builder.body_part(headers, performer.to_s)
          end
          if title
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"title\""}
            builder.body_part(headers, title.to_s)
          end
          if thumbnail
            if thumbnail.is_a?(File)
              file_io = thumbnail
              filename = File.basename(thumbnail.path)
            elsif thumbnail.is_a?(IO)
              file_io = thumbnail
              filename = "file"
            else
              file_io = IO::Memory.new(thumbnail.to_s)
              filename = "file"
            end
            headers = HTTP::Headers{
              "Content-Disposition" => "form-data; name=\"thumbnail\"; filename=\"#{filename}\"",
              "Content-Type" => "application/octet-stream"
            }
            builder.body_part(headers, file_io)
          end
          if disable_notification
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"disable_notification\""}
            builder.body_part(headers, disable_notification.to_s)
          end
          if protect_content
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"protect_content\""}
            builder.body_part(headers, protect_content.to_s)
          end
          if allow_paid_broadcast
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"allow_paid_broadcast\""}
            builder.body_part(headers, allow_paid_broadcast.to_s)
          end
          if message_effect_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"message_effect_id\""}
            builder.body_part(headers, message_effect_id.to_s)
          end
          if suggested_post_parameters
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"suggested_post_parameters\""}
            builder.body_part(headers, suggested_post_parameters.to_s)
          end
          if reply_parameters
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"reply_parameters\""}
            builder.body_part(headers, reply_parameters.to_s)
          end
          if reply_markup
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"reply_markup\""}
            builder.body_part(headers, reply_markup.to_s)
          end
        end

        # Make HTTP request with multipart form
        url = "#{@api_url}/bot#{@token}/sendAudio"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "multipart/form-data; boundary=#{boundary}"},
          body: form_body
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        Message.from_json(json_response["result"].to_json)
      end

      # sendDocument
      # Use this method to send general files. On success, the sent Message is returned. Bots can currently send files of any type of up to 50 MB in size, this limit may be changed in the future.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#senddocument
      def send_document(chat_id : Int32 | String, document : File | IO | String, business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, thumbnail : File | IO | String? = nil, caption : String? = nil, parse_mode : String? = nil, caption_entities : Array(MessageEntity)? = nil, disable_content_type_detection : Bool? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Build multipart form data for file upload
        boundary = MIME::Multipart.generate_boundary
        form_body = MIME::Multipart.build(boundary) do |builder|
          if business_connection_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"business_connection_id\""}
            builder.body_part(headers, business_connection_id.to_s)
          end
          if chat_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"chat_id\""}
            builder.body_part(headers, chat_id.to_s)
          end
          if message_thread_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"message_thread_id\""}
            builder.body_part(headers, message_thread_id.to_s)
          end
          if direct_messages_topic_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"direct_messages_topic_id\""}
            builder.body_part(headers, direct_messages_topic_id.to_s)
          end
          if document
            if document.is_a?(File)
              file_io = document
              filename = File.basename(document.path)
            elsif document.is_a?(IO)
              file_io = document
              filename = "file"
            else
              file_io = IO::Memory.new(document.to_s)
              filename = "file"
            end
            headers = HTTP::Headers{
              "Content-Disposition" => "form-data; name=\"document\"; filename=\"#{filename}\"",
              "Content-Type" => "application/octet-stream"
            }
            builder.body_part(headers, file_io)
          end
          if thumbnail
            if thumbnail.is_a?(File)
              file_io = thumbnail
              filename = File.basename(thumbnail.path)
            elsif thumbnail.is_a?(IO)
              file_io = thumbnail
              filename = "file"
            else
              file_io = IO::Memory.new(thumbnail.to_s)
              filename = "file"
            end
            headers = HTTP::Headers{
              "Content-Disposition" => "form-data; name=\"thumbnail\"; filename=\"#{filename}\"",
              "Content-Type" => "application/octet-stream"
            }
            builder.body_part(headers, file_io)
          end
          if caption
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"caption\""}
            builder.body_part(headers, caption.to_s)
          end
          if parse_mode
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"parse_mode\""}
            builder.body_part(headers, parse_mode.to_s)
          end
          if caption_entities
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"caption_entities\""}
            builder.body_part(headers, caption_entities.to_s)
          end
          if disable_content_type_detection
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"disable_content_type_detection\""}
            builder.body_part(headers, disable_content_type_detection.to_s)
          end
          if disable_notification
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"disable_notification\""}
            builder.body_part(headers, disable_notification.to_s)
          end
          if protect_content
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"protect_content\""}
            builder.body_part(headers, protect_content.to_s)
          end
          if allow_paid_broadcast
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"allow_paid_broadcast\""}
            builder.body_part(headers, allow_paid_broadcast.to_s)
          end
          if message_effect_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"message_effect_id\""}
            builder.body_part(headers, message_effect_id.to_s)
          end
          if suggested_post_parameters
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"suggested_post_parameters\""}
            builder.body_part(headers, suggested_post_parameters.to_s)
          end
          if reply_parameters
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"reply_parameters\""}
            builder.body_part(headers, reply_parameters.to_s)
          end
          if reply_markup
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"reply_markup\""}
            builder.body_part(headers, reply_markup.to_s)
          end
        end

        # Make HTTP request with multipart form
        url = "#{@api_url}/bot#{@token}/sendDocument"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "multipart/form-data; boundary=#{boundary}"},
          body: form_body
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        Message.from_json(json_response["result"].to_json)
      end

      # sendVideo
      # Use this method to send video files, Telegram clients support MPEG4 videos (other formats may be sent as Document). On success, the sent Message is returned. Bots can currently send video files of up to 50 MB in size, this limit may be changed in the future.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendvideo
      def send_video(chat_id : Int32 | String, video : File | IO | String, business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, duration : Int32? = nil, width : Int32? = nil, height : Int32? = nil, thumbnail : File | IO | String? = nil, cover : File | IO | String? = nil, start_timestamp : Int32? = nil, caption : String? = nil, parse_mode : String? = nil, caption_entities : Array(MessageEntity)? = nil, show_caption_above_media : Bool? = nil, has_spoiler : Bool? = nil, supports_streaming : Bool? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Build multipart form data for file upload
        boundary = MIME::Multipart.generate_boundary
        form_body = MIME::Multipart.build(boundary) do |builder|
          if business_connection_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"business_connection_id\""}
            builder.body_part(headers, business_connection_id.to_s)
          end
          if chat_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"chat_id\""}
            builder.body_part(headers, chat_id.to_s)
          end
          if message_thread_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"message_thread_id\""}
            builder.body_part(headers, message_thread_id.to_s)
          end
          if direct_messages_topic_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"direct_messages_topic_id\""}
            builder.body_part(headers, direct_messages_topic_id.to_s)
          end
          if video
            if video.is_a?(File)
              file_io = video
              filename = File.basename(video.path)
            elsif video.is_a?(IO)
              file_io = video
              filename = "file"
            else
              file_io = IO::Memory.new(video.to_s)
              filename = "file"
            end
            headers = HTTP::Headers{
              "Content-Disposition" => "form-data; name=\"video\"; filename=\"#{filename}\"",
              "Content-Type" => "application/octet-stream"
            }
            builder.body_part(headers, file_io)
          end
          if duration
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"duration\""}
            builder.body_part(headers, duration.to_s)
          end
          if width
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"width\""}
            builder.body_part(headers, width.to_s)
          end
          if height
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"height\""}
            builder.body_part(headers, height.to_s)
          end
          if thumbnail
            if thumbnail.is_a?(File)
              file_io = thumbnail
              filename = File.basename(thumbnail.path)
            elsif thumbnail.is_a?(IO)
              file_io = thumbnail
              filename = "file"
            else
              file_io = IO::Memory.new(thumbnail.to_s)
              filename = "file"
            end
            headers = HTTP::Headers{
              "Content-Disposition" => "form-data; name=\"thumbnail\"; filename=\"#{filename}\"",
              "Content-Type" => "application/octet-stream"
            }
            builder.body_part(headers, file_io)
          end
          if cover
            if cover.is_a?(File)
              file_io = cover
              filename = File.basename(cover.path)
            elsif cover.is_a?(IO)
              file_io = cover
              filename = "file"
            else
              file_io = IO::Memory.new(cover.to_s)
              filename = "file"
            end
            headers = HTTP::Headers{
              "Content-Disposition" => "form-data; name=\"cover\"; filename=\"#{filename}\"",
              "Content-Type" => "application/octet-stream"
            }
            builder.body_part(headers, file_io)
          end
          if start_timestamp
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"start_timestamp\""}
            builder.body_part(headers, start_timestamp.to_s)
          end
          if caption
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"caption\""}
            builder.body_part(headers, caption.to_s)
          end
          if parse_mode
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"parse_mode\""}
            builder.body_part(headers, parse_mode.to_s)
          end
          if caption_entities
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"caption_entities\""}
            builder.body_part(headers, caption_entities.to_s)
          end
          if show_caption_above_media
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"show_caption_above_media\""}
            builder.body_part(headers, show_caption_above_media.to_s)
          end
          if has_spoiler
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"has_spoiler\""}
            builder.body_part(headers, has_spoiler.to_s)
          end
          if supports_streaming
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"supports_streaming\""}
            builder.body_part(headers, supports_streaming.to_s)
          end
          if disable_notification
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"disable_notification\""}
            builder.body_part(headers, disable_notification.to_s)
          end
          if protect_content
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"protect_content\""}
            builder.body_part(headers, protect_content.to_s)
          end
          if allow_paid_broadcast
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"allow_paid_broadcast\""}
            builder.body_part(headers, allow_paid_broadcast.to_s)
          end
          if message_effect_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"message_effect_id\""}
            builder.body_part(headers, message_effect_id.to_s)
          end
          if suggested_post_parameters
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"suggested_post_parameters\""}
            builder.body_part(headers, suggested_post_parameters.to_s)
          end
          if reply_parameters
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"reply_parameters\""}
            builder.body_part(headers, reply_parameters.to_s)
          end
          if reply_markup
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"reply_markup\""}
            builder.body_part(headers, reply_markup.to_s)
          end
        end

        # Make HTTP request with multipart form
        url = "#{@api_url}/bot#{@token}/sendVideo"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "multipart/form-data; boundary=#{boundary}"},
          body: form_body
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        Message.from_json(json_response["result"].to_json)
      end

      # sendAnimation
      # Use this method to send animation files (GIF or H.264/MPEG-4 AVC video without sound). On success, the sent Message is returned. Bots can currently send animation files of up to 50 MB in size, this limit may be changed in the future.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendanimation
      def send_animation(chat_id : Int32 | String, animation : File | IO | String, business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, duration : Int32? = nil, width : Int32? = nil, height : Int32? = nil, thumbnail : File | IO | String? = nil, caption : String? = nil, parse_mode : String? = nil, caption_entities : Array(MessageEntity)? = nil, show_caption_above_media : Bool? = nil, has_spoiler : Bool? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Build multipart form data for file upload
        boundary = MIME::Multipart.generate_boundary
        form_body = MIME::Multipart.build(boundary) do |builder|
          if business_connection_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"business_connection_id\""}
            builder.body_part(headers, business_connection_id.to_s)
          end
          if chat_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"chat_id\""}
            builder.body_part(headers, chat_id.to_s)
          end
          if message_thread_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"message_thread_id\""}
            builder.body_part(headers, message_thread_id.to_s)
          end
          if direct_messages_topic_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"direct_messages_topic_id\""}
            builder.body_part(headers, direct_messages_topic_id.to_s)
          end
          if animation
            if animation.is_a?(File)
              file_io = animation
              filename = File.basename(animation.path)
            elsif animation.is_a?(IO)
              file_io = animation
              filename = "file"
            else
              file_io = IO::Memory.new(animation.to_s)
              filename = "file"
            end
            headers = HTTP::Headers{
              "Content-Disposition" => "form-data; name=\"animation\"; filename=\"#{filename}\"",
              "Content-Type" => "application/octet-stream"
            }
            builder.body_part(headers, file_io)
          end
          if duration
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"duration\""}
            builder.body_part(headers, duration.to_s)
          end
          if width
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"width\""}
            builder.body_part(headers, width.to_s)
          end
          if height
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"height\""}
            builder.body_part(headers, height.to_s)
          end
          if thumbnail
            if thumbnail.is_a?(File)
              file_io = thumbnail
              filename = File.basename(thumbnail.path)
            elsif thumbnail.is_a?(IO)
              file_io = thumbnail
              filename = "file"
            else
              file_io = IO::Memory.new(thumbnail.to_s)
              filename = "file"
            end
            headers = HTTP::Headers{
              "Content-Disposition" => "form-data; name=\"thumbnail\"; filename=\"#{filename}\"",
              "Content-Type" => "application/octet-stream"
            }
            builder.body_part(headers, file_io)
          end
          if caption
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"caption\""}
            builder.body_part(headers, caption.to_s)
          end
          if parse_mode
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"parse_mode\""}
            builder.body_part(headers, parse_mode.to_s)
          end
          if caption_entities
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"caption_entities\""}
            builder.body_part(headers, caption_entities.to_s)
          end
          if show_caption_above_media
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"show_caption_above_media\""}
            builder.body_part(headers, show_caption_above_media.to_s)
          end
          if has_spoiler
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"has_spoiler\""}
            builder.body_part(headers, has_spoiler.to_s)
          end
          if disable_notification
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"disable_notification\""}
            builder.body_part(headers, disable_notification.to_s)
          end
          if protect_content
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"protect_content\""}
            builder.body_part(headers, protect_content.to_s)
          end
          if allow_paid_broadcast
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"allow_paid_broadcast\""}
            builder.body_part(headers, allow_paid_broadcast.to_s)
          end
          if message_effect_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"message_effect_id\""}
            builder.body_part(headers, message_effect_id.to_s)
          end
          if suggested_post_parameters
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"suggested_post_parameters\""}
            builder.body_part(headers, suggested_post_parameters.to_s)
          end
          if reply_parameters
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"reply_parameters\""}
            builder.body_part(headers, reply_parameters.to_s)
          end
          if reply_markup
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"reply_markup\""}
            builder.body_part(headers, reply_markup.to_s)
          end
        end

        # Make HTTP request with multipart form
        url = "#{@api_url}/bot#{@token}/sendAnimation"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "multipart/form-data; boundary=#{boundary}"},
          body: form_body
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        Message.from_json(json_response["result"].to_json)
      end

      # sendVoice
      # Use this method to send audio files, if you want Telegram clients to display the file as a playable voice message. For this to work, your audio must be in an .OGG file encoded with OPUS, or in .MP3 format, or in .M4A format (other formats may be sent as Audio or Document). On success, the sent Message is returned. Bots can currently send voice messages of up to 50 MB in size, this limit may be changed in the future.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendvoice
      def send_voice(chat_id : Int32 | String, voice : File | IO | String, business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, caption : String? = nil, parse_mode : String? = nil, caption_entities : Array(MessageEntity)? = nil, duration : Int32? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Build multipart form data for file upload
        boundary = MIME::Multipart.generate_boundary
        form_body = MIME::Multipart.build(boundary) do |builder|
          if business_connection_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"business_connection_id\""}
            builder.body_part(headers, business_connection_id.to_s)
          end
          if chat_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"chat_id\""}
            builder.body_part(headers, chat_id.to_s)
          end
          if message_thread_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"message_thread_id\""}
            builder.body_part(headers, message_thread_id.to_s)
          end
          if direct_messages_topic_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"direct_messages_topic_id\""}
            builder.body_part(headers, direct_messages_topic_id.to_s)
          end
          if voice
            if voice.is_a?(File)
              file_io = voice
              filename = File.basename(voice.path)
            elsif voice.is_a?(IO)
              file_io = voice
              filename = "file"
            else
              file_io = IO::Memory.new(voice.to_s)
              filename = "file"
            end
            headers = HTTP::Headers{
              "Content-Disposition" => "form-data; name=\"voice\"; filename=\"#{filename}\"",
              "Content-Type" => "application/octet-stream"
            }
            builder.body_part(headers, file_io)
          end
          if caption
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"caption\""}
            builder.body_part(headers, caption.to_s)
          end
          if parse_mode
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"parse_mode\""}
            builder.body_part(headers, parse_mode.to_s)
          end
          if caption_entities
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"caption_entities\""}
            builder.body_part(headers, caption_entities.to_s)
          end
          if duration
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"duration\""}
            builder.body_part(headers, duration.to_s)
          end
          if disable_notification
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"disable_notification\""}
            builder.body_part(headers, disable_notification.to_s)
          end
          if protect_content
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"protect_content\""}
            builder.body_part(headers, protect_content.to_s)
          end
          if allow_paid_broadcast
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"allow_paid_broadcast\""}
            builder.body_part(headers, allow_paid_broadcast.to_s)
          end
          if message_effect_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"message_effect_id\""}
            builder.body_part(headers, message_effect_id.to_s)
          end
          if suggested_post_parameters
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"suggested_post_parameters\""}
            builder.body_part(headers, suggested_post_parameters.to_s)
          end
          if reply_parameters
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"reply_parameters\""}
            builder.body_part(headers, reply_parameters.to_s)
          end
          if reply_markup
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"reply_markup\""}
            builder.body_part(headers, reply_markup.to_s)
          end
        end

        # Make HTTP request with multipart form
        url = "#{@api_url}/bot#{@token}/sendVoice"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "multipart/form-data; boundary=#{boundary}"},
          body: form_body
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        Message.from_json(json_response["result"].to_json)
      end

      # sendVideoNote
      # As of v.4.0, Telegram clients support rounded square MPEG4 videos of up to 1 minute long. Use this method to send video messages. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendvideonote
      def send_video_note(chat_id : Int32 | String, video_note : File | IO | String, business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, duration : Int32? = nil, length : Int32? = nil, thumbnail : File | IO | String? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Build multipart form data for file upload
        boundary = MIME::Multipart.generate_boundary
        form_body = MIME::Multipart.build(boundary) do |builder|
          if business_connection_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"business_connection_id\""}
            builder.body_part(headers, business_connection_id.to_s)
          end
          if chat_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"chat_id\""}
            builder.body_part(headers, chat_id.to_s)
          end
          if message_thread_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"message_thread_id\""}
            builder.body_part(headers, message_thread_id.to_s)
          end
          if direct_messages_topic_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"direct_messages_topic_id\""}
            builder.body_part(headers, direct_messages_topic_id.to_s)
          end
          if video_note
            if video_note.is_a?(File)
              file_io = video_note
              filename = File.basename(video_note.path)
            elsif video_note.is_a?(IO)
              file_io = video_note
              filename = "file"
            else
              file_io = IO::Memory.new(video_note.to_s)
              filename = "file"
            end
            headers = HTTP::Headers{
              "Content-Disposition" => "form-data; name=\"video_note\"; filename=\"#{filename}\"",
              "Content-Type" => "application/octet-stream"
            }
            builder.body_part(headers, file_io)
          end
          if duration
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"duration\""}
            builder.body_part(headers, duration.to_s)
          end
          if length
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"length\""}
            builder.body_part(headers, length.to_s)
          end
          if thumbnail
            if thumbnail.is_a?(File)
              file_io = thumbnail
              filename = File.basename(thumbnail.path)
            elsif thumbnail.is_a?(IO)
              file_io = thumbnail
              filename = "file"
            else
              file_io = IO::Memory.new(thumbnail.to_s)
              filename = "file"
            end
            headers = HTTP::Headers{
              "Content-Disposition" => "form-data; name=\"thumbnail\"; filename=\"#{filename}\"",
              "Content-Type" => "application/octet-stream"
            }
            builder.body_part(headers, file_io)
          end
          if disable_notification
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"disable_notification\""}
            builder.body_part(headers, disable_notification.to_s)
          end
          if protect_content
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"protect_content\""}
            builder.body_part(headers, protect_content.to_s)
          end
          if allow_paid_broadcast
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"allow_paid_broadcast\""}
            builder.body_part(headers, allow_paid_broadcast.to_s)
          end
          if message_effect_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"message_effect_id\""}
            builder.body_part(headers, message_effect_id.to_s)
          end
          if suggested_post_parameters
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"suggested_post_parameters\""}
            builder.body_part(headers, suggested_post_parameters.to_s)
          end
          if reply_parameters
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"reply_parameters\""}
            builder.body_part(headers, reply_parameters.to_s)
          end
          if reply_markup
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"reply_markup\""}
            builder.body_part(headers, reply_markup.to_s)
          end
        end

        # Make HTTP request with multipart form
        url = "#{@api_url}/bot#{@token}/sendVideoNote"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "multipart/form-data; boundary=#{boundary}"},
          body: form_body
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        Message.from_json(json_response["result"].to_json)
      end

      # sendPaidMedia
      # Use this method to send paid media. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendpaidmedia
      def send_paid_media(chat_id : Int32 | String, star_count : Int32, media : Array(InputPaidMedia), business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, payload : String? = nil, caption : String? = nil, parse_mode : String? = nil, caption_entities : Array(MessageEntity)? = nil, show_caption_above_media : Bool? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_thread_id"] = JSON::Any.new(message_thread_id) if message_thread_id
        params["direct_messages_topic_id"] = JSON::Any.new(direct_messages_topic_id) if direct_messages_topic_id
        params["star_count"] = JSON::Any.new(star_count) if star_count
        params["media"] = JSON::Any.new(media) if media
        params["payload"] = JSON::Any.new(payload) if payload
        params["caption"] = JSON::Any.new(caption) if caption
        params["parse_mode"] = JSON::Any.new(parse_mode) if parse_mode
        params["caption_entities"] = JSON::Any.new(caption_entities) if caption_entities
        params["show_caption_above_media"] = JSON::Any.new(show_caption_above_media) if show_caption_above_media
        params["disable_notification"] = JSON::Any.new(disable_notification) if disable_notification
        params["protect_content"] = JSON::Any.new(protect_content) if protect_content
        params["allow_paid_broadcast"] = JSON::Any.new(allow_paid_broadcast) if allow_paid_broadcast
        params["suggested_post_parameters"] = JSON::Any.new(suggested_post_parameters) if suggested_post_parameters
        params["reply_parameters"] = JSON::Any.new(reply_parameters) if reply_parameters
        params["reply_markup"] = JSON::Any.new(reply_markup) if reply_markup

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/sendPaidMedia"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        Message.from_json(json_response["result"].to_json)
      end

      # sendMediaGroup
      # Use this method to send a group of photos, videos, documents or audios as an album. Documents and audio files can be only grouped in an album with messages of the same type. On success, an array of Message objects that were sent is returned.
      #
      # Returns: Array(Message)
      # See: https://core.telegram.org/bots/api#sendmediagroup
      def send_media_group(chat_id : Int32 | String, media : Array(InputMediaAudio) | Array(InputMediaDocument) | Array(InputMediaPhoto) | Array(InputMediaVideo), business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, reply_parameters : ReplyParameters? = nil) : Array(Message)
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_thread_id"] = JSON::Any.new(message_thread_id) if message_thread_id
        params["direct_messages_topic_id"] = JSON::Any.new(direct_messages_topic_id) if direct_messages_topic_id
        params["media"] = JSON::Any.new(media) if media
        params["disable_notification"] = JSON::Any.new(disable_notification) if disable_notification
        params["protect_content"] = JSON::Any.new(protect_content) if protect_content
        params["allow_paid_broadcast"] = JSON::Any.new(allow_paid_broadcast) if allow_paid_broadcast
        params["message_effect_id"] = JSON::Any.new(message_effect_id) if message_effect_id
        params["reply_parameters"] = JSON::Any.new(reply_parameters) if reply_parameters

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/sendMediaGroup"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_a.map { |item| Message.from_json(item.to_json) }
      end

      # sendLocation
      # Use this method to send point on the map. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendlocation
      def send_location(chat_id : Int32 | String, latitude : Float64, longitude : Float64, business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, horizontal_accuracy : Float64? = nil, live_period : Int32? = nil, heading : Int32? = nil, proximity_alert_radius : Int32? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_thread_id"] = JSON::Any.new(message_thread_id) if message_thread_id
        params["direct_messages_topic_id"] = JSON::Any.new(direct_messages_topic_id) if direct_messages_topic_id
        params["latitude"] = JSON::Any.new(latitude) if latitude
        params["longitude"] = JSON::Any.new(longitude) if longitude
        params["horizontal_accuracy"] = JSON::Any.new(horizontal_accuracy) if horizontal_accuracy
        params["live_period"] = JSON::Any.new(live_period) if live_period
        params["heading"] = JSON::Any.new(heading) if heading
        params["proximity_alert_radius"] = JSON::Any.new(proximity_alert_radius) if proximity_alert_radius
        params["disable_notification"] = JSON::Any.new(disable_notification) if disable_notification
        params["protect_content"] = JSON::Any.new(protect_content) if protect_content
        params["allow_paid_broadcast"] = JSON::Any.new(allow_paid_broadcast) if allow_paid_broadcast
        params["message_effect_id"] = JSON::Any.new(message_effect_id) if message_effect_id
        params["suggested_post_parameters"] = JSON::Any.new(suggested_post_parameters) if suggested_post_parameters
        params["reply_parameters"] = JSON::Any.new(reply_parameters) if reply_parameters
        params["reply_markup"] = JSON::Any.new(reply_markup) if reply_markup

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/sendLocation"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        Message.from_json(json_response["result"].to_json)
      end

      # sendVenue
      # Use this method to send information about a venue. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendvenue
      def send_venue(chat_id : Int32 | String, latitude : Float64, longitude : Float64, title : String, address : String, business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, foursquare_id : String? = nil, foursquare_type : String? = nil, google_place_id : String? = nil, google_place_type : String? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_thread_id"] = JSON::Any.new(message_thread_id) if message_thread_id
        params["direct_messages_topic_id"] = JSON::Any.new(direct_messages_topic_id) if direct_messages_topic_id
        params["latitude"] = JSON::Any.new(latitude) if latitude
        params["longitude"] = JSON::Any.new(longitude) if longitude
        params["title"] = JSON::Any.new(title) if title
        params["address"] = JSON::Any.new(address) if address
        params["foursquare_id"] = JSON::Any.new(foursquare_id) if foursquare_id
        params["foursquare_type"] = JSON::Any.new(foursquare_type) if foursquare_type
        params["google_place_id"] = JSON::Any.new(google_place_id) if google_place_id
        params["google_place_type"] = JSON::Any.new(google_place_type) if google_place_type
        params["disable_notification"] = JSON::Any.new(disable_notification) if disable_notification
        params["protect_content"] = JSON::Any.new(protect_content) if protect_content
        params["allow_paid_broadcast"] = JSON::Any.new(allow_paid_broadcast) if allow_paid_broadcast
        params["message_effect_id"] = JSON::Any.new(message_effect_id) if message_effect_id
        params["suggested_post_parameters"] = JSON::Any.new(suggested_post_parameters) if suggested_post_parameters
        params["reply_parameters"] = JSON::Any.new(reply_parameters) if reply_parameters
        params["reply_markup"] = JSON::Any.new(reply_markup) if reply_markup

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/sendVenue"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        Message.from_json(json_response["result"].to_json)
      end

      # sendContact
      # Use this method to send phone contacts. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendcontact
      def send_contact(chat_id : Int32 | String, phone_number : String, first_name : String, business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, last_name : String? = nil, vcard : String? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_thread_id"] = JSON::Any.new(message_thread_id) if message_thread_id
        params["direct_messages_topic_id"] = JSON::Any.new(direct_messages_topic_id) if direct_messages_topic_id
        params["phone_number"] = JSON::Any.new(phone_number) if phone_number
        params["first_name"] = JSON::Any.new(first_name) if first_name
        params["last_name"] = JSON::Any.new(last_name) if last_name
        params["vcard"] = JSON::Any.new(vcard) if vcard
        params["disable_notification"] = JSON::Any.new(disable_notification) if disable_notification
        params["protect_content"] = JSON::Any.new(protect_content) if protect_content
        params["allow_paid_broadcast"] = JSON::Any.new(allow_paid_broadcast) if allow_paid_broadcast
        params["message_effect_id"] = JSON::Any.new(message_effect_id) if message_effect_id
        params["suggested_post_parameters"] = JSON::Any.new(suggested_post_parameters) if suggested_post_parameters
        params["reply_parameters"] = JSON::Any.new(reply_parameters) if reply_parameters
        params["reply_markup"] = JSON::Any.new(reply_markup) if reply_markup

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/sendContact"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        Message.from_json(json_response["result"].to_json)
      end

      # sendPoll
      # Use this method to send a native poll. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendpoll
      def send_poll(chat_id : Int32 | String, question : String, options : Array(InputPollOption), business_connection_id : String? = nil, message_thread_id : Int32? = nil, question_parse_mode : String? = nil, question_entities : Array(MessageEntity)? = nil, is_anonymous : Bool? = nil, type : String? = nil, allows_multiple_answers : Bool? = nil, correct_option_id : Int32? = nil, explanation : String? = nil, explanation_parse_mode : String? = nil, explanation_entities : Array(MessageEntity)? = nil, open_period : Int32? = nil, close_date : Int32? = nil, is_closed : Bool? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_thread_id"] = JSON::Any.new(message_thread_id) if message_thread_id
        params["question"] = JSON::Any.new(question) if question
        params["question_parse_mode"] = JSON::Any.new(question_parse_mode) if question_parse_mode
        params["question_entities"] = JSON::Any.new(question_entities) if question_entities
        params["options"] = JSON::Any.new(options) if options
        params["is_anonymous"] = JSON::Any.new(is_anonymous) if is_anonymous
        params["type"] = JSON::Any.new(type) if type
        params["allows_multiple_answers"] = JSON::Any.new(allows_multiple_answers) if allows_multiple_answers
        params["correct_option_id"] = JSON::Any.new(correct_option_id) if correct_option_id
        params["explanation"] = JSON::Any.new(explanation) if explanation
        params["explanation_parse_mode"] = JSON::Any.new(explanation_parse_mode) if explanation_parse_mode
        params["explanation_entities"] = JSON::Any.new(explanation_entities) if explanation_entities
        params["open_period"] = JSON::Any.new(open_period) if open_period
        params["close_date"] = JSON::Any.new(close_date) if close_date
        params["is_closed"] = JSON::Any.new(is_closed) if is_closed
        params["disable_notification"] = JSON::Any.new(disable_notification) if disable_notification
        params["protect_content"] = JSON::Any.new(protect_content) if protect_content
        params["allow_paid_broadcast"] = JSON::Any.new(allow_paid_broadcast) if allow_paid_broadcast
        params["message_effect_id"] = JSON::Any.new(message_effect_id) if message_effect_id
        params["reply_parameters"] = JSON::Any.new(reply_parameters) if reply_parameters
        params["reply_markup"] = JSON::Any.new(reply_markup) if reply_markup

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/sendPoll"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        Message.from_json(json_response["result"].to_json)
      end

      # sendChecklist
      # Use this method to send a checklist on behalf of a connected business account. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendchecklist
      def send_checklist(business_connection_id : String, chat_id : Int32, checklist : InputChecklist, disable_notification : Bool? = nil, protect_content : Bool? = nil, message_effect_id : String? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup? = nil) : Message
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["checklist"] = JSON::Any.new(checklist) if checklist
        params["disable_notification"] = JSON::Any.new(disable_notification) if disable_notification
        params["protect_content"] = JSON::Any.new(protect_content) if protect_content
        params["message_effect_id"] = JSON::Any.new(message_effect_id) if message_effect_id
        params["reply_parameters"] = JSON::Any.new(reply_parameters) if reply_parameters
        params["reply_markup"] = JSON::Any.new(reply_markup) if reply_markup

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/sendChecklist"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        Message.from_json(json_response["result"].to_json)
      end

      # sendDice
      # Use this method to send an animated emoji that will display a random value. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#senddice
      def send_dice(chat_id : Int32 | String, business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, emoji : String? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_thread_id"] = JSON::Any.new(message_thread_id) if message_thread_id
        params["direct_messages_topic_id"] = JSON::Any.new(direct_messages_topic_id) if direct_messages_topic_id
        params["emoji"] = JSON::Any.new(emoji) if emoji
        params["disable_notification"] = JSON::Any.new(disable_notification) if disable_notification
        params["protect_content"] = JSON::Any.new(protect_content) if protect_content
        params["allow_paid_broadcast"] = JSON::Any.new(allow_paid_broadcast) if allow_paid_broadcast
        params["message_effect_id"] = JSON::Any.new(message_effect_id) if message_effect_id
        params["suggested_post_parameters"] = JSON::Any.new(suggested_post_parameters) if suggested_post_parameters
        params["reply_parameters"] = JSON::Any.new(reply_parameters) if reply_parameters
        params["reply_markup"] = JSON::Any.new(reply_markup) if reply_markup

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/sendDice"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        Message.from_json(json_response["result"].to_json)
      end

      # sendChatAction
      # Use this method when you need to tell the user that something is happening on the bot's side. The status is set for 5 seconds or less (when a message arrives from your bot, Telegram clients clear its typing status). Returns True on success.
      # We only recommend using this method when a response from the bot will take a noticeable amount of time to arrive.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#sendchataction
      def send_chat_action(chat_id : Int32 | String, action : String, business_connection_id : String? = nil, message_thread_id : Int32? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_thread_id"] = JSON::Any.new(message_thread_id) if message_thread_id
        params["action"] = JSON::Any.new(action) if action

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/sendChatAction"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # setMessageReaction
      # Use this method to change the chosen reactions on a message. Service messages of some types can't be reacted to. Automatically forwarded messages from a channel to its discussion group have the same available reactions as messages in the channel. Bots can't use paid reactions. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setmessagereaction
      def set_message_reaction(chat_id : Int32 | String, message_id : Int32, reaction : Array(ReactionType)? = nil, is_big : Bool? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_id"] = JSON::Any.new(message_id) if message_id
        params["reaction"] = JSON::Any.new(reaction) if reaction
        params["is_big"] = JSON::Any.new(is_big) if is_big

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/setMessageReaction"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # getUserProfilePhotos
      # Use this method to get a list of profile pictures for a user. Returns a UserProfilePhotos object.
      #
      # Returns: UserProfilePhotos
      # See: https://core.telegram.org/bots/api#getuserprofilephotos
      def get_user_profile_photos(user_id : Int32, offset : Int32? = nil, limit : Int32? = nil) : UserProfilePhotos
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["user_id"] = JSON::Any.new(user_id) if user_id
        params["offset"] = JSON::Any.new(offset) if offset
        params["limit"] = JSON::Any.new(limit) if limit

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/getUserProfilePhotos"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        UserProfilePhotos.from_json(json_response["result"].to_json)
      end

      # setUserEmojiStatus
      # Changes the emoji status for a given user that previously allowed the bot to manage their emoji status via the Mini App method requestEmojiStatusAccess. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setuseremojistatus
      def set_user_emoji_status(user_id : Int32, emoji_status_custom_emoji_id : String? = nil, emoji_status_expiration_date : Int32? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["user_id"] = JSON::Any.new(user_id) if user_id
        params["emoji_status_custom_emoji_id"] = JSON::Any.new(emoji_status_custom_emoji_id) if emoji_status_custom_emoji_id
        params["emoji_status_expiration_date"] = JSON::Any.new(emoji_status_expiration_date) if emoji_status_expiration_date

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/setUserEmojiStatus"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # getFile
      # Use this method to get basic information about a file and prepare it for downloading. For the moment, bots can download files of up to 20MB in size. On success, a File object is returned. The file can then be downloaded via the link https://api.telegram.org/file/bot<token>/<file_path>, where <file_path> is taken from the response. It is guaranteed that the link will be valid for at least 1 hour. When the link expires, a new one can be requested by calling getFile again.
      # Note: This function may not preserve the original file name and MIME type. You should save the file's MIME type and name (if available) when the File object is received.
      #
      # Returns: TelegramFile
      # See: https://core.telegram.org/bots/api#getfile
      def get_file(file_id : String) : TelegramFile
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["file_id"] = JSON::Any.new(file_id) if file_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/getFile"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        TelegramFile.from_json(json_response["result"].to_json)
      end

      # banChatMember
      # Use this method to ban a user in a group, a supergroup or a channel. In the case of supergroups and channels, the user will not be able to return to the chat on their own using invite links, etc., unless unbanned first. The bot must be an administrator in the chat for this to work and must have the appropriate administrator rights. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#banchatmember
      def ban_chat_member(chat_id : Int32 | String, user_id : Int32, until_date : Int32? = nil, revoke_messages : Bool? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["user_id"] = JSON::Any.new(user_id) if user_id
        params["until_date"] = JSON::Any.new(until_date) if until_date
        params["revoke_messages"] = JSON::Any.new(revoke_messages) if revoke_messages

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/banChatMember"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # unbanChatMember
      # Use this method to unban a previously banned user in a supergroup or channel. The user will not return to the group or channel automatically, but will be able to join via link, etc. The bot must be an administrator for this to work. By default, this method guarantees that after the call the user is not a member of the chat, but will be able to join it. So if the user is a member of the chat they will also be removed from the chat. If you don't want this, use the parameter only_if_banned. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#unbanchatmember
      def unban_chat_member(chat_id : Int32 | String, user_id : Int32, only_if_banned : Bool? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["user_id"] = JSON::Any.new(user_id) if user_id
        params["only_if_banned"] = JSON::Any.new(only_if_banned) if only_if_banned

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/unbanChatMember"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # restrictChatMember
      # Use this method to restrict a user in a supergroup. The bot must be an administrator in the supergroup for this to work and must have the appropriate administrator rights. Pass True for all permissions to lift restrictions from a user. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#restrictchatmember
      def restrict_chat_member(chat_id : Int32 | String, user_id : Int32, permissions : ChatPermissions, use_independent_chat_permissions : Bool? = nil, until_date : Int32? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["user_id"] = JSON::Any.new(user_id) if user_id
        params["permissions"] = JSON::Any.new(permissions) if permissions
        params["use_independent_chat_permissions"] = JSON::Any.new(use_independent_chat_permissions) if use_independent_chat_permissions
        params["until_date"] = JSON::Any.new(until_date) if until_date

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/restrictChatMember"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # promoteChatMember
      # Use this method to promote or demote a user in a supergroup or a channel. The bot must be an administrator in the chat for this to work and must have the appropriate administrator rights. Pass False for all boolean parameters to demote a user. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#promotechatmember
      def promote_chat_member(chat_id : Int32 | String, user_id : Int32, is_anonymous : Bool? = nil, can_manage_chat : Bool? = nil, can_delete_messages : Bool? = nil, can_manage_video_chats : Bool? = nil, can_restrict_members : Bool? = nil, can_promote_members : Bool? = nil, can_change_info : Bool? = nil, can_invite_users : Bool? = nil, can_post_stories : Bool? = nil, can_edit_stories : Bool? = nil, can_delete_stories : Bool? = nil, can_post_messages : Bool? = nil, can_edit_messages : Bool? = nil, can_pin_messages : Bool? = nil, can_manage_topics : Bool? = nil, can_manage_direct_messages : Bool? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["user_id"] = JSON::Any.new(user_id) if user_id
        params["is_anonymous"] = JSON::Any.new(is_anonymous) if is_anonymous
        params["can_manage_chat"] = JSON::Any.new(can_manage_chat) if can_manage_chat
        params["can_delete_messages"] = JSON::Any.new(can_delete_messages) if can_delete_messages
        params["can_manage_video_chats"] = JSON::Any.new(can_manage_video_chats) if can_manage_video_chats
        params["can_restrict_members"] = JSON::Any.new(can_restrict_members) if can_restrict_members
        params["can_promote_members"] = JSON::Any.new(can_promote_members) if can_promote_members
        params["can_change_info"] = JSON::Any.new(can_change_info) if can_change_info
        params["can_invite_users"] = JSON::Any.new(can_invite_users) if can_invite_users
        params["can_post_stories"] = JSON::Any.new(can_post_stories) if can_post_stories
        params["can_edit_stories"] = JSON::Any.new(can_edit_stories) if can_edit_stories
        params["can_delete_stories"] = JSON::Any.new(can_delete_stories) if can_delete_stories
        params["can_post_messages"] = JSON::Any.new(can_post_messages) if can_post_messages
        params["can_edit_messages"] = JSON::Any.new(can_edit_messages) if can_edit_messages
        params["can_pin_messages"] = JSON::Any.new(can_pin_messages) if can_pin_messages
        params["can_manage_topics"] = JSON::Any.new(can_manage_topics) if can_manage_topics
        params["can_manage_direct_messages"] = JSON::Any.new(can_manage_direct_messages) if can_manage_direct_messages

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/promoteChatMember"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # setChatAdministratorCustomTitle
      # Use this method to set a custom title for an administrator in a supergroup promoted by the bot. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setchatadministratorcustomtitle
      def set_chat_administrator_custom_title(chat_id : Int32 | String, user_id : Int32, custom_title : String) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["user_id"] = JSON::Any.new(user_id) if user_id
        params["custom_title"] = JSON::Any.new(custom_title) if custom_title

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/setChatAdministratorCustomTitle"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # banChatSenderChat
      # Use this method to ban a channel chat in a supergroup or a channel. Until the chat is unbanned, the owner of the banned chat won't be able to send messages on behalf of any of their channels. The bot must be an administrator in the supergroup or channel for this to work and must have the appropriate administrator rights. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#banchatsenderchat
      def ban_chat_sender_chat(chat_id : Int32 | String, sender_chat_id : Int32) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["sender_chat_id"] = JSON::Any.new(sender_chat_id) if sender_chat_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/banChatSenderChat"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # unbanChatSenderChat
      # Use this method to unban a previously banned channel chat in a supergroup or channel. The bot must be an administrator for this to work and must have the appropriate administrator rights. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#unbanchatsenderchat
      def unban_chat_sender_chat(chat_id : Int32 | String, sender_chat_id : Int32) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["sender_chat_id"] = JSON::Any.new(sender_chat_id) if sender_chat_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/unbanChatSenderChat"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # setChatPermissions
      # Use this method to set default chat permissions for all members. The bot must be an administrator in the group or a supergroup for this to work and must have the can_restrict_members administrator rights. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setchatpermissions
      def set_chat_permissions(chat_id : Int32 | String, permissions : ChatPermissions, use_independent_chat_permissions : Bool? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["permissions"] = JSON::Any.new(permissions) if permissions
        params["use_independent_chat_permissions"] = JSON::Any.new(use_independent_chat_permissions) if use_independent_chat_permissions

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/setChatPermissions"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # exportChatInviteLink
      # Use this method to generate a new primary invite link for a chat; any previously generated primary link is revoked. The bot must be an administrator in the chat for this to work and must have the appropriate administrator rights. Returns the new invite link as String on success.
      #
      # Returns: String
      # See: https://core.telegram.org/bots/api#exportchatinvitelink
      def export_chat_invite_link(chat_id : Int32 | String) : String
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/exportChatInviteLink"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_s
      end

      # createChatInviteLink
      # Use this method to create an additional invite link for a chat. The bot must be an administrator in the chat for this to work and must have the appropriate administrator rights. The link can be revoked using the method revokeChatInviteLink. Returns the new invite link as ChatInviteLink object.
      #
      # Returns: ChatInviteLink
      # See: https://core.telegram.org/bots/api#createchatinvitelink
      def create_chat_invite_link(chat_id : Int32 | String, name : String? = nil, expire_date : Int32? = nil, member_limit : Int32? = nil, creates_join_request : Bool? = nil) : ChatInviteLink
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["name"] = JSON::Any.new(name) if name
        params["expire_date"] = JSON::Any.new(expire_date) if expire_date
        params["member_limit"] = JSON::Any.new(member_limit) if member_limit
        params["creates_join_request"] = JSON::Any.new(creates_join_request) if creates_join_request

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/createChatInviteLink"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        ChatInviteLink.from_json(json_response["result"].to_json)
      end

      # editChatInviteLink
      # Use this method to edit a non-primary invite link created by the bot. The bot must be an administrator in the chat for this to work and must have the appropriate administrator rights. Returns the edited invite link as a ChatInviteLink object.
      #
      # Returns: ChatInviteLink
      # See: https://core.telegram.org/bots/api#editchatinvitelink
      def edit_chat_invite_link(chat_id : Int32 | String, invite_link : String, name : String? = nil, expire_date : Int32? = nil, member_limit : Int32? = nil, creates_join_request : Bool? = nil) : ChatInviteLink
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["invite_link"] = JSON::Any.new(invite_link) if invite_link
        params["name"] = JSON::Any.new(name) if name
        params["expire_date"] = JSON::Any.new(expire_date) if expire_date
        params["member_limit"] = JSON::Any.new(member_limit) if member_limit
        params["creates_join_request"] = JSON::Any.new(creates_join_request) if creates_join_request

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/editChatInviteLink"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        ChatInviteLink.from_json(json_response["result"].to_json)
      end

      # createChatSubscriptionInviteLink
      # Use this method to create a subscription invite link for a channel chat. The bot must have the can_invite_users administrator rights. The link can be edited using the method editChatSubscriptionInviteLink or revoked using the method revokeChatInviteLink. Returns the new invite link as a ChatInviteLink object.
      #
      # Returns: ChatInviteLink
      # See: https://core.telegram.org/bots/api#createchatsubscriptioninvitelink
      def create_chat_subscription_invite_link(chat_id : Int32 | String, subscription_period : Int32, subscription_price : Int32, name : String? = nil) : ChatInviteLink
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["name"] = JSON::Any.new(name) if name
        params["subscription_period"] = JSON::Any.new(subscription_period) if subscription_period
        params["subscription_price"] = JSON::Any.new(subscription_price) if subscription_price

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/createChatSubscriptionInviteLink"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        ChatInviteLink.from_json(json_response["result"].to_json)
      end

      # editChatSubscriptionInviteLink
      # Use this method to edit a subscription invite link created by the bot. The bot must have the can_invite_users administrator rights. Returns the edited invite link as a ChatInviteLink object.
      #
      # Returns: ChatInviteLink
      # See: https://core.telegram.org/bots/api#editchatsubscriptioninvitelink
      def edit_chat_subscription_invite_link(chat_id : Int32 | String, invite_link : String, name : String? = nil) : ChatInviteLink
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["invite_link"] = JSON::Any.new(invite_link) if invite_link
        params["name"] = JSON::Any.new(name) if name

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/editChatSubscriptionInviteLink"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        ChatInviteLink.from_json(json_response["result"].to_json)
      end

      # revokeChatInviteLink
      # Use this method to revoke an invite link created by the bot. If the primary link is revoked, a new link is automatically generated. The bot must be an administrator in the chat for this to work and must have the appropriate administrator rights. Returns the revoked invite link as ChatInviteLink object.
      #
      # Returns: ChatInviteLink
      # See: https://core.telegram.org/bots/api#revokechatinvitelink
      def revoke_chat_invite_link(chat_id : Int32 | String, invite_link : String) : ChatInviteLink
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["invite_link"] = JSON::Any.new(invite_link) if invite_link

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/revokeChatInviteLink"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        ChatInviteLink.from_json(json_response["result"].to_json)
      end

      # approveChatJoinRequest
      # Use this method to approve a chat join request. The bot must be an administrator in the chat for this to work and must have the can_invite_users administrator right. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#approvechatjoinrequest
      def approve_chat_join_request(chat_id : Int32 | String, user_id : Int32) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["user_id"] = JSON::Any.new(user_id) if user_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/approveChatJoinRequest"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # declineChatJoinRequest
      # Use this method to decline a chat join request. The bot must be an administrator in the chat for this to work and must have the can_invite_users administrator right. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#declinechatjoinrequest
      def decline_chat_join_request(chat_id : Int32 | String, user_id : Int32) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["user_id"] = JSON::Any.new(user_id) if user_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/declineChatJoinRequest"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # setChatPhoto
      # Use this method to set a new profile photo for the chat. Photos can't be changed for private chats. The bot must be an administrator in the chat for this to work and must have the appropriate administrator rights. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setchatphoto
      def set_chat_photo(chat_id : Int32 | String, photo : File | IO) : Bool
        # Build multipart form data for file upload
        boundary = MIME::Multipart.generate_boundary
        form_body = MIME::Multipart.build(boundary) do |builder|
          if chat_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"chat_id\""}
            builder.body_part(headers, chat_id.to_s)
          end
          if photo
            if photo.is_a?(File)
              file_io = photo
              filename = File.basename(photo.path)
            elsif photo.is_a?(IO)
              file_io = photo
              filename = "file"
            else
              file_io = IO::Memory.new(photo.to_s)
              filename = "file"
            end
            headers = HTTP::Headers{
              "Content-Disposition" => "form-data; name=\"photo\"; filename=\"#{filename}\"",
              "Content-Type" => "application/octet-stream"
            }
            builder.body_part(headers, file_io)
          end
        end

        # Make HTTP request with multipart form
        url = "#{@api_url}/bot#{@token}/setChatPhoto"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "multipart/form-data; boundary=#{boundary}"},
          body: form_body
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # deleteChatPhoto
      # Use this method to delete a chat photo. Photos can't be changed for private chats. The bot must be an administrator in the chat for this to work and must have the appropriate administrator rights. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#deletechatphoto
      def delete_chat_photo(chat_id : Int32 | String) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/deleteChatPhoto"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # setChatTitle
      # Use this method to change the title of a chat. Titles can't be changed for private chats. The bot must be an administrator in the chat for this to work and must have the appropriate administrator rights. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setchattitle
      def set_chat_title(chat_id : Int32 | String, title : String) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["title"] = JSON::Any.new(title) if title

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/setChatTitle"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # setChatDescription
      # Use this method to change the description of a group, a supergroup or a channel. The bot must be an administrator in the chat for this to work and must have the appropriate administrator rights. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setchatdescription
      def set_chat_description(chat_id : Int32 | String, description : String? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["description"] = JSON::Any.new(description) if description

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/setChatDescription"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # pinChatMessage
      # Use this method to add a message to the list of pinned messages in a chat. In private chats and channel direct messages chats, all non-service messages can be pinned. Conversely, the bot must be an administrator with the 'can_pin_messages' right or the 'can_edit_messages' right to pin messages in groups and channels respectively. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#pinchatmessage
      def pin_chat_message(chat_id : Int32 | String, message_id : Int32, business_connection_id : String? = nil, disable_notification : Bool? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_id"] = JSON::Any.new(message_id) if message_id
        params["disable_notification"] = JSON::Any.new(disable_notification) if disable_notification

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/pinChatMessage"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # unpinChatMessage
      # Use this method to remove a message from the list of pinned messages in a chat. In private chats and channel direct messages chats, all messages can be unpinned. Conversely, the bot must be an administrator with the 'can_pin_messages' right or the 'can_edit_messages' right to unpin messages in groups and channels respectively. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#unpinchatmessage
      def unpin_chat_message(chat_id : Int32 | String, business_connection_id : String? = nil, message_id : Int32? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_id"] = JSON::Any.new(message_id) if message_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/unpinChatMessage"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # unpinAllChatMessages
      # Use this method to clear the list of pinned messages in a chat. In private chats and channel direct messages chats, no additional rights are required to unpin all pinned messages. Conversely, the bot must be an administrator with the 'can_pin_messages' right or the 'can_edit_messages' right to unpin all pinned messages in groups and channels respectively. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#unpinallchatmessages
      def unpin_all_chat_messages(chat_id : Int32 | String) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/unpinAllChatMessages"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # leaveChat
      # Use this method for your bot to leave a group, supergroup or channel. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#leavechat
      def leave_chat(chat_id : Int32 | String) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/leaveChat"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # getChat
      # Use this method to get up-to-date information about the chat. Returns a ChatFullInfo object on success.
      #
      # Returns: ChatFullInfo
      # See: https://core.telegram.org/bots/api#getchat
      def get_chat(chat_id : Int32 | String) : ChatFullInfo
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/getChat"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        ChatFullInfo.from_json(json_response["result"].to_json)
      end

      # getChatAdministrators
      # Use this method to get a list of administrators in a chat, which aren't bots. Returns an Array of ChatMember objects.
      #
      # Returns: Array(ChatMember)
      # See: https://core.telegram.org/bots/api#getchatadministrators
      def get_chat_administrators(chat_id : Int32 | String) : Array(ChatMember)
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/getChatAdministrators"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_a.map { |item| ChatMember.from_json(item.to_json) }
      end

      # getChatMemberCount
      # Use this method to get the number of members in a chat. Returns Int on success.
      #
      # Returns: Int32
      # See: https://core.telegram.org/bots/api#getchatmembercount
      def get_chat_member_count(chat_id : Int32 | String) : Int32
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/getChatMemberCount"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_i
      end

      # getChatMember
      # Use this method to get information about a member of a chat. The method is only guaranteed to work for other users if the bot is an administrator in the chat. Returns a ChatMember object on success.
      #
      # Returns: ChatMember
      # See: https://core.telegram.org/bots/api#getchatmember
      def get_chat_member(chat_id : Int32 | String, user_id : Int32) : ChatMember
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["user_id"] = JSON::Any.new(user_id) if user_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/getChatMember"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        ChatMember.from_json(json_response["result"].to_json)
      end

      # setChatStickerSet
      # Use this method to set a new group sticker set for a supergroup. The bot must be an administrator in the chat for this to work and must have the appropriate administrator rights. Use the field can_set_sticker_set optionally returned in getChat requests to check if the bot can use this method. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setchatstickerset
      def set_chat_sticker_set(chat_id : Int32 | String, sticker_set_name : String) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["sticker_set_name"] = JSON::Any.new(sticker_set_name) if sticker_set_name

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/setChatStickerSet"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # deleteChatStickerSet
      # Use this method to delete a group sticker set from a supergroup. The bot must be an administrator in the chat for this to work and must have the appropriate administrator rights. Use the field can_set_sticker_set optionally returned in getChat requests to check if the bot can use this method. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#deletechatstickerset
      def delete_chat_sticker_set(chat_id : Int32 | String) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/deleteChatStickerSet"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # getForumTopicIconStickers
      # Use this method to get custom emoji stickers, which can be used as a forum topic icon by any user. Requires no parameters. Returns an Array of Sticker objects.
      #
      # Returns: Array(Sticker)
      # See: https://core.telegram.org/bots/api#getforumtopiciconstickers
      def get_forum_topic_icon_stickers() : Array(Sticker)
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/getForumTopicIconStickers"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_a.map { |item| Sticker.from_json(item.to_json) }
      end

      # createForumTopic
      # Use this method to create a topic in a forum supergroup chat. The bot must be an administrator in the chat for this to work and must have the can_manage_topics administrator rights. Returns information about the created topic as a ForumTopic object.
      #
      # Returns: ForumTopic
      # See: https://core.telegram.org/bots/api#createforumtopic
      def create_forum_topic(chat_id : Int32 | String, name : String, icon_color : Int32? = nil, icon_custom_emoji_id : String? = nil) : ForumTopic
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["name"] = JSON::Any.new(name) if name
        params["icon_color"] = JSON::Any.new(icon_color) if icon_color
        params["icon_custom_emoji_id"] = JSON::Any.new(icon_custom_emoji_id) if icon_custom_emoji_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/createForumTopic"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        ForumTopic.from_json(json_response["result"].to_json)
      end

      # editForumTopic
      # Use this method to edit name and icon of a topic in a forum supergroup chat. The bot must be an administrator in the chat for this to work and must have the can_manage_topics administrator rights, unless it is the creator of the topic. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#editforumtopic
      def edit_forum_topic(chat_id : Int32 | String, message_thread_id : Int32, name : String? = nil, icon_custom_emoji_id : String? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_thread_id"] = JSON::Any.new(message_thread_id) if message_thread_id
        params["name"] = JSON::Any.new(name) if name
        params["icon_custom_emoji_id"] = JSON::Any.new(icon_custom_emoji_id) if icon_custom_emoji_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/editForumTopic"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # closeForumTopic
      # Use this method to close an open topic in a forum supergroup chat. The bot must be an administrator in the chat for this to work and must have the can_manage_topics administrator rights, unless it is the creator of the topic. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#closeforumtopic
      def close_forum_topic(chat_id : Int32 | String, message_thread_id : Int32) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_thread_id"] = JSON::Any.new(message_thread_id) if message_thread_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/closeForumTopic"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # reopenForumTopic
      # Use this method to reopen a closed topic in a forum supergroup chat. The bot must be an administrator in the chat for this to work and must have the can_manage_topics administrator rights, unless it is the creator of the topic. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#reopenforumtopic
      def reopen_forum_topic(chat_id : Int32 | String, message_thread_id : Int32) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_thread_id"] = JSON::Any.new(message_thread_id) if message_thread_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/reopenForumTopic"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # deleteForumTopic
      # Use this method to delete a forum topic along with all its messages in a forum supergroup chat. The bot must be an administrator in the chat for this to work and must have the can_delete_messages administrator rights. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#deleteforumtopic
      def delete_forum_topic(chat_id : Int32 | String, message_thread_id : Int32) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_thread_id"] = JSON::Any.new(message_thread_id) if message_thread_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/deleteForumTopic"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # unpinAllForumTopicMessages
      # Use this method to clear the list of pinned messages in a forum topic. The bot must be an administrator in the chat for this to work and must have the can_pin_messages administrator right in the supergroup. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#unpinallforumtopicmessages
      def unpin_all_forum_topic_messages(chat_id : Int32 | String, message_thread_id : Int32) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_thread_id"] = JSON::Any.new(message_thread_id) if message_thread_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/unpinAllForumTopicMessages"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # editGeneralForumTopic
      # Use this method to edit the name of the 'General' topic in a forum supergroup chat. The bot must be an administrator in the chat for this to work and must have the can_manage_topics administrator rights. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#editgeneralforumtopic
      def edit_general_forum_topic(chat_id : Int32 | String, name : String) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["name"] = JSON::Any.new(name) if name

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/editGeneralForumTopic"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # closeGeneralForumTopic
      # Use this method to close an open 'General' topic in a forum supergroup chat. The bot must be an administrator in the chat for this to work and must have the can_manage_topics administrator rights. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#closegeneralforumtopic
      def close_general_forum_topic(chat_id : Int32 | String) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/closeGeneralForumTopic"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # reopenGeneralForumTopic
      # Use this method to reopen a closed 'General' topic in a forum supergroup chat. The bot must be an administrator in the chat for this to work and must have the can_manage_topics administrator rights. The topic will be automatically unhidden if it was hidden. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#reopengeneralforumtopic
      def reopen_general_forum_topic(chat_id : Int32 | String) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/reopenGeneralForumTopic"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # hideGeneralForumTopic
      # Use this method to hide the 'General' topic in a forum supergroup chat. The bot must be an administrator in the chat for this to work and must have the can_manage_topics administrator rights. The topic will be automatically closed if it was open. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#hidegeneralforumtopic
      def hide_general_forum_topic(chat_id : Int32 | String) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/hideGeneralForumTopic"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # unhideGeneralForumTopic
      # Use this method to unhide the 'General' topic in a forum supergroup chat. The bot must be an administrator in the chat for this to work and must have the can_manage_topics administrator rights. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#unhidegeneralforumtopic
      def unhide_general_forum_topic(chat_id : Int32 | String) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/unhideGeneralForumTopic"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # unpinAllGeneralForumTopicMessages
      # Use this method to clear the list of pinned messages in a General forum topic. The bot must be an administrator in the chat for this to work and must have the can_pin_messages administrator right in the supergroup. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#unpinallgeneralforumtopicmessages
      def unpin_all_general_forum_topic_messages(chat_id : Int32 | String) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/unpinAllGeneralForumTopicMessages"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # answerCallbackQuery
      # Use this method to send answers to callback queries sent from inline keyboards. The answer will be displayed to the user as a notification at the top of the chat screen or as an alert. On success, True is returned.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#answercallbackquery
      def answer_callback_query(callback_query_id : String, text : String? = nil, show_alert : Bool? = nil, url : String? = nil, cache_time : Int32? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["callback_query_id"] = JSON::Any.new(callback_query_id) if callback_query_id
        params["text"] = JSON::Any.new(text) if text
        params["show_alert"] = JSON::Any.new(show_alert) if show_alert
        params["url"] = JSON::Any.new(url) if url
        params["cache_time"] = JSON::Any.new(cache_time) if cache_time

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/answerCallbackQuery"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # getUserChatBoosts
      # Use this method to get the list of boosts added to a chat by a user. Requires administrator rights in the chat. Returns a UserChatBoosts object.
      #
      # Returns: UserChatBoosts
      # See: https://core.telegram.org/bots/api#getuserchatboosts
      def get_user_chat_boosts(chat_id : Int32 | String, user_id : Int32) : UserChatBoosts
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["user_id"] = JSON::Any.new(user_id) if user_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/getUserChatBoosts"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        UserChatBoosts.from_json(json_response["result"].to_json)
      end

      # getBusinessConnection
      # Use this method to get information about the connection of the bot with a business account. Returns a BusinessConnection object on success.
      #
      # Returns: BusinessConnection
      # See: https://core.telegram.org/bots/api#getbusinessconnection
      def get_business_connection(business_connection_id : String) : BusinessConnection
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/getBusinessConnection"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        BusinessConnection.from_json(json_response["result"].to_json)
      end

      # setMyCommands
      # Use this method to change the list of the bot's commands. See this manual for more details about bot commands. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setmycommands
      def set_my_commands(commands : Array(BotCommand), scope : BotCommandScope? = nil, language_code : String? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["commands"] = JSON::Any.new(commands) if commands
        params["scope"] = JSON::Any.new(scope) if scope
        params["language_code"] = JSON::Any.new(language_code) if language_code

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/setMyCommands"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # deleteMyCommands
      # Use this method to delete the list of the bot's commands for the given scope and user language. After deletion, higher level commands will be shown to affected users. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#deletemycommands
      def delete_my_commands(scope : BotCommandScope? = nil, language_code : String? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["scope"] = JSON::Any.new(scope) if scope
        params["language_code"] = JSON::Any.new(language_code) if language_code

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/deleteMyCommands"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # getMyCommands
      # Use this method to get the current list of the bot's commands for the given scope and user language. Returns an Array of BotCommand objects. If commands aren't set, an empty list is returned.
      #
      # Returns: Array(BotCommand)
      # See: https://core.telegram.org/bots/api#getmycommands
      def get_my_commands(scope : BotCommandScope? = nil, language_code : String? = nil) : Array(BotCommand)
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["scope"] = JSON::Any.new(scope) if scope
        params["language_code"] = JSON::Any.new(language_code) if language_code

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/getMyCommands"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_a.map { |item| BotCommand.from_json(item.to_json) }
      end

      # setMyName
      # Use this method to change the bot's name. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setmyname
      def set_my_name(name : String? = nil, language_code : String? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["name"] = JSON::Any.new(name) if name
        params["language_code"] = JSON::Any.new(language_code) if language_code

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/setMyName"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # getMyName
      # Use this method to get the current bot name for the given user language. Returns BotName on success.
      #
      # Returns: BotName
      # See: https://core.telegram.org/bots/api#getmyname
      def get_my_name(language_code : String? = nil) : BotName
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["language_code"] = JSON::Any.new(language_code) if language_code

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/getMyName"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        BotName.from_json(json_response["result"].to_json)
      end

      # setMyDescription
      # Use this method to change the bot's description, which is shown in the chat with the bot if the chat is empty. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setmydescription
      def set_my_description(description : String? = nil, language_code : String? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["description"] = JSON::Any.new(description) if description
        params["language_code"] = JSON::Any.new(language_code) if language_code

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/setMyDescription"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # getMyDescription
      # Use this method to get the current bot description for the given user language. Returns BotDescription on success.
      #
      # Returns: BotDescription
      # See: https://core.telegram.org/bots/api#getmydescription
      def get_my_description(language_code : String? = nil) : BotDescription
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["language_code"] = JSON::Any.new(language_code) if language_code

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/getMyDescription"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        BotDescription.from_json(json_response["result"].to_json)
      end

      # setMyShortDescription
      # Use this method to change the bot's short description, which is shown on the bot's profile page and is sent together with the link when users share the bot. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setmyshortdescription
      def set_my_short_description(short_description : String? = nil, language_code : String? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["short_description"] = JSON::Any.new(short_description) if short_description
        params["language_code"] = JSON::Any.new(language_code) if language_code

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/setMyShortDescription"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # getMyShortDescription
      # Use this method to get the current bot short description for the given user language. Returns BotShortDescription on success.
      #
      # Returns: BotShortDescription
      # See: https://core.telegram.org/bots/api#getmyshortdescription
      def get_my_short_description(language_code : String? = nil) : BotShortDescription
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["language_code"] = JSON::Any.new(language_code) if language_code

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/getMyShortDescription"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        BotShortDescription.from_json(json_response["result"].to_json)
      end

      # setChatMenuButton
      # Use this method to change the bot's menu button in a private chat, or the default menu button. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setchatmenubutton
      def set_chat_menu_button(chat_id : Int32? = nil, menu_button : MenuButton? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["menu_button"] = JSON::Any.new(menu_button) if menu_button

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/setChatMenuButton"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # getChatMenuButton
      # Use this method to get the current value of the bot's menu button in a private chat, or the default menu button. Returns MenuButton on success.
      #
      # Returns: MenuButton
      # See: https://core.telegram.org/bots/api#getchatmenubutton
      def get_chat_menu_button(chat_id : Int32? = nil) : MenuButton
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/getChatMenuButton"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        MenuButton.from_json(json_response["result"].to_json)
      end

      # setMyDefaultAdministratorRights
      # Use this method to change the default administrator rights requested by the bot when it's added as an administrator to groups or channels. These rights will be suggested to users, but they are free to modify the list before adding the bot. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setmydefaultadministratorrights
      def set_my_default_administrator_rights(rights : ChatAdministratorRights? = nil, for_channels : Bool? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["rights"] = JSON::Any.new(rights) if rights
        params["for_channels"] = JSON::Any.new(for_channels) if for_channels

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/setMyDefaultAdministratorRights"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # getMyDefaultAdministratorRights
      # Use this method to get the current default administrator rights of the bot. Returns ChatAdministratorRights on success.
      #
      # Returns: ChatAdministratorRights
      # See: https://core.telegram.org/bots/api#getmydefaultadministratorrights
      def get_my_default_administrator_rights(for_channels : Bool? = nil) : ChatAdministratorRights
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["for_channels"] = JSON::Any.new(for_channels) if for_channels

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/getMyDefaultAdministratorRights"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        ChatAdministratorRights.from_json(json_response["result"].to_json)
      end

      # getAvailableGifts
      # Returns the list of gifts that can be sent by the bot to users and channel chats. Requires no parameters. Returns a Gifts object.
      #
      # Returns: Gifts
      # See: https://core.telegram.org/bots/api#getavailablegifts
      def get_available_gifts() : Gifts
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/getAvailableGifts"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        Gifts.from_json(json_response["result"].to_json)
      end

      # sendGift
      # Sends a gift to the given user or channel chat. The gift can't be converted to Telegram Stars by the receiver. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#sendgift
      def send_gift(gift_id : String, user_id : Int32? = nil, chat_id : Int32 | String? = nil, pay_for_upgrade : Bool? = nil, text : String? = nil, text_parse_mode : String? = nil, text_entities : Array(MessageEntity)? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["user_id"] = JSON::Any.new(user_id) if user_id
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["gift_id"] = JSON::Any.new(gift_id) if gift_id
        params["pay_for_upgrade"] = JSON::Any.new(pay_for_upgrade) if pay_for_upgrade
        params["text"] = JSON::Any.new(text) if text
        params["text_parse_mode"] = JSON::Any.new(text_parse_mode) if text_parse_mode
        params["text_entities"] = JSON::Any.new(text_entities) if text_entities

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/sendGift"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # giftPremiumSubscription
      # Gifts a Telegram Premium subscription to the given user. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#giftpremiumsubscription
      def gift_premium_subscription(user_id : Int32, month_count : Int32, star_count : Int32, text : String? = nil, text_parse_mode : String? = nil, text_entities : Array(MessageEntity)? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["user_id"] = JSON::Any.new(user_id) if user_id
        params["month_count"] = JSON::Any.new(month_count) if month_count
        params["star_count"] = JSON::Any.new(star_count) if star_count
        params["text"] = JSON::Any.new(text) if text
        params["text_parse_mode"] = JSON::Any.new(text_parse_mode) if text_parse_mode
        params["text_entities"] = JSON::Any.new(text_entities) if text_entities

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/giftPremiumSubscription"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # verifyUser
      # Verifies a user on behalf of the organization which is represented by the bot. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#verifyuser
      def verify_user(user_id : Int32, custom_description : String? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["user_id"] = JSON::Any.new(user_id) if user_id
        params["custom_description"] = JSON::Any.new(custom_description) if custom_description

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/verifyUser"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # verifyChat
      # Verifies a chat on behalf of the organization which is represented by the bot. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#verifychat
      def verify_chat(chat_id : Int32 | String, custom_description : String? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["custom_description"] = JSON::Any.new(custom_description) if custom_description

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/verifyChat"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # removeUserVerification
      # Removes verification from a user who is currently verified on behalf of the organization represented by the bot. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#removeuserverification
      def remove_user_verification(user_id : Int32) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["user_id"] = JSON::Any.new(user_id) if user_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/removeUserVerification"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # removeChatVerification
      # Removes verification from a chat that is currently verified on behalf of the organization represented by the bot. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#removechatverification
      def remove_chat_verification(chat_id : Int32 | String) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/removeChatVerification"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # readBusinessMessage
      # Marks incoming message as read on behalf of a business account. Requires the can_read_messages business bot right. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#readbusinessmessage
      def read_business_message(business_connection_id : String, chat_id : Int32, message_id : Int32) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_id"] = JSON::Any.new(message_id) if message_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/readBusinessMessage"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # deleteBusinessMessages
      # Delete messages on behalf of a business account. Requires the can_delete_sent_messages business bot right to delete messages sent by the bot itself, or the can_delete_all_messages business bot right to delete any message. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#deletebusinessmessages
      def delete_business_messages(business_connection_id : String, message_ids : Array(Int32)) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["message_ids"] = JSON::Any.new(message_ids) if message_ids

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/deleteBusinessMessages"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # setBusinessAccountName
      # Changes the first and last name of a managed business account. Requires the can_change_name business bot right. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setbusinessaccountname
      def set_business_account_name(business_connection_id : String, first_name : String, last_name : String? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["first_name"] = JSON::Any.new(first_name) if first_name
        params["last_name"] = JSON::Any.new(last_name) if last_name

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/setBusinessAccountName"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # setBusinessAccountUsername
      # Changes the username of a managed business account. Requires the can_change_username business bot right. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setbusinessaccountusername
      def set_business_account_username(business_connection_id : String, username : String? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["username"] = JSON::Any.new(username) if username

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/setBusinessAccountUsername"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # setBusinessAccountBio
      # Changes the bio of a managed business account. Requires the can_change_bio business bot right. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setbusinessaccountbio
      def set_business_account_bio(business_connection_id : String, bio : String? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["bio"] = JSON::Any.new(bio) if bio

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/setBusinessAccountBio"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # setBusinessAccountProfilePhoto
      # Changes the profile photo of a managed business account. Requires the can_edit_profile_photo business bot right. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setbusinessaccountprofilephoto
      def set_business_account_profile_photo(business_connection_id : String, photo : InputProfilePhoto, is_public : Bool? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["photo"] = JSON::Any.new(photo) if photo
        params["is_public"] = JSON::Any.new(is_public) if is_public

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/setBusinessAccountProfilePhoto"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # removeBusinessAccountProfilePhoto
      # Removes the current profile photo of a managed business account. Requires the can_edit_profile_photo business bot right. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#removebusinessaccountprofilephoto
      def remove_business_account_profile_photo(business_connection_id : String, is_public : Bool? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["is_public"] = JSON::Any.new(is_public) if is_public

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/removeBusinessAccountProfilePhoto"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # setBusinessAccountGiftSettings
      # Changes the privacy settings pertaining to incoming gifts in a managed business account. Requires the can_change_gift_settings business bot right. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setbusinessaccountgiftsettings
      def set_business_account_gift_settings(business_connection_id : String, show_gift_button : Bool, accepted_gift_types : AcceptedGiftTypes) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["show_gift_button"] = JSON::Any.new(show_gift_button) if show_gift_button
        params["accepted_gift_types"] = JSON::Any.new(accepted_gift_types) if accepted_gift_types

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/setBusinessAccountGiftSettings"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # getBusinessAccountStarBalance
      # Returns the amount of Telegram Stars owned by a managed business account. Requires the can_view_gifts_and_stars business bot right. Returns StarAmount on success.
      #
      # Returns: StarAmount
      # See: https://core.telegram.org/bots/api#getbusinessaccountstarbalance
      def get_business_account_star_balance(business_connection_id : String) : StarAmount
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/getBusinessAccountStarBalance"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        StarAmount.from_json(json_response["result"].to_json)
      end

      # transferBusinessAccountStars
      # Transfers Telegram Stars from the business account balance to the bot's balance. Requires the can_transfer_stars business bot right. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#transferbusinessaccountstars
      def transfer_business_account_stars(business_connection_id : String, star_count : Int32) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["star_count"] = JSON::Any.new(star_count) if star_count

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/transferBusinessAccountStars"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # getBusinessAccountGifts
      # Returns the gifts received and owned by a managed business account. Requires the can_view_gifts_and_stars business bot right. Returns OwnedGifts on success.
      #
      # Returns: OwnedGifts
      # See: https://core.telegram.org/bots/api#getbusinessaccountgifts
      def get_business_account_gifts(business_connection_id : String, exclude_unsaved : Bool? = nil, exclude_saved : Bool? = nil, exclude_unlimited : Bool? = nil, exclude_limited : Bool? = nil, exclude_unique : Bool? = nil, sort_by_price : Bool? = nil, offset : String? = nil, limit : Int32? = nil) : OwnedGifts
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["exclude_unsaved"] = JSON::Any.new(exclude_unsaved) if exclude_unsaved
        params["exclude_saved"] = JSON::Any.new(exclude_saved) if exclude_saved
        params["exclude_unlimited"] = JSON::Any.new(exclude_unlimited) if exclude_unlimited
        params["exclude_limited"] = JSON::Any.new(exclude_limited) if exclude_limited
        params["exclude_unique"] = JSON::Any.new(exclude_unique) if exclude_unique
        params["sort_by_price"] = JSON::Any.new(sort_by_price) if sort_by_price
        params["offset"] = JSON::Any.new(offset) if offset
        params["limit"] = JSON::Any.new(limit) if limit

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/getBusinessAccountGifts"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        OwnedGifts.from_json(json_response["result"].to_json)
      end

      # convertGiftToStars
      # Converts a given regular gift to Telegram Stars. Requires the can_convert_gifts_to_stars business bot right. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#convertgifttostars
      def convert_gift_to_stars(business_connection_id : String, owned_gift_id : String) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["owned_gift_id"] = JSON::Any.new(owned_gift_id) if owned_gift_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/convertGiftToStars"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # upgradeGift
      # Upgrades a given regular gift to a unique gift. Requires the can_transfer_and_upgrade_gifts business bot right. Additionally requires the can_transfer_stars business bot right if the upgrade is paid. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#upgradegift
      def upgrade_gift(business_connection_id : String, owned_gift_id : String, keep_original_details : Bool? = nil, star_count : Int32? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["owned_gift_id"] = JSON::Any.new(owned_gift_id) if owned_gift_id
        params["keep_original_details"] = JSON::Any.new(keep_original_details) if keep_original_details
        params["star_count"] = JSON::Any.new(star_count) if star_count

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/upgradeGift"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # transferGift
      # Transfers an owned unique gift to another user. Requires the can_transfer_and_upgrade_gifts business bot right. Requires can_transfer_stars business bot right if the transfer is paid. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#transfergift
      def transfer_gift(business_connection_id : String, owned_gift_id : String, new_owner_chat_id : Int32, star_count : Int32? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["owned_gift_id"] = JSON::Any.new(owned_gift_id) if owned_gift_id
        params["new_owner_chat_id"] = JSON::Any.new(new_owner_chat_id) if new_owner_chat_id
        params["star_count"] = JSON::Any.new(star_count) if star_count

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/transferGift"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # postStory
      # Posts a story on behalf of a managed business account. Requires the can_manage_stories business bot right. Returns Story on success.
      #
      # Returns: Story
      # See: https://core.telegram.org/bots/api#poststory
      def post_story(business_connection_id : String, content : InputStoryContent, active_period : Int32, caption : String? = nil, parse_mode : String? = nil, caption_entities : Array(MessageEntity)? = nil, areas : Array(StoryArea)? = nil, post_to_chat_page : Bool? = nil, protect_content : Bool? = nil) : Story
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["content"] = JSON::Any.new(content) if content
        params["active_period"] = JSON::Any.new(active_period) if active_period
        params["caption"] = JSON::Any.new(caption) if caption
        params["parse_mode"] = JSON::Any.new(parse_mode) if parse_mode
        params["caption_entities"] = JSON::Any.new(caption_entities) if caption_entities
        params["areas"] = JSON::Any.new(areas) if areas
        params["post_to_chat_page"] = JSON::Any.new(post_to_chat_page) if post_to_chat_page
        params["protect_content"] = JSON::Any.new(protect_content) if protect_content

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/postStory"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        Story.from_json(json_response["result"].to_json)
      end

      # editStory
      # Edits a story previously posted by the bot on behalf of a managed business account. Requires the can_manage_stories business bot right. Returns Story on success.
      #
      # Returns: Story
      # See: https://core.telegram.org/bots/api#editstory
      def edit_story(business_connection_id : String, story_id : Int32, content : InputStoryContent, caption : String? = nil, parse_mode : String? = nil, caption_entities : Array(MessageEntity)? = nil, areas : Array(StoryArea)? = nil) : Story
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["story_id"] = JSON::Any.new(story_id) if story_id
        params["content"] = JSON::Any.new(content) if content
        params["caption"] = JSON::Any.new(caption) if caption
        params["parse_mode"] = JSON::Any.new(parse_mode) if parse_mode
        params["caption_entities"] = JSON::Any.new(caption_entities) if caption_entities
        params["areas"] = JSON::Any.new(areas) if areas

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/editStory"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        Story.from_json(json_response["result"].to_json)
      end

      # deleteStory
      # Deletes a story previously posted by the bot on behalf of a managed business account. Requires the can_manage_stories business bot right. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#deletestory
      def delete_story(business_connection_id : String, story_id : Int32) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["story_id"] = JSON::Any.new(story_id) if story_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/deleteStory"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # editMessageText
      # Use this method to edit text and game messages. On success, if the edited message is not an inline message, the edited Message is returned, otherwise True is returned. Note that business messages that were not sent by the bot and do not contain an inline keyboard can only be edited within 48 hours from the time they were sent.
      #
      # Returns: JSON::Any
      # See: https://core.telegram.org/bots/api#editmessagetext
      def edit_message_text(text : String, business_connection_id : String? = nil, chat_id : Int32 | String? = nil, message_id : Int32? = nil, inline_message_id : String? = nil, parse_mode : String? = nil, entities : Array(MessageEntity)? = nil, link_preview_options : LinkPreviewOptions? = nil, reply_markup : InlineKeyboardMarkup? = nil) : JSON::Any
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_id"] = JSON::Any.new(message_id) if message_id
        params["inline_message_id"] = JSON::Any.new(inline_message_id) if inline_message_id
        params["text"] = JSON::Any.new(text) if text
        params["parse_mode"] = JSON::Any.new(parse_mode) if parse_mode
        params["entities"] = JSON::Any.new(entities) if entities
        params["link_preview_options"] = JSON::Any.new(link_preview_options) if link_preview_options
        params["reply_markup"] = JSON::Any.new(reply_markup) if reply_markup

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/editMessageText"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"]
      end

      # editMessageCaption
      # Use this method to edit captions of messages. On success, if the edited message is not an inline message, the edited Message is returned, otherwise True is returned. Note that business messages that were not sent by the bot and do not contain an inline keyboard can only be edited within 48 hours from the time they were sent.
      #
      # Returns: JSON::Any
      # See: https://core.telegram.org/bots/api#editmessagecaption
      def edit_message_caption(business_connection_id : String? = nil, chat_id : Int32 | String? = nil, message_id : Int32? = nil, inline_message_id : String? = nil, caption : String? = nil, parse_mode : String? = nil, caption_entities : Array(MessageEntity)? = nil, show_caption_above_media : Bool? = nil, reply_markup : InlineKeyboardMarkup? = nil) : JSON::Any
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_id"] = JSON::Any.new(message_id) if message_id
        params["inline_message_id"] = JSON::Any.new(inline_message_id) if inline_message_id
        params["caption"] = JSON::Any.new(caption) if caption
        params["parse_mode"] = JSON::Any.new(parse_mode) if parse_mode
        params["caption_entities"] = JSON::Any.new(caption_entities) if caption_entities
        params["show_caption_above_media"] = JSON::Any.new(show_caption_above_media) if show_caption_above_media
        params["reply_markup"] = JSON::Any.new(reply_markup) if reply_markup

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/editMessageCaption"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"]
      end

      # editMessageMedia
      # Use this method to edit animation, audio, document, photo, or video messages, or to add media to text messages. If a message is part of a message album, then it can be edited only to an audio for audio albums, only to a document for document albums and to a photo or a video otherwise. When an inline message is edited, a new file can't be uploaded; use a previously uploaded file via its file_id or specify a URL. On success, if the edited message is not an inline message, the edited Message is returned, otherwise True is returned. Note that business messages that were not sent by the bot and do not contain an inline keyboard can only be edited within 48 hours from the time they were sent.
      #
      # Returns: JSON::Any
      # See: https://core.telegram.org/bots/api#editmessagemedia
      def edit_message_media(media : InputMedia, business_connection_id : String? = nil, chat_id : Int32 | String? = nil, message_id : Int32? = nil, inline_message_id : String? = nil, reply_markup : InlineKeyboardMarkup? = nil) : JSON::Any
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_id"] = JSON::Any.new(message_id) if message_id
        params["inline_message_id"] = JSON::Any.new(inline_message_id) if inline_message_id
        params["media"] = JSON::Any.new(media) if media
        params["reply_markup"] = JSON::Any.new(reply_markup) if reply_markup

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/editMessageMedia"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"]
      end

      # editMessageLiveLocation
      # Use this method to edit live location messages. A location can be edited until its live_period expires or editing is explicitly disabled by a call to stopMessageLiveLocation. On success, if the edited message is not an inline message, the edited Message is returned, otherwise True is returned.
      #
      # Returns: JSON::Any
      # See: https://core.telegram.org/bots/api#editmessagelivelocation
      def edit_message_live_location(latitude : Float64, longitude : Float64, business_connection_id : String? = nil, chat_id : Int32 | String? = nil, message_id : Int32? = nil, inline_message_id : String? = nil, live_period : Int32? = nil, horizontal_accuracy : Float64? = nil, heading : Int32? = nil, proximity_alert_radius : Int32? = nil, reply_markup : InlineKeyboardMarkup? = nil) : JSON::Any
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_id"] = JSON::Any.new(message_id) if message_id
        params["inline_message_id"] = JSON::Any.new(inline_message_id) if inline_message_id
        params["latitude"] = JSON::Any.new(latitude) if latitude
        params["longitude"] = JSON::Any.new(longitude) if longitude
        params["live_period"] = JSON::Any.new(live_period) if live_period
        params["horizontal_accuracy"] = JSON::Any.new(horizontal_accuracy) if horizontal_accuracy
        params["heading"] = JSON::Any.new(heading) if heading
        params["proximity_alert_radius"] = JSON::Any.new(proximity_alert_radius) if proximity_alert_radius
        params["reply_markup"] = JSON::Any.new(reply_markup) if reply_markup

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/editMessageLiveLocation"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"]
      end

      # stopMessageLiveLocation
      # Use this method to stop updating a live location message before live_period expires. On success, if the message is not an inline message, the edited Message is returned, otherwise True is returned.
      #
      # Returns: JSON::Any
      # See: https://core.telegram.org/bots/api#stopmessagelivelocation
      def stop_message_live_location(business_connection_id : String? = nil, chat_id : Int32 | String? = nil, message_id : Int32? = nil, inline_message_id : String? = nil, reply_markup : InlineKeyboardMarkup? = nil) : JSON::Any
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_id"] = JSON::Any.new(message_id) if message_id
        params["inline_message_id"] = JSON::Any.new(inline_message_id) if inline_message_id
        params["reply_markup"] = JSON::Any.new(reply_markup) if reply_markup

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/stopMessageLiveLocation"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"]
      end

      # editMessageChecklist
      # Use this method to edit a checklist on behalf of a connected business account. On success, the edited Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#editmessagechecklist
      def edit_message_checklist(business_connection_id : String, chat_id : Int32, message_id : Int32, checklist : InputChecklist, reply_markup : InlineKeyboardMarkup? = nil) : Message
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_id"] = JSON::Any.new(message_id) if message_id
        params["checklist"] = JSON::Any.new(checklist) if checklist
        params["reply_markup"] = JSON::Any.new(reply_markup) if reply_markup

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/editMessageChecklist"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        Message.from_json(json_response["result"].to_json)
      end

      # editMessageReplyMarkup
      # Use this method to edit only the reply markup of messages. On success, if the edited message is not an inline message, the edited Message is returned, otherwise True is returned. Note that business messages that were not sent by the bot and do not contain an inline keyboard can only be edited within 48 hours from the time they were sent.
      #
      # Returns: JSON::Any
      # See: https://core.telegram.org/bots/api#editmessagereplymarkup
      def edit_message_reply_markup(business_connection_id : String? = nil, chat_id : Int32 | String? = nil, message_id : Int32? = nil, inline_message_id : String? = nil, reply_markup : InlineKeyboardMarkup? = nil) : JSON::Any
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_id"] = JSON::Any.new(message_id) if message_id
        params["inline_message_id"] = JSON::Any.new(inline_message_id) if inline_message_id
        params["reply_markup"] = JSON::Any.new(reply_markup) if reply_markup

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/editMessageReplyMarkup"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"]
      end

      # stopPoll
      # Use this method to stop a poll which was sent by the bot. On success, the stopped Poll is returned.
      #
      # Returns: Poll
      # See: https://core.telegram.org/bots/api#stoppoll
      def stop_poll(chat_id : Int32 | String, message_id : Int32, business_connection_id : String? = nil, reply_markup : InlineKeyboardMarkup? = nil) : Poll
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_id"] = JSON::Any.new(message_id) if message_id
        params["reply_markup"] = JSON::Any.new(reply_markup) if reply_markup

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/stopPoll"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        Poll.from_json(json_response["result"].to_json)
      end

      # approveSuggestedPost
      # Use this method to approve a suggested post in a direct messages chat. The bot must have the 'can_post_messages' administrator right in the corresponding channel chat. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#approvesuggestedpost
      def approve_suggested_post(chat_id : Int32, message_id : Int32, send_date : Int32? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_id"] = JSON::Any.new(message_id) if message_id
        params["send_date"] = JSON::Any.new(send_date) if send_date

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/approveSuggestedPost"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # declineSuggestedPost
      # Use this method to decline a suggested post in a direct messages chat. The bot must have the 'can_manage_direct_messages' administrator right in the corresponding channel chat. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#declinesuggestedpost
      def decline_suggested_post(chat_id : Int32, message_id : Int32, comment : String? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_id"] = JSON::Any.new(message_id) if message_id
        params["comment"] = JSON::Any.new(comment) if comment

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/declineSuggestedPost"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
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
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_id"] = JSON::Any.new(message_id) if message_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/deleteMessage"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # deleteMessages
      # Use this method to delete multiple messages simultaneously. If some of the specified messages can't be found, they are skipped. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#deletemessages
      def delete_messages(chat_id : Int32 | String, message_ids : Array(Int32)) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_ids"] = JSON::Any.new(message_ids) if message_ids

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/deleteMessages"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # sendSticker
      # Use this method to send static .WEBP, animated .TGS, or video .WEBM stickers. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendsticker
      def send_sticker(chat_id : Int32 | String, sticker : File | IO | String, business_connection_id : String? = nil, message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, emoji : String? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup | ReplyKeyboardMarkup | ReplyKeyboardRemove | ForceReply? = nil) : Message
        # Build multipart form data for file upload
        boundary = MIME::Multipart.generate_boundary
        form_body = MIME::Multipart.build(boundary) do |builder|
          if business_connection_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"business_connection_id\""}
            builder.body_part(headers, business_connection_id.to_s)
          end
          if chat_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"chat_id\""}
            builder.body_part(headers, chat_id.to_s)
          end
          if message_thread_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"message_thread_id\""}
            builder.body_part(headers, message_thread_id.to_s)
          end
          if direct_messages_topic_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"direct_messages_topic_id\""}
            builder.body_part(headers, direct_messages_topic_id.to_s)
          end
          if sticker
            if sticker.is_a?(File)
              file_io = sticker
              filename = File.basename(sticker.path)
            elsif sticker.is_a?(IO)
              file_io = sticker
              filename = "file"
            else
              file_io = IO::Memory.new(sticker.to_s)
              filename = "file"
            end
            headers = HTTP::Headers{
              "Content-Disposition" => "form-data; name=\"sticker\"; filename=\"#{filename}\"",
              "Content-Type" => "application/octet-stream"
            }
            builder.body_part(headers, file_io)
          end
          if emoji
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"emoji\""}
            builder.body_part(headers, emoji.to_s)
          end
          if disable_notification
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"disable_notification\""}
            builder.body_part(headers, disable_notification.to_s)
          end
          if protect_content
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"protect_content\""}
            builder.body_part(headers, protect_content.to_s)
          end
          if allow_paid_broadcast
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"allow_paid_broadcast\""}
            builder.body_part(headers, allow_paid_broadcast.to_s)
          end
          if message_effect_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"message_effect_id\""}
            builder.body_part(headers, message_effect_id.to_s)
          end
          if suggested_post_parameters
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"suggested_post_parameters\""}
            builder.body_part(headers, suggested_post_parameters.to_s)
          end
          if reply_parameters
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"reply_parameters\""}
            builder.body_part(headers, reply_parameters.to_s)
          end
          if reply_markup
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"reply_markup\""}
            builder.body_part(headers, reply_markup.to_s)
          end
        end

        # Make HTTP request with multipart form
        url = "#{@api_url}/bot#{@token}/sendSticker"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "multipart/form-data; boundary=#{boundary}"},
          body: form_body
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        Message.from_json(json_response["result"].to_json)
      end

      # getStickerSet
      # Use this method to get a sticker set. On success, a StickerSet object is returned.
      #
      # Returns: StickerSet
      # See: https://core.telegram.org/bots/api#getstickerset
      def get_sticker_set(name : String) : StickerSet
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["name"] = JSON::Any.new(name) if name

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/getStickerSet"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        StickerSet.from_json(json_response["result"].to_json)
      end

      # getCustomEmojiStickers
      # Use this method to get information about custom emoji stickers by their identifiers. Returns an Array of Sticker objects.
      #
      # Returns: Array(Sticker)
      # See: https://core.telegram.org/bots/api#getcustomemojistickers
      def get_custom_emoji_stickers(custom_emoji_ids : Array(String)) : Array(Sticker)
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["custom_emoji_ids"] = JSON::Any.new(custom_emoji_ids) if custom_emoji_ids

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/getCustomEmojiStickers"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_a.map { |item| Sticker.from_json(item.to_json) }
      end

      # uploadStickerFile
      # Use this method to upload a file with a sticker for later use in the createNewStickerSet, addStickerToSet, or replaceStickerInSet methods (the file can be used multiple times). Returns the uploaded File on success.
      #
      # Returns: TelegramFile
      # See: https://core.telegram.org/bots/api#uploadstickerfile
      def upload_sticker_file(user_id : Int32, sticker : File | IO, sticker_format : String) : TelegramFile
        # Build multipart form data for file upload
        boundary = MIME::Multipart.generate_boundary
        form_body = MIME::Multipart.build(boundary) do |builder|
          if user_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"user_id\""}
            builder.body_part(headers, user_id.to_s)
          end
          if sticker
            if sticker.is_a?(File)
              file_io = sticker
              filename = File.basename(sticker.path)
            elsif sticker.is_a?(IO)
              file_io = sticker
              filename = "file"
            else
              file_io = IO::Memory.new(sticker.to_s)
              filename = "file"
            end
            headers = HTTP::Headers{
              "Content-Disposition" => "form-data; name=\"sticker\"; filename=\"#{filename}\"",
              "Content-Type" => "application/octet-stream"
            }
            builder.body_part(headers, file_io)
          end
          if sticker_format
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"sticker_format\""}
            builder.body_part(headers, sticker_format.to_s)
          end
        end

        # Make HTTP request with multipart form
        url = "#{@api_url}/bot#{@token}/uploadStickerFile"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "multipart/form-data; boundary=#{boundary}"},
          body: form_body
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        TelegramFile.from_json(json_response["result"].to_json)
      end

      # createNewStickerSet
      # Use this method to create a new sticker set owned by a user. The bot will be able to edit the sticker set thus created. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#createnewstickerset
      def create_new_sticker_set(user_id : Int32, name : String, title : String, stickers : Array(InputSticker), sticker_type : String? = nil, needs_repainting : Bool? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["user_id"] = JSON::Any.new(user_id) if user_id
        params["name"] = JSON::Any.new(name) if name
        params["title"] = JSON::Any.new(title) if title
        params["stickers"] = JSON::Any.new(stickers) if stickers
        params["sticker_type"] = JSON::Any.new(sticker_type) if sticker_type
        params["needs_repainting"] = JSON::Any.new(needs_repainting) if needs_repainting

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/createNewStickerSet"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # addStickerToSet
      # Use this method to add a new sticker to a set created by the bot. Emoji sticker sets can have up to 200 stickers. Other sticker sets can have up to 120 stickers. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#addstickertoset
      def add_sticker_to_set(user_id : Int32, name : String, sticker : InputSticker) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["user_id"] = JSON::Any.new(user_id) if user_id
        params["name"] = JSON::Any.new(name) if name
        params["sticker"] = JSON::Any.new(sticker) if sticker

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/addStickerToSet"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # setStickerPositionInSet
      # Use this method to move a sticker in a set created by the bot to a specific position. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setstickerpositioninset
      def set_sticker_position_in_set(sticker : String, position : Int32) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["sticker"] = JSON::Any.new(sticker) if sticker
        params["position"] = JSON::Any.new(position) if position

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/setStickerPositionInSet"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # deleteStickerFromSet
      # Use this method to delete a sticker from a set created by the bot. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#deletestickerfromset
      def delete_sticker_from_set(sticker : String) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["sticker"] = JSON::Any.new(sticker) if sticker

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/deleteStickerFromSet"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # replaceStickerInSet
      # Use this method to replace an existing sticker in a sticker set with a new one. The method is equivalent to calling deleteStickerFromSet, then addStickerToSet, then setStickerPositionInSet. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#replacestickerinset
      def replace_sticker_in_set(user_id : Int32, name : String, old_sticker : String, sticker : InputSticker) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["user_id"] = JSON::Any.new(user_id) if user_id
        params["name"] = JSON::Any.new(name) if name
        params["old_sticker"] = JSON::Any.new(old_sticker) if old_sticker
        params["sticker"] = JSON::Any.new(sticker) if sticker

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/replaceStickerInSet"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # setStickerEmojiList
      # Use this method to change the list of emoji assigned to a regular or custom emoji sticker. The sticker must belong to a sticker set created by the bot. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setstickeremojilist
      def set_sticker_emoji_list(sticker : String, emoji_list : Array(String)) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["sticker"] = JSON::Any.new(sticker) if sticker
        params["emoji_list"] = JSON::Any.new(emoji_list) if emoji_list

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/setStickerEmojiList"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # setStickerKeywords
      # Use this method to change search keywords assigned to a regular or custom emoji sticker. The sticker must belong to a sticker set created by the bot. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setstickerkeywords
      def set_sticker_keywords(sticker : String, keywords : Array(String)? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["sticker"] = JSON::Any.new(sticker) if sticker
        params["keywords"] = JSON::Any.new(keywords) if keywords

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/setStickerKeywords"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # setStickerMaskPosition
      # Use this method to change the mask position of a mask sticker. The sticker must belong to a sticker set that was created by the bot. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setstickermaskposition
      def set_sticker_mask_position(sticker : String, mask_position : MaskPosition? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["sticker"] = JSON::Any.new(sticker) if sticker
        params["mask_position"] = JSON::Any.new(mask_position) if mask_position

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/setStickerMaskPosition"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # setStickerSetTitle
      # Use this method to set the title of a created sticker set. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setstickersettitle
      def set_sticker_set_title(name : String, title : String) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["name"] = JSON::Any.new(name) if name
        params["title"] = JSON::Any.new(title) if title

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/setStickerSetTitle"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # setStickerSetThumbnail
      # Use this method to set the thumbnail of a regular or mask sticker set. The format of the thumbnail file must match the format of the stickers in the set. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setstickersetthumbnail
      def set_sticker_set_thumbnail(name : String, user_id : Int32, format : String, thumbnail : File | IO | String? = nil) : Bool
        # Build multipart form data for file upload
        boundary = MIME::Multipart.generate_boundary
        form_body = MIME::Multipart.build(boundary) do |builder|
          if name
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"name\""}
            builder.body_part(headers, name.to_s)
          end
          if user_id
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"user_id\""}
            builder.body_part(headers, user_id.to_s)
          end
          if thumbnail
            if thumbnail.is_a?(File)
              file_io = thumbnail
              filename = File.basename(thumbnail.path)
            elsif thumbnail.is_a?(IO)
              file_io = thumbnail
              filename = "file"
            else
              file_io = IO::Memory.new(thumbnail.to_s)
              filename = "file"
            end
            headers = HTTP::Headers{
              "Content-Disposition" => "form-data; name=\"thumbnail\"; filename=\"#{filename}\"",
              "Content-Type" => "application/octet-stream"
            }
            builder.body_part(headers, file_io)
          end
          if format
            headers = HTTP::Headers{"Content-Disposition" => "form-data; name=\"format\""}
            builder.body_part(headers, format.to_s)
          end
        end

        # Make HTTP request with multipart form
        url = "#{@api_url}/bot#{@token}/setStickerSetThumbnail"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "multipart/form-data; boundary=#{boundary}"},
          body: form_body
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # setCustomEmojiStickerSetThumbnail
      # Use this method to set the thumbnail of a custom emoji sticker set. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setcustomemojistickersetthumbnail
      def set_custom_emoji_sticker_set_thumbnail(name : String, custom_emoji_id : String? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["name"] = JSON::Any.new(name) if name
        params["custom_emoji_id"] = JSON::Any.new(custom_emoji_id) if custom_emoji_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/setCustomEmojiStickerSetThumbnail"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # deleteStickerSet
      # Use this method to delete a sticker set that was created by the bot. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#deletestickerset
      def delete_sticker_set(name : String) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["name"] = JSON::Any.new(name) if name

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/deleteStickerSet"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # answerInlineQuery
      # Use this method to send answers to an inline query. On success, True is returned.
      # No more than 50 results per query are allowed.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#answerinlinequery
      def answer_inline_query(inline_query_id : String, results : Array(InlineQueryResult), cache_time : Int32? = nil, is_personal : Bool? = nil, next_offset : String? = nil, button : InlineQueryResultsButton? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["inline_query_id"] = JSON::Any.new(inline_query_id) if inline_query_id
        params["results"] = JSON::Any.new(results) if results
        params["cache_time"] = JSON::Any.new(cache_time) if cache_time
        params["is_personal"] = JSON::Any.new(is_personal) if is_personal
        params["next_offset"] = JSON::Any.new(next_offset) if next_offset
        params["button"] = JSON::Any.new(button) if button

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/answerInlineQuery"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # answerWebAppQuery
      # Use this method to set the result of an interaction with a Web App and send a corresponding message on behalf of the user to the chat from which the query originated. On success, a SentWebAppMessage object is returned.
      #
      # Returns: SentWebAppMessage
      # See: https://core.telegram.org/bots/api#answerwebappquery
      def answer_web_app_query(web_app_query_id : String, result : InlineQueryResult) : SentWebAppMessage
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["web_app_query_id"] = JSON::Any.new(web_app_query_id) if web_app_query_id
        params["result"] = JSON::Any.new(result) if result

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/answerWebAppQuery"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        SentWebAppMessage.from_json(json_response["result"].to_json)
      end

      # savePreparedInlineMessage
      # Stores a message that can be sent by a user of a Mini App. Returns a PreparedInlineMessage object.
      #
      # Returns: PreparedInlineMessage
      # See: https://core.telegram.org/bots/api#savepreparedinlinemessage
      def save_prepared_inline_message(user_id : Int32, result : InlineQueryResult, allow_user_chats : Bool? = nil, allow_bot_chats : Bool? = nil, allow_group_chats : Bool? = nil, allow_channel_chats : Bool? = nil) : PreparedInlineMessage
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["user_id"] = JSON::Any.new(user_id) if user_id
        params["result"] = JSON::Any.new(result) if result
        params["allow_user_chats"] = JSON::Any.new(allow_user_chats) if allow_user_chats
        params["allow_bot_chats"] = JSON::Any.new(allow_bot_chats) if allow_bot_chats
        params["allow_group_chats"] = JSON::Any.new(allow_group_chats) if allow_group_chats
        params["allow_channel_chats"] = JSON::Any.new(allow_channel_chats) if allow_channel_chats

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/savePreparedInlineMessage"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        PreparedInlineMessage.from_json(json_response["result"].to_json)
      end

      # sendInvoice
      # Use this method to send invoices. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendinvoice
      def send_invoice(chat_id : Int32 | String, title : String, description : String, payload : String, currency : String, prices : Array(LabeledPrice), message_thread_id : Int32? = nil, direct_messages_topic_id : Int32? = nil, provider_token : String? = nil, max_tip_amount : Int32? = nil, suggested_tip_amounts : Array(Int32)? = nil, start_parameter : String? = nil, provider_data : String? = nil, photo_url : String? = nil, photo_size : Int32? = nil, photo_width : Int32? = nil, photo_height : Int32? = nil, need_name : Bool? = nil, need_phone_number : Bool? = nil, need_email : Bool? = nil, need_shipping_address : Bool? = nil, send_phone_number_to_provider : Bool? = nil, send_email_to_provider : Bool? = nil, is_flexible : Bool? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, suggested_post_parameters : SuggestedPostParameters? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup? = nil) : Message
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_thread_id"] = JSON::Any.new(message_thread_id) if message_thread_id
        params["direct_messages_topic_id"] = JSON::Any.new(direct_messages_topic_id) if direct_messages_topic_id
        params["title"] = JSON::Any.new(title) if title
        params["description"] = JSON::Any.new(description) if description
        params["payload"] = JSON::Any.new(payload) if payload
        params["provider_token"] = JSON::Any.new(provider_token) if provider_token
        params["currency"] = JSON::Any.new(currency) if currency
        params["prices"] = JSON::Any.new(prices) if prices
        params["max_tip_amount"] = JSON::Any.new(max_tip_amount) if max_tip_amount
        params["suggested_tip_amounts"] = JSON::Any.new(suggested_tip_amounts) if suggested_tip_amounts
        params["start_parameter"] = JSON::Any.new(start_parameter) if start_parameter
        params["provider_data"] = JSON::Any.new(provider_data) if provider_data
        params["photo_url"] = JSON::Any.new(photo_url) if photo_url
        params["photo_size"] = JSON::Any.new(photo_size) if photo_size
        params["photo_width"] = JSON::Any.new(photo_width) if photo_width
        params["photo_height"] = JSON::Any.new(photo_height) if photo_height
        params["need_name"] = JSON::Any.new(need_name) if need_name
        params["need_phone_number"] = JSON::Any.new(need_phone_number) if need_phone_number
        params["need_email"] = JSON::Any.new(need_email) if need_email
        params["need_shipping_address"] = JSON::Any.new(need_shipping_address) if need_shipping_address
        params["send_phone_number_to_provider"] = JSON::Any.new(send_phone_number_to_provider) if send_phone_number_to_provider
        params["send_email_to_provider"] = JSON::Any.new(send_email_to_provider) if send_email_to_provider
        params["is_flexible"] = JSON::Any.new(is_flexible) if is_flexible
        params["disable_notification"] = JSON::Any.new(disable_notification) if disable_notification
        params["protect_content"] = JSON::Any.new(protect_content) if protect_content
        params["allow_paid_broadcast"] = JSON::Any.new(allow_paid_broadcast) if allow_paid_broadcast
        params["message_effect_id"] = JSON::Any.new(message_effect_id) if message_effect_id
        params["suggested_post_parameters"] = JSON::Any.new(suggested_post_parameters) if suggested_post_parameters
        params["reply_parameters"] = JSON::Any.new(reply_parameters) if reply_parameters
        params["reply_markup"] = JSON::Any.new(reply_markup) if reply_markup

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/sendInvoice"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        Message.from_json(json_response["result"].to_json)
      end

      # createInvoiceLink
      # Use this method to create a link for an invoice. Returns the created invoice link as String on success.
      #
      # Returns: String
      # See: https://core.telegram.org/bots/api#createinvoicelink
      def create_invoice_link(title : String, description : String, payload : String, currency : String, prices : Array(LabeledPrice), business_connection_id : String? = nil, provider_token : String? = nil, subscription_period : Int32? = nil, max_tip_amount : Int32? = nil, suggested_tip_amounts : Array(Int32)? = nil, provider_data : String? = nil, photo_url : String? = nil, photo_size : Int32? = nil, photo_width : Int32? = nil, photo_height : Int32? = nil, need_name : Bool? = nil, need_phone_number : Bool? = nil, need_email : Bool? = nil, need_shipping_address : Bool? = nil, send_phone_number_to_provider : Bool? = nil, send_email_to_provider : Bool? = nil, is_flexible : Bool? = nil) : String
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["title"] = JSON::Any.new(title) if title
        params["description"] = JSON::Any.new(description) if description
        params["payload"] = JSON::Any.new(payload) if payload
        params["provider_token"] = JSON::Any.new(provider_token) if provider_token
        params["currency"] = JSON::Any.new(currency) if currency
        params["prices"] = JSON::Any.new(prices) if prices
        params["subscription_period"] = JSON::Any.new(subscription_period) if subscription_period
        params["max_tip_amount"] = JSON::Any.new(max_tip_amount) if max_tip_amount
        params["suggested_tip_amounts"] = JSON::Any.new(suggested_tip_amounts) if suggested_tip_amounts
        params["provider_data"] = JSON::Any.new(provider_data) if provider_data
        params["photo_url"] = JSON::Any.new(photo_url) if photo_url
        params["photo_size"] = JSON::Any.new(photo_size) if photo_size
        params["photo_width"] = JSON::Any.new(photo_width) if photo_width
        params["photo_height"] = JSON::Any.new(photo_height) if photo_height
        params["need_name"] = JSON::Any.new(need_name) if need_name
        params["need_phone_number"] = JSON::Any.new(need_phone_number) if need_phone_number
        params["need_email"] = JSON::Any.new(need_email) if need_email
        params["need_shipping_address"] = JSON::Any.new(need_shipping_address) if need_shipping_address
        params["send_phone_number_to_provider"] = JSON::Any.new(send_phone_number_to_provider) if send_phone_number_to_provider
        params["send_email_to_provider"] = JSON::Any.new(send_email_to_provider) if send_email_to_provider
        params["is_flexible"] = JSON::Any.new(is_flexible) if is_flexible

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/createInvoiceLink"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_s
      end

      # answerShippingQuery
      # If you sent an invoice requesting a shipping address and the parameter is_flexible was specified, the Bot API will send an Update with a shipping_query field to the bot. Use this method to reply to shipping queries. On success, True is returned.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#answershippingquery
      def answer_shipping_query(shipping_query_id : String, ok : Bool, shipping_options : Array(ShippingOption)? = nil, error_message : String? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["shipping_query_id"] = JSON::Any.new(shipping_query_id) if shipping_query_id
        params["ok"] = JSON::Any.new(ok) if ok
        params["shipping_options"] = JSON::Any.new(shipping_options) if shipping_options
        params["error_message"] = JSON::Any.new(error_message) if error_message

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/answerShippingQuery"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # answerPreCheckoutQuery
      # Once the user has confirmed their payment and shipping details, the Bot API sends the final confirmation in the form of an Update with the field pre_checkout_query. Use this method to respond to such pre-checkout queries. On success, True is returned. Note: The Bot API must receive an answer within 10 seconds after the pre-checkout query was sent.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#answerprecheckoutquery
      def answer_pre_checkout_query(pre_checkout_query_id : String, ok : Bool, error_message : String? = nil) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["pre_checkout_query_id"] = JSON::Any.new(pre_checkout_query_id) if pre_checkout_query_id
        params["ok"] = JSON::Any.new(ok) if ok
        params["error_message"] = JSON::Any.new(error_message) if error_message

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/answerPreCheckoutQuery"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # getMyStarBalance
      # A method to get the current Telegram Stars balance of the bot. Requires no parameters. On success, returns a StarAmount object.
      #
      # Returns: StarAmount
      # See: https://core.telegram.org/bots/api#getmystarbalance
      def get_my_star_balance() : StarAmount
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/getMyStarBalance"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        StarAmount.from_json(json_response["result"].to_json)
      end

      # getStarTransactions
      # Returns the bot's Telegram Star transactions in chronological order. On success, returns a StarTransactions object.
      #
      # Returns: StarTransactions
      # See: https://core.telegram.org/bots/api#getstartransactions
      def get_star_transactions(offset : Int32? = nil, limit : Int32? = nil) : StarTransactions
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["offset"] = JSON::Any.new(offset) if offset
        params["limit"] = JSON::Any.new(limit) if limit

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/getStarTransactions"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        StarTransactions.from_json(json_response["result"].to_json)
      end

      # refundStarPayment
      # Refunds a successful payment in Telegram Stars. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#refundstarpayment
      def refund_star_payment(user_id : Int32, telegram_payment_charge_id : String) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["user_id"] = JSON::Any.new(user_id) if user_id
        params["telegram_payment_charge_id"] = JSON::Any.new(telegram_payment_charge_id) if telegram_payment_charge_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/refundStarPayment"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # editUserStarSubscription
      # Allows the bot to cancel or re-enable extension of a subscription paid in Telegram Stars. Returns True on success.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#edituserstarsubscription
      def edit_user_star_subscription(user_id : Int32, telegram_payment_charge_id : String, is_canceled : Bool) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["user_id"] = JSON::Any.new(user_id) if user_id
        params["telegram_payment_charge_id"] = JSON::Any.new(telegram_payment_charge_id) if telegram_payment_charge_id
        params["is_canceled"] = JSON::Any.new(is_canceled) if is_canceled

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/editUserStarSubscription"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # setPassportDataErrors
      # Informs a user that some of the Telegram Passport elements they provided contains errors. The user will not be able to re-submit their Passport to you until the errors are fixed (the contents of the field for which you returned the error must change). Returns True on success.
      # Use this if the data submitted by the user doesn't satisfy the standards your service requires for any reason. For example, if a birthday date seems invalid, a submitted document is blurry, a scan shows evidence of tampering, etc. Supply some details in the error message to make sure the user knows how to correct the issues.
      #
      # Returns: Bool
      # See: https://core.telegram.org/bots/api#setpassportdataerrors
      def set_passport_data_errors(user_id : Int32, errors : Array(PassportElementError)) : Bool
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["user_id"] = JSON::Any.new(user_id) if user_id
        params["errors"] = JSON::Any.new(errors) if errors

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/setPassportDataErrors"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_bool
      end

      # sendGame
      # Use this method to send a game. On success, the sent Message is returned.
      #
      # Returns: Message
      # See: https://core.telegram.org/bots/api#sendgame
      def send_game(chat_id : Int32, game_short_name : String, business_connection_id : String? = nil, message_thread_id : Int32? = nil, disable_notification : Bool? = nil, protect_content : Bool? = nil, allow_paid_broadcast : Bool? = nil, message_effect_id : String? = nil, reply_parameters : ReplyParameters? = nil, reply_markup : InlineKeyboardMarkup? = nil) : Message
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["business_connection_id"] = JSON::Any.new(business_connection_id) if business_connection_id
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_thread_id"] = JSON::Any.new(message_thread_id) if message_thread_id
        params["game_short_name"] = JSON::Any.new(game_short_name) if game_short_name
        params["disable_notification"] = JSON::Any.new(disable_notification) if disable_notification
        params["protect_content"] = JSON::Any.new(protect_content) if protect_content
        params["allow_paid_broadcast"] = JSON::Any.new(allow_paid_broadcast) if allow_paid_broadcast
        params["message_effect_id"] = JSON::Any.new(message_effect_id) if message_effect_id
        params["reply_parameters"] = JSON::Any.new(reply_parameters) if reply_parameters
        params["reply_markup"] = JSON::Any.new(reply_markup) if reply_markup

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/sendGame"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        Message.from_json(json_response["result"].to_json)
      end

      # setGameScore
      # Use this method to set the score of the specified user in a game message. On success, if the message is not an inline message, the Message is returned, otherwise True is returned. Returns an error, if the new score is not greater than the user's current score in the chat and force is False.
      #
      # Returns: JSON::Any
      # See: https://core.telegram.org/bots/api#setgamescore
      def set_game_score(user_id : Int32, score : Int32, force : Bool? = nil, disable_edit_message : Bool? = nil, chat_id : Int32? = nil, message_id : Int32? = nil, inline_message_id : String? = nil) : JSON::Any
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["user_id"] = JSON::Any.new(user_id) if user_id
        params["score"] = JSON::Any.new(score) if score
        params["force"] = JSON::Any.new(force) if force
        params["disable_edit_message"] = JSON::Any.new(disable_edit_message) if disable_edit_message
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_id"] = JSON::Any.new(message_id) if message_id
        params["inline_message_id"] = JSON::Any.new(inline_message_id) if inline_message_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/setGameScore"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"]
      end

      # getGameHighScores
      # Use this method to get data for high score tables. Will return the score of the specified user and several of their neighbors in a game. Returns an Array of GameHighScore objects.
      #
      # Returns: Array(GameHighScore)
      # See: https://core.telegram.org/bots/api#getgamehighscores
      def get_game_high_scores(user_id : Int32, chat_id : Int32? = nil, message_id : Int32? = nil, inline_message_id : String? = nil) : Array(GameHighScore)
        # Build JSON request parameters
        params = Hash(String, JSON::Any).new
        params["user_id"] = JSON::Any.new(user_id) if user_id
        params["chat_id"] = JSON::Any.new(chat_id) if chat_id
        params["message_id"] = JSON::Any.new(message_id) if message_id
        params["inline_message_id"] = JSON::Any.new(inline_message_id) if inline_message_id

        # Make HTTP request
        url = "#{@api_url}/bot#{@token}/getGameHighScores"
        response = HTTP::Client.post(url,
          headers: HTTP::Headers{"Content-Type" => "application/json"},
          body: params.to_json
        )

        # Handle response
        unless response.success?
          raise "Telegram API error: #{response.status_code} - #{response.body}"
        end

        # Parse response
        json_response = JSON.parse(response.body)

        unless json_response["ok"]?.try(&.as_bool)
          error_desc = json_response["description"]?.try(&.as_s) || "Unknown error"
          raise "Telegram API error: #{error_desc}"
        end

        json_response["result"].as_a.map { |item| GameHighScore.from_json(item.to_json) }
      end

    end
  end
end
