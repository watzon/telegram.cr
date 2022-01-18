require "./api"

module Telegram

  module MutableContext
    private abstract struct Param
      abstract def value
    end

    private record Parameter(T) < Param, value : T
    private record LazyParameter(T) < Param, value : Proc(T)

    protected getter parameters : Hash(String, Param) = Hash(String, Param).new

    # Returns `true` if a parameter with the provided *name* exists, otherwise `false`.
    def has?(name) : Bool
      @parameters.has_key?(name.to_s)
    end

    # Returns the value of the parameter with the provided *name* if it exists, otherwise `nil`.
    def get?(name)
      if param = @parameters[name.to_s]?
        result = param.is_a?(LazyParameter) ? param.value.call : param.value
      end
    end

    # Returns the value of the parameter with the provided *name* as a `type` if it exists, otherwise `nil`.
    def get?(name, type : T.class) forall T
      if result = get?(name)
        result.as(T)
      end
    end

    # Returns the value of the parameter with the provided *name*.
    #
    # Raises a `KeyError` if no parameter with that name exists.
    def get(name)
      param = @parameters.fetch(name.to_s) { raise KeyError.new "No parameter exists with the name '#{name.to_s}'." }
      param.is_a?(LazyParameter) ? param.value.call : param.value
    end

    # Returns the value of the parameter with the provided *name* as a `type`.
    def get(name, type : T.class) forall T
      get(name).as(T)
    end

    # Sets a parameter with the provided *name* to *value*.
    def set(name, value : T) : Nil forall T
      self.set(name.to_s, value, T)
    end

    # Sets a lazy parameter with the provided *name* to the return value of the provided *block*.
    def set(name, &block : -> T) : Nil forall T
      self.set(name.to_s, T, &block)
    end

    # Sets a parameter with the provided *name* to *value*, restricted to the given *type*.
    def set(name, value : _, type : T.class) : Nil forall T
      @parameters[name.to_s] = Parameter(T).new value
    end

    # Sets a lazy parameter with the provided *name* to the return value of the provided *block*,
    # restricted to the given *type*.
    def set(name, type : T.class, &block : -> T) : Nil forall T
      @parameters[name.to_s] = LazyParameter(T).new block
    end

    # Removes the parameter with the provided *name*.
    def remove(name) : Nil
      @parameters.delete(name.to_s)
    end
  end
  class Context
    include MutableContext

    private ALIAS_METHODS = [
      :message, :edited_message, :channel_post, :edited_channel_post, :inline_query, :chosen_inline_result,
      :callback_query, :shipping_query, :pre_checkout_query, :poll, :poll_answer, :my_chat_member, :chat_member, :chat_join_request,
    ]

    # The `Updtate` object that is contained in the context.
    getter update : API::Update

    # An `API` instance which allows you to call any
    # Telegram Bot API method.
    getter api : API

    # Information about the bot itself.
    getter me : API::User

    # Used by some middleware to stor information about how a String or
    # regular expression was matched.
    property match : String | Regex | Nil

    def initialize(@update : API::Update, @api : API, @me : API::User)
    end

    def stop
      raise StopMiddlewareExecution.new
    end

    # UPDATE SHORTCUTS

    {% for method in ALIAS_METHODS %}
    # Alias for `ctx.update.{{ method.id }}`
    def {{ method.id }}
      self.update.{{ method.id }}
    end

    # Alias for `ctx.update.{{ method.id }}.not_nil!`
    def {{ method.id }}!
      self.update.{{ method.id }}.not_nil!
    end
    {% end %}

    # AGGREGATION SHORTCUTS

    # Get the message object from wherever possible
    def msg
      self.message ||
        self.edited_message ||
        self.callback_query.try(&.message) ||
        self.channel_post ||
        self.edited_channel_post
    end

    # Get the message object from wherever possible.
    # Will raise if no message object is found.
    def msg!
      self.msg.not_nil!
    end

    # Get the chat object from wherever possible.
    def chat
      self.msg.try(&.chat) ||
      self.my_chat_member.try(&.chat) ||
      self.chat_member.try(&.chat) ||
      self.chat_join_request.try(&.chat)
    end

    # Get the chat object from wherever possible.
    # Will raise if the chat object is not found.
    def chat!
      self.chat.not_nil!
    end

    # Get the sender chat from wherever possible.
    def sender_chat
      self.msg.try(&.sender_chat)
    end

    # Get the sender chat from wherever possible.
    # Will raise if the sender_chat object is not found.
    def sender_chat!
      self.sender_chat.not_nil!
    end

    # Get the message author from wherever possible.
    def from
      self.callback_query.try(&.from) ||
      self.shipping_query.try(&.from) ||
      self.pre_checkout_query.try(&.from) ||
      self.chosen_inline_result.try(&.from) ||
      self.msg.try(&.from) ||
      self.my_chat_member.try(&.from) ||
      self.chat_member.try(&.from) ||
      self.chat_join_request.try(&.from)
    end

    # Get the message author from wherever possible.
    # Will raise if the from object is not found.
    def from!
      self.from.not_nil!
    end

    # Get the inline message ID from wherever possible.
    def inline_message_id
      self.callback_query.try(&.inline_message_id) ||
        self.chosen_inline_result.try(&.inline_message_id)
    end

    # Get the inline message ID from wherever possible.
    # Will raise if the inline_message_id object is not found.
    def inline_message_id!
      self.inline_message_id.not_nil!
    end

    # Get the message text from wherever possible.
    def text
      self.msg.text ||
        self.msg.caption
    end

    # Get the message text from wherever possible.
    # Will raise if the text object is not found.
    def text!
      self.text.not_nil!
    end

    # API SHORTCUTS

    # Context-aware alias for `api.send_message`.
    def reply(text : String, **options)
      self.api.send_message(
        Helpers.or_throw(self.chat, "send_message").id,
        text,
        **options
      )
    end

    # Context-aware alias for `api.forward_message`.
    def forward_message(chat_id : Int64 | String, **options)
      self.api.forward_message(
        chat_id,
        Helpers.or_throw(self.chat, "forward_message").id,
        Helpers.or_throw(self.msg, "forward_message").id,
        **options
      )
    end

    # Context-aware alias for `api.copy_message`.
    def copy_message(chat_id : Int64 | String, **options)
      self.api.copy_message(
        chat_id,
        Helpers.or_throw(self.chat, "copy_message").id,
        Helpers.or_throw(self.msg, "copy_message").id,
        **options
      )
    end

    # Context-aware alias for `api.send_photo`.
    def send_photo(photo : InputFile | String, **options)
      self.api.send_photo(
        Helpers.or_throw(self.chat, "send_photo").id,
        photo,
        **options
      )
    end

    # Context-aware alias for `api.send_audio`.
    def send_audio(audio : InputFile | String, **options)
      self.api.send_audio(
        Helpers.or_throw(self.chat, "send_audio").id,
        audio,
        **options
      )
    end

    # Context-aware alias for `api.send_document`.
    def send_document(document : InputFile | String, **options)
      self.api.send_document(
        Helpers.or_throw(self.chat, "send_document").id,
        document,
        **options
      )
    end

    # Context-aware alias for `api.send_video`.
    def send_video(video : InputFile | String, **options)
      self.api.send_video(
        Helpers.or_throw(self.chat, "send_video").id,
        video,
        **options
      )
    end

    # Context-aware alias for `api.send_animation`.
    def send_animation(animation : InputFile | String, **options)
      self.api.send_animation(
        Helpers.or_throw(self.chat, "send_animation").id,
        animation,
        **options
      )
    end

    # Context-aware alias for `api.send_voice`.
    def send_voice(voice : InputFile | String, **options)
      self.api.send_voice(
        Helpers.or_throw(self.chat, "send_voice").id,
        voice,
        **options
      )
    end

    # Context-aware alias for `api.send_video_note`.
    def send_video_note(video_note : InputFile | String, **options)
      self.api.send_video_note(
        Helpers.or_throw(self.chat, "send_video_note").id,
        video_note,
        **options
      )
    end

    # Context-aware alias for `api.send_media_group`.
    def send_media_group(media : Array(InputMedia), **options)
      self.api.send_media_group(
        Helpers.or_throw(self.chat, "send_media_group").id,
        media,
        **options
      )
    end

    # Context-aware alias for `api.send_location`.
    def send_location(latitude : Float, longitude : Float, **options)
      self.api.send_location(
        Helpers.or_throw(self.chat, "send_location").id,
        latitude,
        longitude,
        **options
      )
    end

    # Context-aware alias for `api.edit_message_live_location`.
    def edit_message_live_location(latitude : Float, longitude : Float, **options)
      self.api.edit_message_live_location(
        Helpers.or_throw(self.chat, "edit_message_live_location").id,
        Helpers.or_throw(self.msg, "edit_message_live_location").id,
        latitude,
        longitude,
        **options
      )
    end

    # Context-aware alias for `api.stop_message_live_location`.
    def stop_message_live_location(**options)
      self.api.stop_message_live_location(
        Helpers.or_throw(self.chat, "stop_message_live_location").id,
        Helpers.or_throw(self.msg, "stop_message_live_location").id,
        **options
      )
    end

    # Context-aware alias for `api.send_venue`.
    def send_venue(latitude : Float, longitude : Float, title : String, address : String, **options)
      self.api.send_venue(
        Helpers.or_throw(self.chat, "send_venue").id,
        latitude,
        longitude,
        title,
        address,
        **options
      )
    end

    # Context-aware alias for `api.send_contact`.
    def send_contact(phone_number : String, first_name : String, **options)
      self.api.send_contact(
        Helpers.or_throw(self.chat, "send_contact").id,
        phone_number,
        first_name,
        **options
      )
    end

    # Context-aware alias for `api.send_poll`.
    def send_poll(question : String, items : Array(String), **options)
      self.api.send_poll(
        Helpers.or_throw(self.chat, "send_poll").id,
        question,
        items,
        **options
      )
    end

    # Context-aware alias for `api.send_dice`.
    # TODO: Use `Dice` enum.
    def send_dice(emoji : String, **options)
      self.api.send_dice(
        Helpers.or_throw(self.chat, "send_dice").id,
        emoji,
        **options
      )
    end

    # Context-aware alias for `api.send_chat_action`.
    # TODO: Use `ChatAction` enum.
    def send_chat_action(action : String, **options)
      self.api.send_chat_action(
        Helpers.or_throw(self.chat, "send_chat_action").id,
        action,
        **options
      )
    end

    # Context-aware alias for `api.get_user_profile_photos`.
    def get_user_profile_photos(**options)
      self.api.get_user_profile_photos(
        Helpers.or_throw(self.chat, "get_user_profile_photos").id,
        **options
      )
    end

    # Context-aware alias for `api.get_file`.
    def get_file(file_id : String? = nil)
      if !file_id
        m = Helpers.or_throw(self.msg, "get_file")
        file = !m.photo.empty? ?
          m.photo.last :
          m.animation ||
            m.audio ||
            m.document ||
            m.video ||
            m.video_note ||
            m.voice ||
            m.sticker
        file_id = Helpers.or_throw(file, "get_file").file_id
      end

      self.api.get_file(file_id)
    end

    # Context-aware alias for `api.ban_chat_member`.
    def ban_author(**options)
      self.api.ban_chat_member(
        Helpers.or_throw(self.chat, "ban_author").id,
        Helpers.or_throw(self.from, "ban_author").id,
        **options
      )
    end

    # Context-aware alias for `api.ban_chat_member`.
    def ban_chat_member(user_id : Int64, **options)
      self.api.ban_chat_member(
        Helpers.or_throw(self.chat, "ban_chat_member").id,
        user_id,
        **options
      )
    end

    # Context-aware alias for `api.unban_chat_member`.
    def unban_chat_member(user_id : Int64, **options)
      self.api.unban_chat_member(
        Helpers.or_throw(self.chat, "unban_chat_member").id,
        user_id,
        **options
      )
    end

    # Context-aware alias for `api.restrict_chat_member`.
    def restrict_author(**options)
      self.api.restrict_chat_member(
        Helpers.or_throw(self.chat, "restrict_author").id,
        Helpers.or_throw(self.from, "restrict_author").id,
        **options
      )
    end

    # Context-aware alias for `api.restrict_chat_member`.
    def restrict_chat_member(user_id : Int64, **options)
      self.api.restrict_chat_member(
        Helpers.or_throw(self.chat, "restrict_chat_member").id,
        user_id,
        **options
      )
    end

    # Context-aware alias for `api.promote_chat_member`.
    def promote_author(**options)
      self.api.promote_chat_member(
        Helpers.or_throw(self.chat, "promote_author").id,
        Helpers.or_throw(self.from, "promote_author").id,
        **options
      )
    end

    # Context-aware alias for `api.promote_chat_member`.
    def promote_chat_member(user_id : Int64, **options)
      self.api.promote_chat_member(
        Helpers.or_throw(self.chat, "promote_chat_member").id,
        user_id,
        **options
      )
    end

    # Context-aware alias for `api.set_chat_administrator_custom_title`.
    def set_chat_administrator_author_custom_title(custom_title : String, **options)
      self.api.set_chat_administrator_custom_title(
        Helpers.or_throw(self.chat, "set_chat_administrator_author_custom_title").id,
        Helpers.or_throw(self.from, "set_chat_administrator_author_custom_title").id,
        custom_title,
        **options
      )
    end

    # Context-aware alias for `api.set_chat_administrator_custom_title`.
    def set_chat_administrator_custom_title(user_id : Int64, custom_title : String, **options)
      self.api.set_chat_administrator_custom_title(
        Helpers.or_throw(self.chat, "set_chat_administrator_custom_title").id,
        user_id,
        custom_title,
        **options
      )
    end

    # Context-aware alias for `api.ban_chat_sender_chat`.
    def ban_chat_sender_chat(sender_chat_id : Int64, **options)
      self.api.ban_chat_sender_chat(
        Helpers.or_throw(self.chat, "ban_chat_sender_chat").id,
        sender_chat_id,
        **options
      )
    end

    # Context-aware alias for `api.unban_chat_sender_chat`.
    def unban_chat_sender_chat(sender_chat_id : Int64, **options)
      self.api.unban_chat_sender_chat(
        Helpers.or_throw(self.chat, "unban_chat_sender_chat").id,
        sender_chat_id,
        **options
      )
    end

    # Context-aware alias for `api.set_chat_permissions`.
    def set_chat_permissions(permissions : ChatPermissions, **options)
      self.api.set_chat_permissions(
        Helpers.or_throw(self.chat, "set_chat_permissions").id,
        permissions,
        **options
      )
    end

    # Context-aware alias for `api.export_chat_invite_link`.
    def export_chat_invite_link(**options)
      self.api.export_chat_invite_link(
        Helpers.or_throw(self.chat, "export_chat_invite_link").id,
        **options
      )
    end

    # Context-aware alias for `api.create_chat_invite_link`.
    def create_chat_invite_link(**options)
      self.api.create_chat_invite_link(
        Helpers.or_throw(self.chat, "create_chat_invite_link").id,
        **options
      )
    end

    # Context-aware alias for `api.edit_chat_invite_link`.
    def edit_chat_invite_link(invite_link : String, **options)
      self.api.edit_chat_invite_link(
        Helpers.or_throw(self.chat, "edit_chat_invite_link").id,
        invite_link,
        **options
      )
    end

    # Context-aware alias for `api.revoke_chat_invite_link`.
    def revoke_chat_invite_link(link : String, **options)
      self.api.revoke_chat_invite_link(
        Helpers.or_throw(self.chat, "revoke_chat_invite_link").id,
        link,
        **options
      )
    end

    # Context-aware alias for `api.approve_chat_join_request`.
    def approve_chat_join_request(user_id : Int64, **options)
      self.api.approve_chat_join_request(
        Helpers.or_throw(self.chat, "approve_chat_join_request").id,
        user_id,
        **options
      )
    end

    # Context-aware alias for `api.decline_chat_join_request`.
    def decline_chat_join_request(user_id : Int64, **options)
      self.api.decline_chat_join_request(
        Helpers.or_throw(self.chat, "decline_chat_join_request").id,
        user_id,
        **options
      )
    end

    # Context-aware alias for `api.set_chat_photo`.
    def set_chat_photo(photo : InputFile, **options)
      self.api.set_chat_photo(
        Helpers.or_throw(self.chat, "set_chat_photo").id,
        photo,
        **options
      )
    end

    # Context-aware alias for `api.delete_chat_photo`.
    def delete_chat_photo(**options)
      self.api.delete_chat_photo(
        Helpers.or_throw(self.chat, "delete_chat_photo").id,
        **options
      )
    end

    # Context-aware alias for `api.set_chat_title`.
    def set_chat_title(title : String, **options)
      self.api.set_chat_title(
        Helpers.or_throw(self.chat, "set_chat_title").id,
        title,
        **options
      )
    end

    # Context-aware alias for `api.set_chat_description`.
    def set_chat_description(description : String?, **options)
      self.api.set_chat_description(
        Helpers.or_throw(self.chat, "set_chat_description").id,
        description,
        **options
      )
    end

    # Context-aware alias for `api.pin_chat_message`.
    def pin_chat_message(message_id : Int64, **options)
      self.api.pin_chat_message(
        Helpers.or_throw(self.chat, "pin_chat_message").id,
        message_id,
        **options
      )
    end

    # Context-aware alias for `api.unpin_chat_message`.
    def unpin_chat_message(message_id : Int64, **options)
      self.api.unpin_chat_message(
        Helpers.or_throw(self.chat, "unpin_chat_message").id,
        message_id,
        **options
      )
    end

    # Context-aware alias for `api.unpin_all_chat_messages`.
    def unpin_all_chat_messages(**options)
      self.api.unpin_all_chat_messages(
        Helpers.or_throw(self.chat, "unpin_all_chat_messages").id,
        **options
      )
    end

    # Context-aware alias for `api.leave_chat`.
    def leave_chat(**options)
      self.api.leave_chat(
        Helpers.or_throw(self.chat, "leave_chat").id,
        **options
      )
    end

    # Context-aware alias for `api.get_chat`.
    def get_chat(**options)
      self.api.get_chat(
        Helpers.or_throw(self.chat, "get_chat").id,
        **options
      )
    end

    # Context-aware alias for `api.get_chat_administrators`.
    def get_chat_administrators(**options)
      self.api.get_chat_administrators(
        Helpers.or_throw(self.chat, "get_chat_administrators").id,
        **options
      )
    end

    # Context-aware alias for `api.get_chat_members_count`.
    def get_chat_members_count(**options)
      self.api.get_chat_members_count(
        Helpers.or_throw(self.chat, "get_chat_members_count").id,
        **options
      )
    end

    # Context-aware alias for `api.get_chat_member`.
    def get_author(**options)
      self.api.get_chat_member(
        Helpers.or_throw(self.chat, "get_author").id,
        Helpers.or_throw(self.from, "get_author").id,
        **options
      )
    end

    # Context-aware alias for `api.get_chat_member`.
    def get_chat_member(user_id : Int64, **options)
      self.api.get_chat_member(
        Helpers.or_throw(self.chat, "get_chat_member").id,
        user_id,
        **options
      )
    end

    # Context-aware alias for `api.set_chat_sticker_set`.
    def set_chat_sticker_set(sticker_set_name : String, **options)
      self.api.set_chat_sticker_set(
        Helpers.or_throw(self.chat, "set_chat_sticker_set").id,
        sticker_set_name,
        **options
      )
    end

    # Context-aware alias for `api.delete_chat_sticker_set`.
    def delete_chat_sticker_set(**options)
      self.api.delete_chat_sticker_set(
        Helpers.or_throw(self.chat, "delete_chat_sticker_set").id,
        **options
      )
    end

    # Context-aware alias for `api.answer_callback_query`.
    def answer_callback_query(**options)
      self.api.answer_callback_query(
        Helpers.or_throw(self.callback_query, "answer_callback_query").id,
        **options
      )
    end

    # Context-aware alias for `api.edit_message_text`.
    def edit_message_text(text : String, **options)
      if inline_id = self.inline_message_id
        options = options.merge(inline_message_id: inline_id)
      else
        options = options.merge(message_id: Helpers.or_throw(self.msg, "edit_message_text").id)
      end

      self.api.edit_message_text(
        **options,
        text: text,
        chat_id: Helpers.or_throw(self.chat, "edit_message_text").id
      )
    end

    # Context-aware alias for `api.edit_message_caption`.
    def edit_message_caption(caption : String?, **options)
      if inline_id = self.inline_message_id
        options = options.merge(inline_message_id: inline_id)
      else
        options = options.merge(message_id: Helpers.or_throw(self.msg, "edit_message_caption").id)
      end

      self.api.edit_message_caption(
        **options,
        caption: caption,
        chat_id: Helpers.or_throw(self.chat, "edit_message_caption").id
      )
    end

    # Context-aware alias for `api.edit_message_media`.
    def edit_message_media(media : InputMedia, **options)
      if inline_id = self.inline_message_id
        options = options.merge(inline_message_id: inline_id)
      else
        options = options.merge(message_id: Helpers.or_throw(self.msg, "edit_message_media").id)
      end

      self.api.edit_message_media(
        **options,
        media: media,
        chat_id: Helpers.or_throw(self.chat, "edit_message_media").id
      )
    end

    # Context-aware alias for `api.edit_message_reply_markup`.
    def edit_message_reply_markup(reply_markup : InlineKeyboardMarkup?, **options)
      if inline_id = self.inline_message_id
        options = options.merge(inline_message_id: inline_id)
      else
        options = options.merge(message_id: Helpers.or_throw(self.msg, "edit_message_reply_markup").id)
      end

      self.api.edit_message_reply_markup(
        **options,
        reply_markup: reply_markup,
        chat_id: Helpers.or_throw(self.chat, "edit_message_reply_markup").id
      )
    end

    # Context-aware alias for `api.stop_poll`.
    def stop_poll(**options)
      self.api.stop_poll(
        Helpers.or_throw(self.chat, "stop_poll").id,
        Helpers.or_throw(self.msg, "stop_poll").id,
        **options
      )
    end

    # Context-aware alias for `api.delete_message`.
    def delete_message(**options)
      self.api.delete_message(
        Helpers.or_throw(self.chat, "delete_message").id,
        Helpers.or_throw(self.msg, "delete_message").id,
        **options,
      )
    end

    # Context-aware alias for `api.send_sticker`.
    def reply_with_sticker(sticker : InputFile | String, **options)
      self.api.send_sticker(
        Helpers.or_throw(self.chat, "reply_with_sticker").id,
        sticker,
        **options
      )
    end

    # Context-aware alias for `api.answer_inline_query`.
    def answer_inline_query(results : Array(InlineQueryResult), **options)
      self.api.answer_inline_query(
        Helpers.or_throw(self.inline_query, "answer_inline_query").id,
        results,
        **options
      )
    end

    # Context-aware alias for `api.send_invoice`.
    def reply_with_invoice(title : String, description : String, payload : String, provider_token : String, currency : String, prices : Array(LabeledPrice), **options)
      self.api.send_invoice(
        Helpers.or_throw(self.chat, "reply_with_invoice").id,
        title,
        description,
        payload,
        provider_token,
        currency,
        prices,
        **options
      )
    end

    # Context-aware alias for `api.answer_shipping_query`.
    def answer_shipping_query(ok : Bool, **options)
      self.api.answer_shipping_query(
        Helpers.or_throw(self.shipping_query, "answer_shipping_query").id,
        ok,
        **options
      )
    end

    # Context-aware alias for `api.answer_pre_checkout_query`.
    def answer_pre_checkout_query(ok : Bool, **options)
      self.api.answer_pre_checkout_query(
        Helpers.or_throw(self.pre_checkout_query, "answer_pre_checkout_query").id,
        ok,
        **options
      )
    end

    # Context-aware alias for `api.set_passport_data_errors`.
    def set_passport_data_errors(errors : Array(PassportElementError), **options)
      self.api.set_passport_data_errors(
        Helpers.or_throw(self.chat, "set_passport_data_errors").id,
        errors,
        **options
      )
    end

    # Context-aware alias for `api.send_game`.
    def reply_with_game(game_short_name : String, **options)
      self.api.send_game(
        Helpers.or_throw(self.chat, "reply_with_game").id,
        game_short_name,
        **options
      )
    end
  end
end
