class Telegram::API
  class Message
    def file
      if animation
        {:animation, animation}
      elsif audio
        {:audio, audio}
      elsif document
        {:document, document}
      elsif sticker
        {:sticker, sticker}
      elsif video
        {:video, video}
      elsif video_note
        {:video_note, video_note}
      elsif photo.first?
        {:photo, photo.first}
      else
        {nil, nil}
      end
    end

    def link
      if chat.username
        "https://t.me/#{chat.username}/#{message_id}"
      else
        "https://t.me/c/#{chat.id}/#{message_id}"
      end
    end

    def text_entities
      text = self.caption || self.text
      [entities, caption_entities].flatten.reduce({} of MessageEntity => String) do |acc, ent|
        acc[ent] = text.to_s[ent.offset, ent.length]
        acc
      end
    end

    def raw_text(parse_mode : ParseMode = :markdown)
      if txt = text
        Helpers.unparse_text(txt, entities, parse_mode)
      end
    end

    def raw_caption(parse_mode : ParseMode = :markdown)
      if txt = caption
        Helpers.unparse_text(txt, entities, parse_mode)
      end
    end

    def users
      users = [] of User?
      users << self.from
      users << self.forward_from
      users << self.left_chat_member
      users.concat(self.new_chat_members)
      users.compact.uniq
    end

    def users(&block : User ->)
      self.users.each { |u| block.call(u) }
    end

    def chats
      chats = [] of Chat?
      chats << self.chat
      chats << self.sender_chat
      chats << self.forward_from_chat
      if reply_message = self.reply_message
        chats.concat(reply_message.chats)
      end
      chats.compact.uniq
    end

    def chats(&block : Chat ->)
      self.chats.each { |c| block.call(c) }
    end

    # Delete the message. See `Telegram::API#delete_message`.
    def delete
      client.api.delete_message(chat.id, message_id)
    end

    # Edits the message's media. See `Telegram::API#edit_message_media`
    def edit_media(media, **kwargs)
      client.api.edit_message_media(chat.id, media, **kwargs, message_id: message_id)
    end

    # Edits the message's caption. See `Telegram::API#edit_message_caption`
    def edit_caption(caption, **kwargs)
      client.api.edit_message_caption(chat.id, caption, **kwargs, message_id: message_id)
    end

    # Set the reply markup for the message. See `Telegram::API#edit_message_reply_markup`.
    def edit_reply_markup(reply_markup)
      client.api.edit_message_reply_markup(chat.id, message_id: message_id, reply_markup: reply_markup)
    end

    # Edits the text of a message. See `Telegram::API#edit_message_text`.
    def edit_text(text, **kwargs)
      client.api.edit_message_text(text, chat.id, **kwargs, message_id: message_id)
    end

    # Edits the message's live_location. See `Telegram::API#edit_message_live_location`
    def edit_live_location(lat, long, **kwargs)
      client.api.edit_message_live_location(chat.id, lat, long, **kwargs, message_id: message_id)
    end

    # Forward the message to another chat. See `Telegram::API#forward_message`.
    def forward(to_chat, **kwargs)
      client.api.forward_message(to_chat, chat, message_id, **kwargs)
    end

    # Pin the message. See `Telegram::API#pin_chat_message`.
    def pin(**kwargs)
      client.api.pin_chat_message(chat.id, message_id, **kwargs)
    end

    # Unpin the message. See `Telegram::API#unpin_chat_message`.
    def unpin(**kwargs)
      client.api.unpin_chat_message(chat.id, message_id, **kwargs)
    end

    # Reply to a message. See `Telegram::API#send_message`.
    def reply(message, **kwargs)
      client.api.send_message(chat.id, message, **kwargs, reply_to_message_id: message_id)
    end

    # Respond to a message. See `Telegram::API#send_message`.
    def respond(message, **kwargs)
      client.api.send_message(chat.id, message, **kwargs)
    end

    {% for content_type in %w[audio animation contact document location sticker photo media_group venu video video_note voice invoice poll dice dart basketball] %}
      def reply_with_{{content_type.id}}(*args, **kwargs)
        client.api.send_{{content_type.id}}(chat.id, *args, **kwargs, reply_to_message_id: message_id)
      end

      def respond_with_{{content_type.id}}(*args, **kwargs)
        client.api.send_{{content_type.id}}(chat.id, *args, **kwargs)
      end
    {% end %}

    def edit_live_location(latitude, longitude, **kwargs)
      client.api.edit_message_live_location(chat.id, latitude, longitude, **kwargs, message_id: message_id)
    end

    def stop_live_location(**kwargs)
      client.api.stop_message_live_location(chat.id, message_id, **kwargs)
    end

    def sender_type
      if is_automatic_forward
        SenderType::ChannelForward
      elsif sc = sender_chat
        if sc.id == chat.id
          SenderType::AnonymousAdmin
        else
          SenderType::Channel
        end
      elsif from.try(&.is_bot)
        SenderType::Bot
      else
        SenderType::User
      end
    end
  end
end
