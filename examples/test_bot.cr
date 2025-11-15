#!/usr/bin/env crystal
require "base64"
require "../src/telegram/generated/telegram"

module TelegramExamples
  # Simple bot that demonstrates most core client capabilities:
  # - Long-polling updates
  # - Routing messages, photos, and callback queries
  # - Sending markdown-formatted text
  # - Uploading files via InputFile runtime detection
  # - Answering callback queries from inline keyboards
  class TestBot
    @client : Telegram::Client::APIClient
    @last_update_id : Int32
    SAMPLE_PHOTO_PATH = File.expand_path("./assets/sample_photo.png", __DIR__)

    def initialize(
      token : String = ENV["TELEGRAM_TEST_TOKEN"],
      @default_chat_id : Int64 = ENV["TELEGRAM_TEST_CHAT_ID"].to_i64
    )
      @client = Telegram::APIClient.new(token)
      @last_update_id = 0
      setup_http_logging
    end

    def run
      puts "Test bot started. Press Ctrl+C to exit."
      loop do
        process_updates
      rescue ex
        STDERR.puts "Polling error: #{ex.class}: #{ex.message}"
        sleep 2.seconds
      end
    end

    private def process_updates
      updates = @client.get_updates(offset: @last_update_id, timeout: 20)
      updates.each do |update|
        @last_update_id = (update.update_id + 1).to_i32!
        handle_update(update)
      end
    end

    private def handle_update(update : Telegram::Update)
      if message = update.message
        handle_message(message)
      elsif callback = update.callback_query
        handle_callback(callback)
      elsif inline = update.inline_query
        puts "Received inline query from #{inline.from.first_name}: #{inline.query}"
      end
    end

    private def handle_message(message : Telegram::Message)
      if text = message.text
        handle_text_message(message, text)
      elsif photos = message.photo
        acknowledge_photo(message, photos)
      elsif document = message.document
        respond(message.chat.id, "Nice document: #{document.file_name}")
      end
    end

    private def handle_text_message(message : Telegram::Message, text : String)
      case text.split.first
      when "/start"
        send_welcome(message.chat.id)
      when "/photo"
        send_sample_photo(message.chat.id)
      when "/markdown"
        send_markdown_demo(message.chat.id)
      else
        respond(message.chat.id, "Echo: #{text}")
      end
    end

    private def handle_callback(callback : Telegram::CallbackQuery)
      data = callback.data || "no payload"
      @client.answer_callback_query(
        callback_query_id: callback.id,
        text: "Callback received: #{data}",
        show_alert: false
      )

      respond(nil, "Callback payload: #{data}")
    end

    private def send_welcome(chat_id)
      keyboard = Telegram::InlineKeyboardMarkup.new(
        inline_keyboard: [
          [
            Telegram::InlineKeyboardButton.new(
              text: "Telegram Docs",
              url: "https://core.telegram.org/bots"
            )
          ],
          [
            Telegram::InlineKeyboardButton.new(
              text: "Trigger Callback",
              callback_data: "PING"
            )
          ]
        ]
      )

      respond(
        chat_id,
        "Welcome! Send /photo, /markdown or attach a photo to test uploads.",
        reply_markup: keyboard
      )
    end

    private def send_sample_photo(chat_id)
      input = Telegram::InputFile.from_path(SAMPLE_PHOTO_PATH, File.basename(SAMPLE_PHOTO_PATH), "image/png")
      @client.send_photo(
        chat_id: normalize_chat_id(chat_id),
        photo: input,
        caption: "*Sample* _photo_ sent via InputFile",
        parse_mode: "Markdown"
      )
    end

    private def send_markdown_demo(chat_id)
      text = <<-MSG
        *Markdown demo*
        _Italics_ and __bold__ supported.
        `Inline code`
      MSG

      @client.send_message(
        chat_id: normalize_chat_id(chat_id),
        text: text,
        parse_mode: "Markdown"
      )
    end

    private def acknowledge_photo(message : Telegram::Message, photos : Array(Telegram::PhotoSize))
      largest = photos.max_by { |a| a.try &.file_size || 0 }
      respond(
        message.chat.id,
        "Got your photo (file_id: #{largest.file_id}), thanks!"
      )
    end

    private def respond(chat_id : Int32 | Int64 | String | Nil, text : String, reply_markup : Telegram::InlineKeyboardMarkup? = nil)
      target = chat_id || @default_chat_id
      normalized = normalize_chat_id(target)
      @client.send_message(
        chat_id: normalized,
        text: text,
        reply_markup: reply_markup
      )
    end

    private def setup_http_logging
      @client.configure_http do |config|
        config.log_requests = true
        config.log_responses = true
      end
    end

    private def normalize_chat_id(value : Int32 | Int64 | String) : Int32 | String
      case value
      when Int32
        value
      when String
        value
      else
        value.to_s
      end
    end

    private def normalize_chat_id(value : Nil) : Int32 | String
      normalize_chat_id(@default_chat_id)
    end
  end
end

TelegramExamples::TestBot.new.run
