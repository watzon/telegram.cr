class Telegram::API
  class MessageEntity
    MENTION_TYPES = %w[
      mention text_mention hashtag cashtag bot_command url email phone_number
      bold italic code pre text_link underline strikethrough spoiler
    ]

    {% for mention_type in MENTION_TYPES %}
      def {{mention_type.id}}?
        @type == {{mention_type}}
      end
    {% end %}
  end
end
