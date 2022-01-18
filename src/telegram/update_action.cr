require "./api"

module Telegram
  # The available event types for `EventHandler`.
  @[Flags]
  enum UpdateAction : UInt128
    Update
    Message
    ReplyMessage
    EditedMessage
    ForwardedMessage
    CallbackQuery
    InlineQuery
    ShippingQuery
    PreCheckoutQuery
    ChosenInlineResult
    ChannelPost
    EditedChannelPost
    MyChatMember
    ChatMember

    ViaBot
    Text
    Caption
    Animation
    Audio
    Document
    Photo
    Sticker
    Video
    Voice
    Contact
    Location
    Venue
    MediaGroup
    NewChatMembers
    LeftChatMember
    NewChatTitle
    NewChatPhoto
    DeleteChatPhoto
    GroupChatCreated
    MessageAutoDeleteTimerChanged
    MigrateToChatId
    SupergroupChatCreated
    ChannelChatCreated
    MigrateFromChatId
    PinnedMessage
    Game
    Poll
    VideoNote
    Invoice
    SuccessfulPayment
    ConnectedWebsite
    PassportData
    PollAnswer
    ProximityAlertTriggered
    VoiceChatScheduled
    VoiceChatStarted
    VoiceChatEnded
    VoiceChatParticipantsInvited
    ReplyMarkup

    Dice        # 🎲
    Dart        # 🎯
    Basketball  # 🏀
    Football    # ⚽️
    Soccerball  # ⚽️ but American
    SlotMachine # 🎰
    Bowling     # 🎳

    BotMessage
    UserMessage
    ChannelMessage
    ChannelForwardMessage
    AnonymousAdminMessage

    # Entities
    Mention
    TextMention
    Hashtag
    Cashtag
    BotCommand
    Url
    Email
    PhoneNumber
    Bold
    Italic
    Code
    Pre
    TextLink
    Underline
    Strikethrough
    Spoiler

    def to_s
      super.to_s.underscore
    end

    def self.to_a
      {{ @type.constants.map { |c| c.stringify.id } }}
    end

    # Takes an `Update` and returns an array of update actions.
    def self.from_update(update : API::Update)
      flag = UpdateAction::Update

      if message = update.message
        flag |= UpdateAction::Message
        flag |= UpdateAction::ReplyMessage if message.reply_to_message
        flag |= UpdateAction::ForwardedMessage if message.forward_date

        if chat = message.chat
          flag |= UpdateAction::PinnedMessage if chat.pinned_message
        end

        flag |= UpdateAction::ViaBot if message.via_bot
        flag |= UpdateAction::Text if message.text
        flag |= UpdateAction::Caption if message.caption
        flag |= UpdateAction::Animation if message.animation
        flag |= UpdateAction::Audio if message.audio
        flag |= UpdateAction::Document if message.document
        flag |= UpdateAction::Photo if message.photo.size > 0
        flag |= UpdateAction::Sticker if message.sticker
        flag |= UpdateAction::Video if message.video
        flag |= UpdateAction::Voice if message.voice
        flag |= UpdateAction::Contact if message.contact
        flag |= UpdateAction::Location if message.location
        flag |= UpdateAction::Venue if message.venue
        flag |= UpdateAction::MediaGroup if message.media_group_id
        flag |= UpdateAction::NewChatMembers if message.new_chat_members.size > 0
        flag |= UpdateAction::LeftChatMember if message.left_chat_member
        flag |= UpdateAction::NewChatTitle if message.new_chat_title
        flag |= UpdateAction::NewChatPhoto if message.new_chat_photo.size > 0
        flag |= UpdateAction::DeleteChatPhoto if message.delete_chat_photo
        flag |= UpdateAction::GroupChatCreated if message.group_chat_created
        flag |= UpdateAction::MessageAutoDeleteTimerChanged if message.message_auto_delete_timer_changed
        flag |= UpdateAction::MigrateToChatId if message.migrate_from_chat_id
        flag |= UpdateAction::SupergroupChatCreated if message.supergroup_chat_created
        flag |= UpdateAction::ChannelChatCreated if message.channel_chat_created
        flag |= UpdateAction::MigrateFromChatId if message.migrate_from_chat_id
        flag |= UpdateAction::Game if message.game
        flag |= UpdateAction::Poll if message.poll
        flag |= UpdateAction::VideoNote if message.video_note
        flag |= UpdateAction::Invoice if message.invoice
        flag |= UpdateAction::SuccessfulPayment if message.successful_payment
        flag |= UpdateAction::ConnectedWebsite if message.connected_website
        flag |= UpdateAction::PassportData if message.passport_data
        flag |= UpdateAction::ProximityAlertTriggered if message.proximity_alert_triggered
        flag |= UpdateAction::VoiceChatScheduled if message.voice_chat_scheduled
        flag |= UpdateAction::VoiceChatStarted if message.voice_chat_started
        flag |= UpdateAction::VoiceChatEnded if message.voice_chat_ended
        flag |= UpdateAction::VoiceChatParticipantsInvited if message.voice_chat_participants_invited
        flag |= UpdateAction::ReplyMarkup if message.reply_markup

        if dice = message.dice
          case dice.emoji
          when "🎲"
            flag |= UpdateAction::Dice
          when "🎯"
            flag |= UpdateAction::Dart
          when "🏀"
            flag |= UpdateAction::Basketball
          when "⚽️"
            flag |= UpdateAction::Football
            flag |= UpdateAction::Soccerball
          when "🎰"
            flag |= UpdateAction::SlotMachine
          when "🎳"
            flag |= UpdateAction::Bowling
          end
        end

        case message.sender_type
        when API::SenderType::Bot
          flag |= UpdateAction::BotMessage
        when API::SenderType::Channel
          flag |= UpdateAction::ChannelMessage
        when API::SenderType::User
          flag |= UpdateAction::UserMessage
        when API::SenderType::AnonymousAdmin
          flag |= UpdateAction::AnonymousAdminMessage
        when API::SenderType::ChannelForward
          flag |= UpdateAction::ChannelForwardMessage
        end

        entities = (message.entities + message.caption_entities).map(&.type).uniq
        entities.each do |ent|
          case ent
          when "mention"
            flag |= UpdateAction::Mention
          when "text_mention"
            flag |= UpdateAction::TextMention
          when "hashtag"
            flag |= UpdateAction::Hashtag
          when "cashtag"
            flag |= UpdateAction::Cashtag
          when "bot_command"
            flag |= UpdateAction::BotCommand
          when "url"
            flag |= UpdateAction::Url
          when "email"
            flag |= UpdateAction::Email
          when "phone_number"
            flag |= UpdateAction::PhoneNumber
          when "bold"
            flag |= UpdateAction::Bold
          when "italic"
            flag |= UpdateAction::Italic
          when "code"
            flag |= UpdateAction::Code
          when "pre"
            flag |= UpdateAction::Pre
          when "text_link"
            flag |= UpdateAction::TextLink
          when "underline"
            flag |= UpdateAction::Underline
          when "strikethrough"
            flag |= UpdateAction::Strikethrough
          when "spoiler"
            flag |= UpdateAction::Spoiler
          end
        end
      end

      flag |= UpdateAction::EditedMessage if update.edited_message
      flag |= UpdateAction::ChannelPost if update.channel_post
      flag |= UpdateAction::EditedChannelPost if update.edited_channel_post
      flag |= UpdateAction::InlineQuery if update.inline_query
      flag |= UpdateAction::ChosenInlineResult if update.chosen_inline_result
      flag |= UpdateAction::CallbackQuery if update.callback_query
      flag |= UpdateAction::ShippingQuery if update.shipping_query
      flag |= UpdateAction::PreCheckoutQuery if update.pre_checkout_query
      flag |= UpdateAction::Poll if update.poll
      flag |= UpdateAction::PollAnswer if update.poll_answer
      flag |= UpdateAction::MyChatMember if update.my_chat_member
      flag |= UpdateAction::ChatMember if update.chat_member

      flag
    end
  end
end
