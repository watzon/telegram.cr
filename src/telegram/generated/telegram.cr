# Crystal Telegram Bot API Client
#
# Generated for Telegram Bot API Bot API 9.2
# Release date: August 15, 2025
#
# This is an automatically generated client for the Telegram Bot API.
# It provides typesafe access to all Telegram Bot API methods and types.
#
# Example usage:
# ```crystal
# require "telegram"
#
# client = Telegram::APIClient.new("YOUR_BOT_TOKEN")
# updates = client.get_updates
# ```

require "json"
require "./client"

module Telegram
  # Telegram API Types - Auto-generated
  # Generated from Telegram Bot API Bot API 9.2
  # Release date: August 15, 2025
  #
  # All types in a single file to avoid dependency issues

  # Telegram API type: Update
  # This object represents an incoming update.
  # At most one of the optional parameters can be present in any given update.
  class Update
    include JSON::Serializable

    # The update's unique identifier. Update identifiers start from a certain positive number and increase sequentially. This identifier becomes especially handy if you're using webhooks, since it allows you to ignore repeated updates or to restore the correct update sequence, should they get out of order. If there are no new updates for at least a week, then identifier of the next update will be chosen randomly instead of sequentially.
    @[JSON::Field(key: "update_id")]
    property update_id : Int32

    # Optional. New incoming message of any kind - text, photo, sticker, etc.
    @[JSON::Field(key: "message")]
    property message : Message?

    # Optional. New version of a message that is known to the bot and was edited. This update may at times be triggered by changes to message fields that are either unavailable or not actively used by your bot.
    @[JSON::Field(key: "edited_message")]
    property edited_message : Message?

    # Optional. New incoming channel post of any kind - text, photo, sticker, etc.
    @[JSON::Field(key: "channel_post")]
    property channel_post : Message?

    # Optional. New version of a channel post that is known to the bot and was edited. This update may at times be triggered by changes to message fields that are either unavailable or not actively used by your bot.
    @[JSON::Field(key: "edited_channel_post")]
    property edited_channel_post : Message?

    # Optional. The bot was connected to or disconnected from a business account, or a user edited an existing connection with the bot
    @[JSON::Field(key: "business_connection")]
    property business_connection : BusinessConnection?

    # Optional. New message from a connected business account
    @[JSON::Field(key: "business_message")]
    property business_message : Message?

    # Optional. New version of a message from a connected business account
    @[JSON::Field(key: "edited_business_message")]
    property edited_business_message : Message?

    # Optional. Messages were deleted from a connected business account
    @[JSON::Field(key: "deleted_business_messages")]
    property deleted_business_messages : BusinessMessagesDeleted?

    # Optional. A reaction to a message was changed by a user. The bot must be an administrator in the chat and must explicitly specify "message_reaction" in the list of allowed_updates to receive these updates. The update isn't received for reactions set by bots.
    @[JSON::Field(key: "message_reaction")]
    property message_reaction : MessageReactionUpdated?

    # Optional. Reactions to a message with anonymous reactions were changed. The bot must be an administrator in the chat and must explicitly specify "message_reaction_count" in the list of allowed_updates to receive these updates. The updates are grouped and can be sent with delay up to a few minutes.
    @[JSON::Field(key: "message_reaction_count")]
    property message_reaction_count : MessageReactionCountUpdated?

    # Optional. New incoming inline query
    @[JSON::Field(key: "inline_query")]
    property inline_query : InlineQuery?

    # Optional. The result of an inline query that was chosen by a user and sent to their chat partner. Please see our documentation on the feedback collecting for details on how to enable these updates for your bot.
    @[JSON::Field(key: "chosen_inline_result")]
    property chosen_inline_result : ChosenInlineResult?

    # Optional. New incoming callback query
    @[JSON::Field(key: "callback_query")]
    property callback_query : CallbackQuery?

    # Optional. New incoming shipping query. Only for invoices with flexible price
    @[JSON::Field(key: "shipping_query")]
    property shipping_query : ShippingQuery?

    # Optional. New incoming pre-checkout query. Contains full information about checkout
    @[JSON::Field(key: "pre_checkout_query")]
    property pre_checkout_query : PreCheckoutQuery?

    # Optional. A user purchased paid media with a non-empty payload sent by the bot in a non-channel chat
    @[JSON::Field(key: "purchased_paid_media")]
    property purchased_paid_media : PaidMediaPurchased?

    # Optional. New poll state. Bots receive only updates about manually stopped polls and polls, which are sent by the bot
    @[JSON::Field(key: "poll")]
    property poll : Poll?

    # Optional. A user changed their answer in a non-anonymous poll. Bots receive new votes only in polls that were sent by the bot itself.
    @[JSON::Field(key: "poll_answer")]
    property poll_answer : PollAnswer?

    # Optional. The bot's chat member status was updated in a chat. For private chats, this update is received only when the bot is blocked or unblocked by the user.
    @[JSON::Field(key: "my_chat_member")]
    property my_chat_member : ChatMemberUpdated?

    # Optional. A chat member's status was updated in a chat. The bot must be an administrator in the chat and must explicitly specify "chat_member" in the list of allowed_updates to receive these updates.
    @[JSON::Field(key: "chat_member")]
    property chat_member : ChatMemberUpdated?

    # Optional. A request to join the chat has been sent. The bot must have the can_invite_users administrator right in the chat to receive these updates.
    @[JSON::Field(key: "chat_join_request")]
    property chat_join_request : ChatJoinRequest?

    # Optional. A chat boost was added or changed. The bot must be an administrator in the chat to receive these updates.
    @[JSON::Field(key: "chat_boost")]
    property chat_boost : ChatBoostUpdated?

    # Optional. A boost was removed from a chat. The bot must be an administrator in the chat to receive these updates.
    @[JSON::Field(key: "removed_chat_boost")]
    property removed_chat_boost : ChatBoostRemoved?

  end

  # Telegram API type: WebhookInfo
  # Describes the current status of a webhook.
  struct WebhookInfo
    include JSON::Serializable

    # Webhook URL, may be empty if webhook is not set up
    @[JSON::Field(key: "url")]
    property url : String

    # True, if a custom certificate was provided for webhook certificate checks
    @[JSON::Field(key: "has_custom_certificate")]
    property has_custom_certificate : Bool

    # Number of updates awaiting delivery
    @[JSON::Field(key: "pending_update_count")]
    property pending_update_count : Int32

    # Optional. Currently used webhook IP address
    @[JSON::Field(key: "ip_address")]
    property ip_address : String?

    # Optional. Unix time for the most recent error that happened when trying to deliver an update via webhook
    @[JSON::Field(key: "last_error_date")]
    property last_error_date : Int32?

    # Optional. Error message in human-readable format for the most recent error that happened when trying to deliver an update via webhook
    @[JSON::Field(key: "last_error_message")]
    property last_error_message : String?

    # Optional. Unix time of the most recent error that happened when trying to synchronize available updates with Telegram datacenters
    @[JSON::Field(key: "last_synchronization_error_date")]
    property last_synchronization_error_date : Int32?

    # Optional. The maximum allowed number of simultaneous HTTPS connections to the webhook for update delivery
    @[JSON::Field(key: "max_connections")]
    property max_connections : Int32?

    # Optional. A list of update types the bot is subscribed to. Defaults to all update types except chat_member
    @[JSON::Field(key: "allowed_updates")]
    property allowed_updates : Array(String)?

  end

  # Telegram API type: User
  # This object represents a Telegram user or bot.
  class User
    include JSON::Serializable

    # Unique identifier for this user or bot. This number may have more than 32 significant bits and some programming languages may have difficulty/silent defects in interpreting it. But it has at most 52 significant bits, so a 64-bit integer or double-precision float type are safe for storing this identifier.
    @[JSON::Field(key: "id")]
    property id : Int32

    # True, if this user is a bot
    @[JSON::Field(key: "is_bot")]
    property is_bot : Bool

    # User's or bot's first name
    @[JSON::Field(key: "first_name")]
    property first_name : String

    # Optional. User's or bot's last name
    @[JSON::Field(key: "last_name")]
    property last_name : String?

    # Optional. User's or bot's username
    @[JSON::Field(key: "username")]
    property username : String?

    # Optional. IETF language tag of the user's language
    @[JSON::Field(key: "language_code")]
    property language_code : String?

    # Optional. True, if this user is a Telegram Premium user
    @[JSON::Field(key: "is_premium")]
    property is_premium : Bool?

    # Optional. True, if this user added the bot to the attachment menu
    @[JSON::Field(key: "added_to_attachment_menu")]
    property added_to_attachment_menu : Bool?

    # Optional. True, if the bot can be invited to groups. Returned only in getMe.
    @[JSON::Field(key: "can_join_groups")]
    property can_join_groups : Bool?

    # Optional. True, if privacy mode is disabled for the bot. Returned only in getMe.
    @[JSON::Field(key: "can_read_all_group_messages")]
    property can_read_all_group_messages : Bool?

    # Optional. True, if the bot supports inline queries. Returned only in getMe.
    @[JSON::Field(key: "supports_inline_queries")]
    property supports_inline_queries : Bool?

    # Optional. True, if the bot can be connected to a Telegram Business account to receive its messages. Returned only in getMe.
    @[JSON::Field(key: "can_connect_to_business")]
    property can_connect_to_business : Bool?

    # Optional. True, if the bot has a main Web App. Returned only in getMe.
    @[JSON::Field(key: "has_main_web_app")]
    property has_main_web_app : Bool?

  end

  # Telegram API type: Chat
  # This object represents a chat.
  class Chat
    include JSON::Serializable

    # Unique identifier for this chat. This number may have more than 32 significant bits and some programming languages may have difficulty/silent defects in interpreting it. But it has at most 52 significant bits, so a signed 64-bit integer or double-precision float type are safe for storing this identifier.
    @[JSON::Field(key: "id")]
    property id : Int32

    # Type of the chat, can be either "private", "group", "supergroup" or "channel"
    @[JSON::Field(key: "type")]
    property type : String

    # Optional. Title, for supergroups, channels and group chats
    @[JSON::Field(key: "title")]
    property title : String?

    # Optional. Username, for private chats, supergroups and channels if available
    @[JSON::Field(key: "username")]
    property username : String?

    # Optional. First name of the other party in a private chat
    @[JSON::Field(key: "first_name")]
    property first_name : String?

    # Optional. Last name of the other party in a private chat
    @[JSON::Field(key: "last_name")]
    property last_name : String?

    # Optional. True, if the supergroup chat is a forum (has topics enabled)
    @[JSON::Field(key: "is_forum")]
    property is_forum : Bool?

    # Optional. True, if the chat is the direct messages chat of a channel
    @[JSON::Field(key: "is_direct_messages")]
    property is_direct_messages : Bool?

  end

  # Telegram API type: ChatFullInfo
  # This object contains full information about a chat.
  struct ChatFullInfo
    include JSON::Serializable

    # Unique identifier for this chat. This number may have more than 32 significant bits and some programming languages may have difficulty/silent defects in interpreting it. But it has at most 52 significant bits, so a signed 64-bit integer or double-precision float type are safe for storing this identifier.
    @[JSON::Field(key: "id")]
    property id : Int32

    # Type of the chat, can be either "private", "group", "supergroup" or "channel"
    @[JSON::Field(key: "type")]
    property type : String

    # Optional. Title, for supergroups, channels and group chats
    @[JSON::Field(key: "title")]
    property title : String?

    # Optional. Username, for private chats, supergroups and channels if available
    @[JSON::Field(key: "username")]
    property username : String?

    # Optional. First name of the other party in a private chat
    @[JSON::Field(key: "first_name")]
    property first_name : String?

    # Optional. Last name of the other party in a private chat
    @[JSON::Field(key: "last_name")]
    property last_name : String?

    # Optional. True, if the supergroup chat is a forum (has topics enabled)
    @[JSON::Field(key: "is_forum")]
    property is_forum : Bool?

    # Optional. True, if the chat is the direct messages chat of a channel
    @[JSON::Field(key: "is_direct_messages")]
    property is_direct_messages : Bool?

    # Identifier of the accent color for the chat name and backgrounds of the chat photo, reply header, and link preview. See accent colors for more details.
    @[JSON::Field(key: "accent_color_id")]
    property accent_color_id : Int32

    # The maximum number of reactions that can be set on a message in the chat
    @[JSON::Field(key: "max_reaction_count")]
    property max_reaction_count : Int32

    # Optional. Chat photo
    @[JSON::Field(key: "photo")]
    property photo : ChatPhoto?

    # Optional. If non-empty, the list of all active chat usernames; for private chats, supergroups and channels
    @[JSON::Field(key: "active_usernames")]
    property active_usernames : Array(String)?

    # Optional. For private chats, the date of birth of the user
    @[JSON::Field(key: "birthdate")]
    property birthdate : Birthdate?

    # Optional. For private chats with business accounts, the intro of the business
    @[JSON::Field(key: "business_intro")]
    property business_intro : BusinessIntro?

    # Optional. For private chats with business accounts, the location of the business
    @[JSON::Field(key: "business_location")]
    property business_location : BusinessLocation?

    # Optional. For private chats with business accounts, the opening hours of the business
    @[JSON::Field(key: "business_opening_hours")]
    property business_opening_hours : BusinessOpeningHours?

    # Optional. For private chats, the personal channel of the user
    @[JSON::Field(key: "personal_chat")]
    property personal_chat : Chat?

    # Optional. Information about the corresponding channel chat; for direct messages chats only
    @[JSON::Field(key: "parent_chat")]
    property parent_chat : Chat?

    # Optional. List of available reactions allowed in the chat. If omitted, then all emoji reactions are allowed.
    @[JSON::Field(key: "available_reactions")]
    property available_reactions : Array(ReactionType)?

    # Optional. Custom emoji identifier of the emoji chosen by the chat for the reply header and link preview background
    @[JSON::Field(key: "background_custom_emoji_id")]
    property background_custom_emoji_id : String?

    # Optional. Identifier of the accent color for the chat's profile background. See profile accent colors for more details.
    @[JSON::Field(key: "profile_accent_color_id")]
    property profile_accent_color_id : Int32?

    # Optional. Custom emoji identifier of the emoji chosen by the chat for its profile background
    @[JSON::Field(key: "profile_background_custom_emoji_id")]
    property profile_background_custom_emoji_id : String?

    # Optional. Custom emoji identifier of the emoji status of the chat or the other party in a private chat
    @[JSON::Field(key: "emoji_status_custom_emoji_id")]
    property emoji_status_custom_emoji_id : String?

    # Optional. Expiration date of the emoji status of the chat or the other party in a private chat, in Unix time, if any
    @[JSON::Field(key: "emoji_status_expiration_date")]
    property emoji_status_expiration_date : Int32?

    # Optional. Bio of the other party in a private chat
    @[JSON::Field(key: "bio")]
    property bio : String?

    # Optional. True, if privacy settings of the other party in the private chat allows to use tg://user?id=<user_id> links only in chats with the user
    @[JSON::Field(key: "has_private_forwards")]
    property has_private_forwards : Bool?

    # Optional. True, if the privacy settings of the other party restrict sending voice and video note messages in the private chat
    @[JSON::Field(key: "has_restricted_voice_and_video_messages")]
    property has_restricted_voice_and_video_messages : Bool?

    # Optional. True, if users need to join the supergroup before they can send messages
    @[JSON::Field(key: "join_to_send_messages")]
    property join_to_send_messages : Bool?

    # Optional. True, if all users directly joining the supergroup without using an invite link need to be approved by supergroup administrators
    @[JSON::Field(key: "join_by_request")]
    property join_by_request : Bool?

    # Optional. Description, for groups, supergroups and channel chats
    @[JSON::Field(key: "description")]
    property description : String?

    # Optional. Primary invite link, for groups, supergroups and channel chats
    @[JSON::Field(key: "invite_link")]
    property invite_link : String?

    # Optional. The most recent pinned message (by sending date)
    @[JSON::Field(key: "pinned_message")]
    property pinned_message : Message?

    # Optional. Default chat member permissions, for groups and supergroups
    @[JSON::Field(key: "permissions")]
    property permissions : ChatPermissions?

    # Information about types of gifts that are accepted by the chat or by the corresponding user for private chats
    @[JSON::Field(key: "accepted_gift_types")]
    property accepted_gift_types : AcceptedGiftTypes

    # Optional. True, if paid media messages can be sent or forwarded to the channel chat. The field is available only for channel chats.
    @[JSON::Field(key: "can_send_paid_media")]
    property can_send_paid_media : Bool?

    # Optional. For supergroups, the minimum allowed delay between consecutive messages sent by each unprivileged user; in seconds
    @[JSON::Field(key: "slow_mode_delay")]
    property slow_mode_delay : Int32?

    # Optional. For supergroups, the minimum number of boosts that a non-administrator user needs to add in order to ignore slow mode and chat permissions
    @[JSON::Field(key: "unrestrict_boost_count")]
    property unrestrict_boost_count : Int32?

    # Optional. The time after which all messages sent to the chat will be automatically deleted; in seconds
    @[JSON::Field(key: "message_auto_delete_time")]
    property message_auto_delete_time : Int32?

    # Optional. True, if aggressive anti-spam checks are enabled in the supergroup. The field is only available to chat administrators.
    @[JSON::Field(key: "has_aggressive_anti_spam_enabled")]
    property has_aggressive_anti_spam_enabled : Bool?

    # Optional. True, if non-administrators can only get the list of bots and administrators in the chat
    @[JSON::Field(key: "has_hidden_members")]
    property has_hidden_members : Bool?

    # Optional. True, if messages from the chat can't be forwarded to other chats
    @[JSON::Field(key: "has_protected_content")]
    property has_protected_content : Bool?

    # Optional. True, if new chat members will have access to old messages; available only to chat administrators
    @[JSON::Field(key: "has_visible_history")]
    property has_visible_history : Bool?

    # Optional. For supergroups, name of the group sticker set
    @[JSON::Field(key: "sticker_set_name")]
    property sticker_set_name : String?

    # Optional. True, if the bot can change the group sticker set
    @[JSON::Field(key: "can_set_sticker_set")]
    property can_set_sticker_set : Bool?

    # Optional. For supergroups, the name of the group's custom emoji sticker set. Custom emoji from this set can be used by all users and bots in the group.
    @[JSON::Field(key: "custom_emoji_sticker_set_name")]
    property custom_emoji_sticker_set_name : String?

    # Optional. Unique identifier for the linked chat, i.e. the discussion group identifier for a channel and vice versa; for supergroups and channel chats. This identifier may be greater than 32 bits and some programming languages may have difficulty/silent defects in interpreting it. But it is smaller than 52 bits, so a signed 64 bit integer or double-precision float type are safe for storing this identifier.
    @[JSON::Field(key: "linked_chat_id")]
    property linked_chat_id : Int32?

    # Optional. For supergroups, the location to which the supergroup is connected
    @[JSON::Field(key: "location")]
    property location : ChatLocation?

  end

  # Telegram API type: Message
  # This object represents a message.
  class Message
    include JSON::Serializable

    # Unique message identifier inside this chat. In specific instances (e.g., message containing a video sent to a big chat), the server might automatically schedule a message instead of sending it immediately. In such cases, this field will be 0 and the relevant message will be unusable until it is actually sent
    @[JSON::Field(key: "message_id")]
    property message_id : Int32

    # Optional. Unique identifier of a message thread to which the message belongs; for supergroups only
    @[JSON::Field(key: "message_thread_id")]
    property message_thread_id : Int32?

    # Optional. Information about the direct messages chat topic that contains the message
    @[JSON::Field(key: "direct_messages_topic")]
    property direct_messages_topic : DirectMessagesTopic?

    # Optional. Sender of the message; may be empty for messages sent to channels. For backward compatibility, if the message was sent on behalf of a chat, the field contains a fake sender user in non-channel chats
    @[JSON::Field(key: "from")]
    property from : User?

    # Optional. Sender of the message when sent on behalf of a chat. For example, the supergroup itself for messages sent by its anonymous administrators or a linked channel for messages automatically forwarded to the channel's discussion group. For backward compatibility, if the message was sent on behalf of a chat, the field from contains a fake sender user in non-channel chats.
    @[JSON::Field(key: "sender_chat")]
    property sender_chat : Chat?

    # Optional. If the sender of the message boosted the chat, the number of boosts added by the user
    @[JSON::Field(key: "sender_boost_count")]
    property sender_boost_count : Int32?

    # Optional. The bot that actually sent the message on behalf of the business account. Available only for outgoing messages sent on behalf of the connected business account.
    @[JSON::Field(key: "sender_business_bot")]
    property sender_business_bot : User?

    # Date the message was sent in Unix time. It is always a positive number, representing a valid date.
    @[JSON::Field(key: "date")]
    property date : Int32

    # Optional. Unique identifier of the business connection from which the message was received. If non-empty, the message belongs to a chat of the corresponding business account that is independent from any potential bot chat which might share the same identifier.
    @[JSON::Field(key: "business_connection_id")]
    property business_connection_id : String?

    # Chat the message belongs to
    @[JSON::Field(key: "chat")]
    property chat : Chat

    # Optional. Information about the original message for forwarded messages
    @[JSON::Field(key: "forward_origin")]
    property forward_origin : MessageOrigin?

    # Optional. True, if the message is sent to a forum topic
    @[JSON::Field(key: "is_topic_message")]
    property is_topic_message : Bool?

    # Optional. True, if the message is a channel post that was automatically forwarded to the connected discussion group
    @[JSON::Field(key: "is_automatic_forward")]
    property is_automatic_forward : Bool?

    # Optional. For replies in the same chat and message thread, the original message. Note that the Message object in this field will not contain further reply_to_message fields even if it itself is a reply.
    @[JSON::Field(key: "reply_to_message")]
    property reply_to_message : Message?

    # Optional. Information about the message that is being replied to, which may come from another chat or forum topic
    @[JSON::Field(key: "external_reply")]
    property external_reply : ExternalReplyInfo?

    # Optional. For replies that quote part of the original message, the quoted part of the message
    @[JSON::Field(key: "quote")]
    property quote : TextQuote?

    # Optional. For replies to a story, the original story
    @[JSON::Field(key: "reply_to_story")]
    property reply_to_story : Story?

    # Optional. Identifier of the specific checklist task that is being replied to
    @[JSON::Field(key: "reply_to_checklist_task_id")]
    property reply_to_checklist_task_id : Int32?

    # Optional. Bot through which the message was sent
    @[JSON::Field(key: "via_bot")]
    property via_bot : User?

    # Optional. Date the message was last edited in Unix time
    @[JSON::Field(key: "edit_date")]
    property edit_date : Int32?

    # Optional. True, if the message can't be forwarded
    @[JSON::Field(key: "has_protected_content")]
    property has_protected_content : Bool?

    # Optional. True, if the message was sent by an implicit action, for example, as an away or a greeting business message, or as a scheduled message
    @[JSON::Field(key: "is_from_offline")]
    property is_from_offline : Bool?

    # Optional. True, if the message is a paid post. Note that such posts must not be deleted for 24 hours to receive the payment and can't be edited.
    @[JSON::Field(key: "is_paid_post")]
    property is_paid_post : Bool?

    # Optional. The unique identifier of a media message group this message belongs to
    @[JSON::Field(key: "media_group_id")]
    property media_group_id : String?

    # Optional. Signature of the post author for messages in channels, or the custom title of an anonymous group administrator
    @[JSON::Field(key: "author_signature")]
    property author_signature : String?

    # Optional. The number of Telegram Stars that were paid by the sender of the message to send it
    @[JSON::Field(key: "paid_star_count")]
    property paid_star_count : Int32?

    # Optional. For text messages, the actual UTF-8 text of the message
    @[JSON::Field(key: "text")]
    property text : String?

    # Optional. For text messages, special entities like usernames, URLs, bot commands, etc. that appear in the text
    @[JSON::Field(key: "entities")]
    property entities : Array(MessageEntity)?

    # Optional. Options used for link preview generation for the message, if it is a text message and link preview options were changed
    @[JSON::Field(key: "link_preview_options")]
    property link_preview_options : LinkPreviewOptions?

    # Optional. Information about suggested post parameters if the message is a suggested post in a channel direct messages chat. If the message is an approved or declined suggested post, then it can't be edited.
    @[JSON::Field(key: "suggested_post_info")]
    property suggested_post_info : SuggestedPostInfo?

    # Optional. Unique identifier of the message effect added to the message
    @[JSON::Field(key: "effect_id")]
    property effect_id : String?

    # Optional. Message is an animation, information about the animation. For backward compatibility, when this field is set, the document field will also be set
    @[JSON::Field(key: "animation")]
    property animation : Animation?

    # Optional. Message is an audio file, information about the file
    @[JSON::Field(key: "audio")]
    property audio : Audio?

    # Optional. Message is a general file, information about the file
    @[JSON::Field(key: "document")]
    property document : Document?

    # Optional. Message contains paid media; information about the paid media
    @[JSON::Field(key: "paid_media")]
    property paid_media : PaidMediaInfo?

    # Optional. Message is a photo, available sizes of the photo
    @[JSON::Field(key: "photo")]
    property photo : Array(PhotoSize)?

    # Optional. Message is a sticker, information about the sticker
    @[JSON::Field(key: "sticker")]
    property sticker : Sticker?

    # Optional. Message is a forwarded story
    @[JSON::Field(key: "story")]
    property story : Story?

    # Optional. Message is a video, information about the video
    @[JSON::Field(key: "video")]
    property video : Video?

    # Optional. Message is a video note, information about the video message
    @[JSON::Field(key: "video_note")]
    property video_note : VideoNote?

    # Optional. Message is a voice message, information about the file
    @[JSON::Field(key: "voice")]
    property voice : Voice?

    # Optional. Caption for the animation, audio, document, paid media, photo, video or voice
    @[JSON::Field(key: "caption")]
    property caption : String?

    # Optional. For messages with a caption, special entities like usernames, URLs, bot commands, etc. that appear in the caption
    @[JSON::Field(key: "caption_entities")]
    property caption_entities : Array(MessageEntity)?

    # Optional. True, if the caption must be shown above the message media
    @[JSON::Field(key: "show_caption_above_media")]
    property show_caption_above_media : Bool?

    # Optional. True, if the message media is covered by a spoiler animation
    @[JSON::Field(key: "has_media_spoiler")]
    property has_media_spoiler : Bool?

    # Optional. Message is a checklist
    @[JSON::Field(key: "checklist")]
    property checklist : Checklist?

    # Optional. Message is a shared contact, information about the contact
    @[JSON::Field(key: "contact")]
    property contact : Contact?

    # Optional. Message is a dice with random value
    @[JSON::Field(key: "dice")]
    property dice : Dice?

    # Optional. Message is a game, information about the game. More about games: https://core.telegram.org/bots/api#games
    @[JSON::Field(key: "game")]
    property game : Game?

    # Optional. Message is a native poll, information about the poll
    @[JSON::Field(key: "poll")]
    property poll : Poll?

    # Optional. Message is a venue, information about the venue. For backward compatibility, when this field is set, the location field will also be set
    @[JSON::Field(key: "venue")]
    property venue : Venue?

    # Optional. Message is a shared location, information about the location
    @[JSON::Field(key: "location")]
    property location : Location?

    # Optional. New members that were added to the group or supergroup and information about them (the bot itself may be one of these members)
    @[JSON::Field(key: "new_chat_members")]
    property new_chat_members : Array(User)?

    # Optional. A member was removed from the group, information about them (this member may be the bot itself)
    @[JSON::Field(key: "left_chat_member")]
    property left_chat_member : User?

    # Optional. A chat title was changed to this value
    @[JSON::Field(key: "new_chat_title")]
    property new_chat_title : String?

    # Optional. A chat photo was change to this value
    @[JSON::Field(key: "new_chat_photo")]
    property new_chat_photo : Array(PhotoSize)?

    # Optional. Service message: the chat photo was deleted
    @[JSON::Field(key: "delete_chat_photo")]
    property delete_chat_photo : Bool?

    # Optional. Service message: the group has been created
    @[JSON::Field(key: "group_chat_created")]
    property group_chat_created : Bool?

    # Optional. Service message: the supergroup has been created. This field can't be received in a message coming through updates, because bot can't be a member of a supergroup when it is created. It can only be found in reply_to_message if someone replies to a very first message in a directly created supergroup.
    @[JSON::Field(key: "supergroup_chat_created")]
    property supergroup_chat_created : Bool?

    # Optional. Service message: the channel has been created. This field can't be received in a message coming through updates, because bot can't be a member of a channel when it is created. It can only be found in reply_to_message if someone replies to a very first message in a channel.
    @[JSON::Field(key: "channel_chat_created")]
    property channel_chat_created : Bool?

    # Optional. Service message: auto-delete timer settings changed in the chat
    @[JSON::Field(key: "message_auto_delete_timer_changed")]
    property message_auto_delete_timer_changed : MessageAutoDeleteTimerChanged?

    # Optional. The group has been migrated to a supergroup with the specified identifier. This number may have more than 32 significant bits and some programming languages may have difficulty/silent defects in interpreting it. But it has at most 52 significant bits, so a signed 64-bit integer or double-precision float type are safe for storing this identifier.
    @[JSON::Field(key: "migrate_to_chat_id")]
    property migrate_to_chat_id : Int32?

    # Optional. The supergroup has been migrated from a group with the specified identifier. This number may have more than 32 significant bits and some programming languages may have difficulty/silent defects in interpreting it. But it has at most 52 significant bits, so a signed 64-bit integer or double-precision float type are safe for storing this identifier.
    @[JSON::Field(key: "migrate_from_chat_id")]
    property migrate_from_chat_id : Int32?

    # Optional. Specified message was pinned. Note that the Message object in this field will not contain further reply_to_message fields even if it itself is a reply.
    @[JSON::Field(key: "pinned_message")]
    property pinned_message : MaybeInaccessibleMessage?

    # Optional. Message is an invoice for a payment, information about the invoice. More about payments: https://core.telegram.org/bots/api#payments
    @[JSON::Field(key: "invoice")]
    property invoice : Invoice?

    # Optional. Message is a service message about a successful payment, information about the payment. More about payments: https://core.telegram.org/bots/api#payments
    @[JSON::Field(key: "successful_payment")]
    property successful_payment : SuccessfulPayment?

    # Optional. Message is a service message about a refunded payment, information about the payment. More about payments: https://core.telegram.org/bots/api#payments
    @[JSON::Field(key: "refunded_payment")]
    property refunded_payment : RefundedPayment?

    # Optional. Service message: users were shared with the bot
    @[JSON::Field(key: "users_shared")]
    property users_shared : UsersShared?

    # Optional. Service message: a chat was shared with the bot
    @[JSON::Field(key: "chat_shared")]
    property chat_shared : ChatShared?

    # Optional. Service message: a regular gift was sent or received
    @[JSON::Field(key: "gift")]
    property gift : GiftInfo?

    # Optional. Service message: a unique gift was sent or received
    @[JSON::Field(key: "unique_gift")]
    property unique_gift : UniqueGiftInfo?

    # Optional. The domain name of the website on which the user has logged in. More about Telegram Login: https://core.telegram.org/widgets/login
    @[JSON::Field(key: "connected_website")]
    property connected_website : String?

    # Optional. Service message: the user allowed the bot to write messages after adding it to the attachment or side menu, launching a Web App from a link, or accepting an explicit request from a Web App sent by the method requestWriteAccess
    @[JSON::Field(key: "write_access_allowed")]
    property write_access_allowed : WriteAccessAllowed?

    # Optional. Telegram Passport data
    @[JSON::Field(key: "passport_data")]
    property passport_data : PassportData?

    # Optional. Service message. A user in the chat triggered another user's proximity alert while sharing Live Location.
    @[JSON::Field(key: "proximity_alert_triggered")]
    property proximity_alert_triggered : ProximityAlertTriggered?

    # Optional. Service message: user boosted the chat
    @[JSON::Field(key: "boost_added")]
    property boost_added : ChatBoostAdded?

    # Optional. Service message: chat background set
    @[JSON::Field(key: "chat_background_set")]
    property chat_background_set : ChatBackground?

    # Optional. Service message: some tasks in a checklist were marked as done or not done
    @[JSON::Field(key: "checklist_tasks_done")]
    property checklist_tasks_done : ChecklistTasksDone?

    # Optional. Service message: tasks were added to a checklist
    @[JSON::Field(key: "checklist_tasks_added")]
    property checklist_tasks_added : ChecklistTasksAdded?

    # Optional. Service message: the price for paid messages in the corresponding direct messages chat of a channel has changed
    @[JSON::Field(key: "direct_message_price_changed")]
    property direct_message_price_changed : DirectMessagePriceChanged?

    # Optional. Service message: forum topic created
    @[JSON::Field(key: "forum_topic_created")]
    property forum_topic_created : ForumTopicCreated?

    # Optional. Service message: forum topic edited
    @[JSON::Field(key: "forum_topic_edited")]
    property forum_topic_edited : ForumTopicEdited?

    # Optional. Service message: forum topic closed
    @[JSON::Field(key: "forum_topic_closed")]
    property forum_topic_closed : ForumTopicClosed?

    # Optional. Service message: forum topic reopened
    @[JSON::Field(key: "forum_topic_reopened")]
    property forum_topic_reopened : ForumTopicReopened?

    # Optional. Service message: the 'General' forum topic hidden
    @[JSON::Field(key: "general_forum_topic_hidden")]
    property general_forum_topic_hidden : GeneralForumTopicHidden?

    # Optional. Service message: the 'General' forum topic unhidden
    @[JSON::Field(key: "general_forum_topic_unhidden")]
    property general_forum_topic_unhidden : GeneralForumTopicUnhidden?

    # Optional. Service message: a scheduled giveaway was created
    @[JSON::Field(key: "giveaway_created")]
    property giveaway_created : GiveawayCreated?

    # Optional. The message is a scheduled giveaway message
    @[JSON::Field(key: "giveaway")]
    property giveaway : Giveaway?

    # Optional. A giveaway with public winners was completed
    @[JSON::Field(key: "giveaway_winners")]
    property giveaway_winners : GiveawayWinners?

    # Optional. Service message: a giveaway without public winners was completed
    @[JSON::Field(key: "giveaway_completed")]
    property giveaway_completed : GiveawayCompleted?

    # Optional. Service message: the price for paid messages has changed in the chat
    @[JSON::Field(key: "paid_message_price_changed")]
    property paid_message_price_changed : PaidMessagePriceChanged?

    # Optional. Service message: a suggested post was approved
    @[JSON::Field(key: "suggested_post_approved")]
    property suggested_post_approved : SuggestedPostApproved?

    # Optional. Service message: approval of a suggested post has failed
    @[JSON::Field(key: "suggested_post_approval_failed")]
    property suggested_post_approval_failed : SuggestedPostApprovalFailed?

    # Optional. Service message: a suggested post was declined
    @[JSON::Field(key: "suggested_post_declined")]
    property suggested_post_declined : SuggestedPostDeclined?

    # Optional. Service message: payment for a suggested post was received
    @[JSON::Field(key: "suggested_post_paid")]
    property suggested_post_paid : SuggestedPostPaid?

    # Optional. Service message: payment for a suggested post was refunded
    @[JSON::Field(key: "suggested_post_refunded")]
    property suggested_post_refunded : SuggestedPostRefunded?

    # Optional. Service message: video chat scheduled
    @[JSON::Field(key: "video_chat_scheduled")]
    property video_chat_scheduled : VideoChatScheduled?

    # Optional. Service message: video chat started
    @[JSON::Field(key: "video_chat_started")]
    property video_chat_started : VideoChatStarted?

    # Optional. Service message: video chat ended
    @[JSON::Field(key: "video_chat_ended")]
    property video_chat_ended : VideoChatEnded?

    # Optional. Service message: new participants invited to a video chat
    @[JSON::Field(key: "video_chat_participants_invited")]
    property video_chat_participants_invited : VideoChatParticipantsInvited?

    # Optional. Service message: data sent by a Web App
    @[JSON::Field(key: "web_app_data")]
    property web_app_data : WebAppData?

    # Optional. Inline keyboard attached to the message. login_url buttons are represented as ordinary url buttons.
    @[JSON::Field(key: "reply_markup")]
    property reply_markup : InlineKeyboardMarkup?

  end

  # Telegram API type: MessageId
  # This object represents a unique message identifier.
  struct MessageId
    include JSON::Serializable

    # Unique message identifier. In specific instances (e.g., message containing a video sent to a big chat), the server might automatically schedule a message instead of sending it immediately. In such cases, this field will be 0 and the relevant message will be unusable until it is actually sent
    @[JSON::Field(key: "message_id")]
    property message_id : Int32

  end

  # Telegram API type: InaccessibleMessage
  # This object describes a message that was deleted or is otherwise inaccessible to the bot.
  struct InaccessibleMessage
    include JSON::Serializable

    # Chat the message belonged to
    @[JSON::Field(key: "chat")]
    property chat : Chat

    # Unique message identifier inside the chat
    @[JSON::Field(key: "message_id")]
    property message_id : Int32

    # Always 0. The field can be used to differentiate regular and inaccessible messages.
    @[JSON::Field(key: "date")]
    property date : Int32

  end

  # Telegram API type: MaybeInaccessibleMessage
  # This object describes a message that can be inaccessible to the bot. It can be one of
  # - Message
  # - InaccessibleMessage
  struct MaybeInaccessibleMessage
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: MessageEntity
  # This object represents one special entity in a text message. For example, hashtags, usernames, URLs, etc.
  struct MessageEntity
    include JSON::Serializable

    # Type of the entity. Currently, can be "mention" (@username), "hashtag" (#hashtag or #hashtag@chatusername), "cashtag" ($USD or $USD@chatusername), "bot_command" (/start@jobs_bot), "url" (https://telegram.org), "email" (do-not-reply@telegram.org), "phone_number" (+1-212-555-0123), "bold" (bold text), "italic" (italic text), "underline" (underlined text), "strikethrough" (strikethrough text), "spoiler" (spoiler message), "blockquote" (block quotation), "expandable_blockquote" (collapsed-by-default block quotation), "code" (monowidth string), "pre" (monowidth block), "text_link" (for clickable text URLs), "text_mention" (for users without usernames), "custom_emoji" (for inline custom emoji stickers)
    @[JSON::Field(key: "type")]
    property type : String

    # Offset in UTF-16 code units to the start of the entity
    @[JSON::Field(key: "offset")]
    property offset : Int32

    # Length of the entity in UTF-16 code units
    @[JSON::Field(key: "length")]
    property length : Int32

    # Optional. For "text_link" only, URL that will be opened after user taps on the text
    @[JSON::Field(key: "url")]
    property url : String?

    # Optional. For "text_mention" only, the mentioned user
    @[JSON::Field(key: "user")]
    property user : User?

    # Optional. For "pre" only, the programming language of the entity text
    @[JSON::Field(key: "language")]
    property language : String?

    # Optional. For "custom_emoji" only, unique identifier of the custom emoji. Use getCustomEmojiStickers to get full information about the sticker
    @[JSON::Field(key: "custom_emoji_id")]
    property custom_emoji_id : String?

  end

  # Telegram API type: TextQuote
  # This object contains information about the quoted part of a message that is replied to by the given message.
  struct TextQuote
    include JSON::Serializable

    # Text of the quoted part of a message that is replied to by the given message
    @[JSON::Field(key: "text")]
    property text : String

    # Optional. Special entities that appear in the quote. Currently, only bold, italic, underline, strikethrough, spoiler, and custom_emoji entities are kept in quotes.
    @[JSON::Field(key: "entities")]
    property entities : Array(MessageEntity)?

    # Approximate quote position in the original message in UTF-16 code units as specified by the sender
    @[JSON::Field(key: "position")]
    property position : Int32

    # Optional. True, if the quote was chosen manually by the message sender. Otherwise, the quote was added automatically by the server.
    @[JSON::Field(key: "is_manual")]
    property is_manual : Bool?

  end

  # Telegram API type: ExternalReplyInfo
  # This object contains information about a message that is being replied to, which may come from another chat or forum topic.
  struct ExternalReplyInfo
    include JSON::Serializable

    # Origin of the message replied to by the given message
    @[JSON::Field(key: "origin")]
    property origin : MessageOrigin

    # Optional. Chat the original message belongs to. Available only if the chat is a supergroup or a channel.
    @[JSON::Field(key: "chat")]
    property chat : Chat?

    # Optional. Unique message identifier inside the original chat. Available only if the original chat is a supergroup or a channel.
    @[JSON::Field(key: "message_id")]
    property message_id : Int32?

    # Optional. Options used for link preview generation for the original message, if it is a text message
    @[JSON::Field(key: "link_preview_options")]
    property link_preview_options : LinkPreviewOptions?

    # Optional. Message is an animation, information about the animation
    @[JSON::Field(key: "animation")]
    property animation : Animation?

    # Optional. Message is an audio file, information about the file
    @[JSON::Field(key: "audio")]
    property audio : Audio?

    # Optional. Message is a general file, information about the file
    @[JSON::Field(key: "document")]
    property document : Document?

    # Optional. Message contains paid media; information about the paid media
    @[JSON::Field(key: "paid_media")]
    property paid_media : PaidMediaInfo?

    # Optional. Message is a photo, available sizes of the photo
    @[JSON::Field(key: "photo")]
    property photo : Array(PhotoSize)?

    # Optional. Message is a sticker, information about the sticker
    @[JSON::Field(key: "sticker")]
    property sticker : Sticker?

    # Optional. Message is a forwarded story
    @[JSON::Field(key: "story")]
    property story : Story?

    # Optional. Message is a video, information about the video
    @[JSON::Field(key: "video")]
    property video : Video?

    # Optional. Message is a video note, information about the video message
    @[JSON::Field(key: "video_note")]
    property video_note : VideoNote?

    # Optional. Message is a voice message, information about the file
    @[JSON::Field(key: "voice")]
    property voice : Voice?

    # Optional. True, if the message media is covered by a spoiler animation
    @[JSON::Field(key: "has_media_spoiler")]
    property has_media_spoiler : Bool?

    # Optional. Message is a checklist
    @[JSON::Field(key: "checklist")]
    property checklist : Checklist?

    # Optional. Message is a shared contact, information about the contact
    @[JSON::Field(key: "contact")]
    property contact : Contact?

    # Optional. Message is a dice with random value
    @[JSON::Field(key: "dice")]
    property dice : Dice?

    # Optional. Message is a game, information about the game. More about games: https://core.telegram.org/bots/api#games
    @[JSON::Field(key: "game")]
    property game : Game?

    # Optional. Message is a scheduled giveaway, information about the giveaway
    @[JSON::Field(key: "giveaway")]
    property giveaway : Giveaway?

    # Optional. A giveaway with public winners was completed
    @[JSON::Field(key: "giveaway_winners")]
    property giveaway_winners : GiveawayWinners?

    # Optional. Message is an invoice for a payment, information about the invoice. More about payments: https://core.telegram.org/bots/api#payments
    @[JSON::Field(key: "invoice")]
    property invoice : Invoice?

    # Optional. Message is a shared location, information about the location
    @[JSON::Field(key: "location")]
    property location : Location?

    # Optional. Message is a native poll, information about the poll
    @[JSON::Field(key: "poll")]
    property poll : Poll?

    # Optional. Message is a venue, information about the venue
    @[JSON::Field(key: "venue")]
    property venue : Venue?

  end

  # Telegram API type: ReplyParameters
  # Describes reply parameters for the message that is being sent.
  struct ReplyParameters
    include JSON::Serializable

    # Identifier of the message that will be replied to in the current chat, or in the chat chat_id if it is specified
    @[JSON::Field(key: "message_id")]
    property message_id : Int32

    # Optional. If the message to be replied to is from a different chat, unique identifier for the chat or username of the channel (in the format @channelusername). Not supported for messages sent on behalf of a business account and messages from channel direct messages chats.
    @[JSON::Field(key: "chat_id")]
    property chat_id : Int32 | String?

    # Optional. Pass True if the message should be sent even if the specified message to be replied to is not found. Always False for replies in another chat or forum topic. Always True for messages sent on behalf of a business account.
    @[JSON::Field(key: "allow_sending_without_reply")]
    property allow_sending_without_reply : Bool?

    # Optional. Quoted part of the message to be replied to; 0-1024 characters after entities parsing. The quote must be an exact substring of the message to be replied to, including bold, italic, underline, strikethrough, spoiler, and custom_emoji entities. The message will fail to send if the quote isn't found in the original message.
    @[JSON::Field(key: "quote")]
    property quote : String?

    # Optional. Mode for parsing entities in the quote. See formatting options for more details.
    @[JSON::Field(key: "quote_parse_mode")]
    property quote_parse_mode : String?

    # Optional. A JSON-serialized list of special entities that appear in the quote. It can be specified instead of quote_parse_mode.
    @[JSON::Field(key: "quote_entities")]
    property quote_entities : Array(MessageEntity)?

    # Optional. Position of the quote in the original message in UTF-16 code units
    @[JSON::Field(key: "quote_position")]
    property quote_position : Int32?

    # Optional. Identifier of the specific checklist task to be replied to
    @[JSON::Field(key: "checklist_task_id")]
    property checklist_task_id : Int32?

  end

  # Telegram API type: MessageOrigin
  # This object describes the origin of a message. It can be one of
  # - MessageOriginUser
  # - MessageOriginHiddenUser
  # - MessageOriginChat
  # - MessageOriginChannel
  struct MessageOrigin
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: MessageOriginUser
  # The message was originally sent by a known user.
  struct MessageOriginUser
    include JSON::Serializable

    # Type of the message origin, always "user"
    @[JSON::Field(key: "type")]
    property type : String

    # Date the message was sent originally in Unix time
    @[JSON::Field(key: "date")]
    property date : Int32

    # User that sent the message originally
    @[JSON::Field(key: "sender_user")]
    property sender_user : User

  end

  # Telegram API type: MessageOriginHiddenUser
  # The message was originally sent by an unknown user.
  struct MessageOriginHiddenUser
    include JSON::Serializable

    # Type of the message origin, always "hidden_user"
    @[JSON::Field(key: "type")]
    property type : String

    # Date the message was sent originally in Unix time
    @[JSON::Field(key: "date")]
    property date : Int32

    # Name of the user that sent the message originally
    @[JSON::Field(key: "sender_user_name")]
    property sender_user_name : String

  end

  # Telegram API type: MessageOriginChat
  # The message was originally sent on behalf of a chat to a group chat.
  struct MessageOriginChat
    include JSON::Serializable

    # Type of the message origin, always "chat"
    @[JSON::Field(key: "type")]
    property type : String

    # Date the message was sent originally in Unix time
    @[JSON::Field(key: "date")]
    property date : Int32

    # Chat that sent the message originally
    @[JSON::Field(key: "sender_chat")]
    property sender_chat : Chat

    # Optional. For messages originally sent by an anonymous chat administrator, original message author signature
    @[JSON::Field(key: "author_signature")]
    property author_signature : String?

  end

  # Telegram API type: MessageOriginChannel
  # The message was originally sent to a channel chat.
  struct MessageOriginChannel
    include JSON::Serializable

    # Type of the message origin, always "channel"
    @[JSON::Field(key: "type")]
    property type : String

    # Date the message was sent originally in Unix time
    @[JSON::Field(key: "date")]
    property date : Int32

    # Channel chat to which the message was originally sent
    @[JSON::Field(key: "chat")]
    property chat : Chat

    # Unique message identifier inside the chat
    @[JSON::Field(key: "message_id")]
    property message_id : Int32

    # Optional. Signature of the original post author
    @[JSON::Field(key: "author_signature")]
    property author_signature : String?

  end

  # Telegram API type: PhotoSize
  # This object represents one size of a photo or a file / sticker thumbnail.
  struct PhotoSize
    include JSON::Serializable

    # Identifier for this file, which can be used to download or reuse the file
    @[JSON::Field(key: "file_id")]
    property file_id : String

    # Unique identifier for this file, which is supposed to be the same over time and for different bots. Can't be used to download or reuse the file.
    @[JSON::Field(key: "file_unique_id")]
    property file_unique_id : String

    # Photo width
    @[JSON::Field(key: "width")]
    property width : Int32

    # Photo height
    @[JSON::Field(key: "height")]
    property height : Int32

    # Optional. File size in bytes
    @[JSON::Field(key: "file_size")]
    property file_size : Int32?

  end

  # Telegram API type: Animation
  # This object represents an animation file (GIF or H.264/MPEG-4 AVC video without sound).
  struct Animation
    include JSON::Serializable

    # Identifier for this file, which can be used to download or reuse the file
    @[JSON::Field(key: "file_id")]
    property file_id : String

    # Unique identifier for this file, which is supposed to be the same over time and for different bots. Can't be used to download or reuse the file.
    @[JSON::Field(key: "file_unique_id")]
    property file_unique_id : String

    # Video width as defined by the sender
    @[JSON::Field(key: "width")]
    property width : Int32

    # Video height as defined by the sender
    @[JSON::Field(key: "height")]
    property height : Int32

    # Duration of the video in seconds as defined by the sender
    @[JSON::Field(key: "duration")]
    property duration : Int32

    # Optional. Animation thumbnail as defined by the sender
    @[JSON::Field(key: "thumbnail")]
    property thumbnail : PhotoSize?

    # Optional. Original animation filename as defined by the sender
    @[JSON::Field(key: "file_name")]
    property file_name : String?

    # Optional. MIME type of the file as defined by the sender
    @[JSON::Field(key: "mime_type")]
    property mime_type : String?

    # Optional. File size in bytes. It can be bigger than 2^31 and some programming languages may have difficulty/silent defects in interpreting it. But it has at most 52 significant bits, so a signed 64-bit integer or double-precision float type are safe for storing this value.
    @[JSON::Field(key: "file_size")]
    property file_size : Int32?

  end

  # Telegram API type: Audio
  # This object represents an audio file to be treated as music by the Telegram clients.
  struct Audio
    include JSON::Serializable

    # Identifier for this file, which can be used to download or reuse the file
    @[JSON::Field(key: "file_id")]
    property file_id : String

    # Unique identifier for this file, which is supposed to be the same over time and for different bots. Can't be used to download or reuse the file.
    @[JSON::Field(key: "file_unique_id")]
    property file_unique_id : String

    # Duration of the audio in seconds as defined by the sender
    @[JSON::Field(key: "duration")]
    property duration : Int32

    # Optional. Performer of the audio as defined by the sender or by audio tags
    @[JSON::Field(key: "performer")]
    property performer : String?

    # Optional. Title of the audio as defined by the sender or by audio tags
    @[JSON::Field(key: "title")]
    property title : String?

    # Optional. Original filename as defined by the sender
    @[JSON::Field(key: "file_name")]
    property file_name : String?

    # Optional. MIME type of the file as defined by the sender
    @[JSON::Field(key: "mime_type")]
    property mime_type : String?

    # Optional. File size in bytes. It can be bigger than 2^31 and some programming languages may have difficulty/silent defects in interpreting it. But it has at most 52 significant bits, so a signed 64-bit integer or double-precision float type are safe for storing this value.
    @[JSON::Field(key: "file_size")]
    property file_size : Int32?

    # Optional. Thumbnail of the album cover to which the music file belongs
    @[JSON::Field(key: "thumbnail")]
    property thumbnail : PhotoSize?

  end

  # Telegram API type: Document
  # This object represents a general file (as opposed to photos, voice messages and audio files).
  struct Document
    include JSON::Serializable

    # Identifier for this file, which can be used to download or reuse the file
    @[JSON::Field(key: "file_id")]
    property file_id : String

    # Unique identifier for this file, which is supposed to be the same over time and for different bots. Can't be used to download or reuse the file.
    @[JSON::Field(key: "file_unique_id")]
    property file_unique_id : String

    # Optional. Document thumbnail as defined by the sender
    @[JSON::Field(key: "thumbnail")]
    property thumbnail : PhotoSize?

    # Optional. Original filename as defined by the sender
    @[JSON::Field(key: "file_name")]
    property file_name : String?

    # Optional. MIME type of the file as defined by the sender
    @[JSON::Field(key: "mime_type")]
    property mime_type : String?

    # Optional. File size in bytes. It can be bigger than 2^31 and some programming languages may have difficulty/silent defects in interpreting it. But it has at most 52 significant bits, so a signed 64-bit integer or double-precision float type are safe for storing this value.
    @[JSON::Field(key: "file_size")]
    property file_size : Int32?

  end

  # Telegram API type: Story
  # This object represents a story.
  struct Story
    include JSON::Serializable

    # Chat that posted the story
    @[JSON::Field(key: "chat")]
    property chat : Chat

    # Unique identifier for the story in the chat
    @[JSON::Field(key: "id")]
    property id : Int32

  end

  # Telegram API type: Video
  # This object represents a video file.
  struct Video
    include JSON::Serializable

    # Identifier for this file, which can be used to download or reuse the file
    @[JSON::Field(key: "file_id")]
    property file_id : String

    # Unique identifier for this file, which is supposed to be the same over time and for different bots. Can't be used to download or reuse the file.
    @[JSON::Field(key: "file_unique_id")]
    property file_unique_id : String

    # Video width as defined by the sender
    @[JSON::Field(key: "width")]
    property width : Int32

    # Video height as defined by the sender
    @[JSON::Field(key: "height")]
    property height : Int32

    # Duration of the video in seconds as defined by the sender
    @[JSON::Field(key: "duration")]
    property duration : Int32

    # Optional. Video thumbnail
    @[JSON::Field(key: "thumbnail")]
    property thumbnail : PhotoSize?

    # Optional. Available sizes of the cover of the video in the message
    @[JSON::Field(key: "cover")]
    property cover : Array(PhotoSize)?

    # Optional. Timestamp in seconds from which the video will play in the message
    @[JSON::Field(key: "start_timestamp")]
    property start_timestamp : Int32?

    # Optional. Original filename as defined by the sender
    @[JSON::Field(key: "file_name")]
    property file_name : String?

    # Optional. MIME type of the file as defined by the sender
    @[JSON::Field(key: "mime_type")]
    property mime_type : String?

    # Optional. File size in bytes. It can be bigger than 2^31 and some programming languages may have difficulty/silent defects in interpreting it. But it has at most 52 significant bits, so a signed 64-bit integer or double-precision float type are safe for storing this value.
    @[JSON::Field(key: "file_size")]
    property file_size : Int32?

  end

  # Telegram API type: VideoNote
  # This object represents a video message (available in Telegram apps as of v.4.0).
  struct VideoNote
    include JSON::Serializable

    # Identifier for this file, which can be used to download or reuse the file
    @[JSON::Field(key: "file_id")]
    property file_id : String

    # Unique identifier for this file, which is supposed to be the same over time and for different bots. Can't be used to download or reuse the file.
    @[JSON::Field(key: "file_unique_id")]
    property file_unique_id : String

    # Video width and height (diameter of the video message) as defined by the sender
    @[JSON::Field(key: "length")]
    property length : Int32

    # Duration of the video in seconds as defined by the sender
    @[JSON::Field(key: "duration")]
    property duration : Int32

    # Optional. Video thumbnail
    @[JSON::Field(key: "thumbnail")]
    property thumbnail : PhotoSize?

    # Optional. File size in bytes
    @[JSON::Field(key: "file_size")]
    property file_size : Int32?

  end

  # Telegram API type: Voice
  # This object represents a voice note.
  struct Voice
    include JSON::Serializable

    # Identifier for this file, which can be used to download or reuse the file
    @[JSON::Field(key: "file_id")]
    property file_id : String

    # Unique identifier for this file, which is supposed to be the same over time and for different bots. Can't be used to download or reuse the file.
    @[JSON::Field(key: "file_unique_id")]
    property file_unique_id : String

    # Duration of the audio in seconds as defined by the sender
    @[JSON::Field(key: "duration")]
    property duration : Int32

    # Optional. MIME type of the file as defined by the sender
    @[JSON::Field(key: "mime_type")]
    property mime_type : String?

    # Optional. File size in bytes. It can be bigger than 2^31 and some programming languages may have difficulty/silent defects in interpreting it. But it has at most 52 significant bits, so a signed 64-bit integer or double-precision float type are safe for storing this value.
    @[JSON::Field(key: "file_size")]
    property file_size : Int32?

  end

  # Telegram API type: PaidMediaInfo
  # Describes the paid media added to a message.
  struct PaidMediaInfo
    include JSON::Serializable

    # The number of Telegram Stars that must be paid to buy access to the media
    @[JSON::Field(key: "star_count")]
    property star_count : Int32

    # Information about the paid media
    @[JSON::Field(key: "paid_media")]
    property paid_media : Array(PaidMedia)

  end

  # Telegram API type: PaidMedia
  # This object describes paid media. Currently, it can be one of
  # - PaidMediaPreview
  # - PaidMediaPhoto
  # - PaidMediaVideo
  struct PaidMedia
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: PaidMediaPreview
  # The paid media isn't available before the payment.
  struct PaidMediaPreview
    include JSON::Serializable

    # Type of the paid media, always "preview"
    @[JSON::Field(key: "type")]
    property type : String

    # Optional. Media width as defined by the sender
    @[JSON::Field(key: "width")]
    property width : Int32?

    # Optional. Media height as defined by the sender
    @[JSON::Field(key: "height")]
    property height : Int32?

    # Optional. Duration of the media in seconds as defined by the sender
    @[JSON::Field(key: "duration")]
    property duration : Int32?

  end

  # Telegram API type: PaidMediaPhoto
  # The paid media is a photo.
  struct PaidMediaPhoto
    include JSON::Serializable

    # Type of the paid media, always "photo"
    @[JSON::Field(key: "type")]
    property type : String

    # The photo
    @[JSON::Field(key: "photo")]
    property photo : Array(PhotoSize)

  end

  # Telegram API type: PaidMediaVideo
  # The paid media is a video.
  struct PaidMediaVideo
    include JSON::Serializable

    # Type of the paid media, always "video"
    @[JSON::Field(key: "type")]
    property type : String

    # The video
    @[JSON::Field(key: "video")]
    property video : Video

  end

  # Telegram API type: Contact
  # This object represents a phone contact.
  struct Contact
    include JSON::Serializable

    # Contact's phone number
    @[JSON::Field(key: "phone_number")]
    property phone_number : String

    # Contact's first name
    @[JSON::Field(key: "first_name")]
    property first_name : String

    # Optional. Contact's last name
    @[JSON::Field(key: "last_name")]
    property last_name : String?

    # Optional. Contact's user identifier in Telegram. This number may have more than 32 significant bits and some programming languages may have difficulty/silent defects in interpreting it. But it has at most 52 significant bits, so a 64-bit integer or double-precision float type are safe for storing this identifier.
    @[JSON::Field(key: "user_id")]
    property user_id : Int32?

    # Optional. Additional data about the contact in the form of a vCard
    @[JSON::Field(key: "vcard")]
    property vcard : String?

  end

  # Telegram API type: Dice
  # This object represents an animated emoji that displays a random value.
  struct Dice
    include JSON::Serializable

    # Emoji on which the dice throw animation is based
    @[JSON::Field(key: "emoji")]
    property emoji : String

    # Value of the dice, 1-6 for "🎲", "🎯" and "🎳" base emoji, 1-5 for "🏀" and "⚽" base emoji, 1-64 for "🎰" base emoji
    @[JSON::Field(key: "value")]
    property value : Int32

  end

  # Telegram API type: PollOption
  # This object contains information about one answer option in a poll.
  struct PollOption
    include JSON::Serializable

    # Option text, 1-100 characters
    @[JSON::Field(key: "text")]
    property text : String

    # Optional. Special entities that appear in the option text. Currently, only custom emoji entities are allowed in poll option texts
    @[JSON::Field(key: "text_entities")]
    property text_entities : Array(MessageEntity)?

    # Number of users that voted for this option
    @[JSON::Field(key: "voter_count")]
    property voter_count : Int32

  end

  # Telegram API type: InputPollOption
  # This object contains information about one answer option in a poll to be sent.
  struct InputPollOption
    include JSON::Serializable

    # Option text, 1-100 characters
    @[JSON::Field(key: "text")]
    property text : String

    # Optional. Mode for parsing entities in the text. See formatting options for more details. Currently, only custom emoji entities are allowed
    @[JSON::Field(key: "text_parse_mode")]
    property text_parse_mode : String?

    # Optional. A JSON-serialized list of special entities that appear in the poll option text. It can be specified instead of text_parse_mode
    @[JSON::Field(key: "text_entities")]
    property text_entities : Array(MessageEntity)?

  end

  # Telegram API type: PollAnswer
  # This object represents an answer of a user in a non-anonymous poll.
  struct PollAnswer
    include JSON::Serializable

    # Unique poll identifier
    @[JSON::Field(key: "poll_id")]
    property poll_id : String

    # Optional. The chat that changed the answer to the poll, if the voter is anonymous
    @[JSON::Field(key: "voter_chat")]
    property voter_chat : Chat?

    # Optional. The user that changed the answer to the poll, if the voter isn't anonymous
    @[JSON::Field(key: "user")]
    property user : User?

    # 0-based identifiers of chosen answer options. May be empty if the vote was retracted.
    @[JSON::Field(key: "option_ids")]
    property option_ids : Array(Int32)

  end

  # Telegram API type: Poll
  # This object contains information about a poll.
  class Poll
    include JSON::Serializable

    # Unique poll identifier
    @[JSON::Field(key: "id")]
    property id : String

    # Poll question, 1-300 characters
    @[JSON::Field(key: "question")]
    property question : String

    # Optional. Special entities that appear in the question. Currently, only custom emoji entities are allowed in poll questions
    @[JSON::Field(key: "question_entities")]
    property question_entities : Array(MessageEntity)?

    # List of poll options
    @[JSON::Field(key: "options")]
    property options : Array(PollOption)

    # Total number of users that voted in the poll
    @[JSON::Field(key: "total_voter_count")]
    property total_voter_count : Int32

    # True, if the poll is closed
    @[JSON::Field(key: "is_closed")]
    property is_closed : Bool

    # True, if the poll is anonymous
    @[JSON::Field(key: "is_anonymous")]
    property is_anonymous : Bool

    # Poll type, currently can be "regular" or "quiz"
    @[JSON::Field(key: "type")]
    property type : String

    # True, if the poll allows multiple answers
    @[JSON::Field(key: "allows_multiple_answers")]
    property allows_multiple_answers : Bool

    # Optional. 0-based identifier of the correct answer option. Available only for polls in the quiz mode, which are closed, or was sent (not forwarded) by the bot or to the private chat with the bot.
    @[JSON::Field(key: "correct_option_id")]
    property correct_option_id : Int32?

    # Optional. Text that is shown when a user chooses an incorrect answer or taps on the lamp icon in a quiz-style poll, 0-200 characters
    @[JSON::Field(key: "explanation")]
    property explanation : String?

    # Optional. Special entities like usernames, URLs, bot commands, etc. that appear in the explanation
    @[JSON::Field(key: "explanation_entities")]
    property explanation_entities : Array(MessageEntity)?

    # Optional. Amount of time in seconds the poll will be active after creation
    @[JSON::Field(key: "open_period")]
    property open_period : Int32?

    # Optional. Point in time (Unix timestamp) when the poll will be automatically closed
    @[JSON::Field(key: "close_date")]
    property close_date : Int32?

  end

  # Telegram API type: ChecklistTask
  # Describes a task in a checklist.
  struct ChecklistTask
    include JSON::Serializable

    # Unique identifier of the task
    @[JSON::Field(key: "id")]
    property id : Int32

    # Text of the task
    @[JSON::Field(key: "text")]
    property text : String

    # Optional. Special entities that appear in the task text
    @[JSON::Field(key: "text_entities")]
    property text_entities : Array(MessageEntity)?

    # Optional. User that completed the task; omitted if the task wasn't completed
    @[JSON::Field(key: "completed_by_user")]
    property completed_by_user : User?

    # Optional. Point in time (Unix timestamp) when the task was completed; 0 if the task wasn't completed
    @[JSON::Field(key: "completion_date")]
    property completion_date : Int32?

  end

  # Telegram API type: Checklist
  # Describes a checklist.
  struct Checklist
    include JSON::Serializable

    # Title of the checklist
    @[JSON::Field(key: "title")]
    property title : String

    # Optional. Special entities that appear in the checklist title
    @[JSON::Field(key: "title_entities")]
    property title_entities : Array(MessageEntity)?

    # List of tasks in the checklist
    @[JSON::Field(key: "tasks")]
    property tasks : Array(ChecklistTask)

    # Optional. True, if users other than the creator of the list can add tasks to the list
    @[JSON::Field(key: "others_can_add_tasks")]
    property others_can_add_tasks : Bool?

    # Optional. True, if users other than the creator of the list can mark tasks as done or not done
    @[JSON::Field(key: "others_can_mark_tasks_as_done")]
    property others_can_mark_tasks_as_done : Bool?

  end

  # Telegram API type: InputChecklistTask
  # Describes a task to add to a checklist.
  struct InputChecklistTask
    include JSON::Serializable

    # Unique identifier of the task; must be positive and unique among all task identifiers currently present in the checklist
    @[JSON::Field(key: "id")]
    property id : Int32

    # Text of the task; 1-100 characters after entities parsing
    @[JSON::Field(key: "text")]
    property text : String

    # Optional. Mode for parsing entities in the text. See formatting options for more details.
    @[JSON::Field(key: "parse_mode")]
    property parse_mode : String?

    # Optional. List of special entities that appear in the text, which can be specified instead of parse_mode. Currently, only bold, italic, underline, strikethrough, spoiler, and custom_emoji entities are allowed.
    @[JSON::Field(key: "text_entities")]
    property text_entities : Array(MessageEntity)?

  end

  # Telegram API type: InputChecklist
  # Describes a checklist to create.
  struct InputChecklist
    include JSON::Serializable

    # Title of the checklist; 1-255 characters after entities parsing
    @[JSON::Field(key: "title")]
    property title : String

    # Optional. Mode for parsing entities in the title. See formatting options for more details.
    @[JSON::Field(key: "parse_mode")]
    property parse_mode : String?

    # Optional. List of special entities that appear in the title, which can be specified instead of parse_mode. Currently, only bold, italic, underline, strikethrough, spoiler, and custom_emoji entities are allowed.
    @[JSON::Field(key: "title_entities")]
    property title_entities : Array(MessageEntity)?

    # List of 1-30 tasks in the checklist
    @[JSON::Field(key: "tasks")]
    property tasks : Array(InputChecklistTask)

    # Optional. Pass True if other users can add tasks to the checklist
    @[JSON::Field(key: "others_can_add_tasks")]
    property others_can_add_tasks : Bool?

    # Optional. Pass True if other users can mark tasks as done or not done in the checklist
    @[JSON::Field(key: "others_can_mark_tasks_as_done")]
    property others_can_mark_tasks_as_done : Bool?

  end

  # Telegram API type: ChecklistTasksDone
  # Describes a service message about checklist tasks marked as done or not done.
  struct ChecklistTasksDone
    include JSON::Serializable

    # Optional. Message containing the checklist whose tasks were marked as done or not done. Note that the Message object in this field will not contain the reply_to_message field even if it itself is a reply.
    @[JSON::Field(key: "checklist_message")]
    property checklist_message : Message?

    # Optional. Identifiers of the tasks that were marked as done
    @[JSON::Field(key: "marked_as_done_task_ids")]
    property marked_as_done_task_ids : Array(Int32)?

    # Optional. Identifiers of the tasks that were marked as not done
    @[JSON::Field(key: "marked_as_not_done_task_ids")]
    property marked_as_not_done_task_ids : Array(Int32)?

  end

  # Telegram API type: ChecklistTasksAdded
  # Describes a service message about tasks added to a checklist.
  struct ChecklistTasksAdded
    include JSON::Serializable

    # Optional. Message containing the checklist to which the tasks were added. Note that the Message object in this field will not contain the reply_to_message field even if it itself is a reply.
    @[JSON::Field(key: "checklist_message")]
    property checklist_message : Message?

    # List of tasks added to the checklist
    @[JSON::Field(key: "tasks")]
    property tasks : Array(ChecklistTask)

  end

  # Telegram API type: Location
  # This object represents a point on the map.
  struct Location
    include JSON::Serializable

    # Latitude as defined by the sender
    @[JSON::Field(key: "latitude")]
    property latitude : Float64

    # Longitude as defined by the sender
    @[JSON::Field(key: "longitude")]
    property longitude : Float64

    # Optional. The radius of uncertainty for the location, measured in meters; 0-1500
    @[JSON::Field(key: "horizontal_accuracy")]
    property horizontal_accuracy : Float64?

    # Optional. Time relative to the message sending date, during which the location can be updated; in seconds. For active live locations only.
    @[JSON::Field(key: "live_period")]
    property live_period : Int32?

    # Optional. The direction in which user is moving, in degrees; 1-360. For active live locations only.
    @[JSON::Field(key: "heading")]
    property heading : Int32?

    # Optional. The maximum distance for proximity alerts about approaching another chat member, in meters. For sent live locations only.
    @[JSON::Field(key: "proximity_alert_radius")]
    property proximity_alert_radius : Int32?

  end

  # Telegram API type: Venue
  # This object represents a venue.
  struct Venue
    include JSON::Serializable

    # Venue location. Can't be a live location
    @[JSON::Field(key: "location")]
    property location : Location

    # Name of the venue
    @[JSON::Field(key: "title")]
    property title : String

    # Address of the venue
    @[JSON::Field(key: "address")]
    property address : String

    # Optional. Foursquare identifier of the venue
    @[JSON::Field(key: "foursquare_id")]
    property foursquare_id : String?

    # Optional. Foursquare type of the venue. (For example, "arts_entertainment/default", "arts_entertainment/aquarium" or "food/icecream".)
    @[JSON::Field(key: "foursquare_type")]
    property foursquare_type : String?

    # Optional. Google Places identifier of the venue
    @[JSON::Field(key: "google_place_id")]
    property google_place_id : String?

    # Optional. Google Places type of the venue. (See supported types.)
    @[JSON::Field(key: "google_place_type")]
    property google_place_type : String?

  end

  # Telegram API type: WebAppData
  # Describes data sent from a Web App to the bot.
  struct WebAppData
    include JSON::Serializable

    # The data. Be aware that a bad client can send arbitrary data in this field.
    @[JSON::Field(key: "data")]
    property data : String

    # Text of the web_app keyboard button from which the Web App was opened. Be aware that a bad client can send arbitrary data in this field.
    @[JSON::Field(key: "button_text")]
    property button_text : String

  end

  # Telegram API type: ProximityAlertTriggered
  # This object represents the content of a service message, sent whenever a user in the chat triggers a proximity alert set by another user.
  struct ProximityAlertTriggered
    include JSON::Serializable

    # User that triggered the alert
    @[JSON::Field(key: "traveler")]
    property traveler : User

    # User that set the alert
    @[JSON::Field(key: "watcher")]
    property watcher : User

    # The distance between the users
    @[JSON::Field(key: "distance")]
    property distance : Int32

  end

  # Telegram API type: MessageAutoDeleteTimerChanged
  # This object represents a service message about a change in auto-delete timer settings.
  struct MessageAutoDeleteTimerChanged
    include JSON::Serializable

    # New auto-delete time for messages in the chat; in seconds
    @[JSON::Field(key: "message_auto_delete_time")]
    property message_auto_delete_time : Int32

  end

  # Telegram API type: ChatBoostAdded
  # This object represents a service message about a user boosting a chat.
  struct ChatBoostAdded
    include JSON::Serializable

    # Number of boosts added by the user
    @[JSON::Field(key: "boost_count")]
    property boost_count : Int32

  end

  # Telegram API type: BackgroundFill
  # This object describes the way a background is filled based on the selected colors. Currently, it can be one of
  # - BackgroundFillSolid
  # - BackgroundFillGradient
  # - BackgroundFillFreeformGradient
  struct BackgroundFill
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: BackgroundFillSolid
  # The background is filled using the selected color.
  struct BackgroundFillSolid
    include JSON::Serializable

    # Type of the background fill, always "solid"
    @[JSON::Field(key: "type")]
    property type : String

    # The color of the background fill in the RGB24 format
    @[JSON::Field(key: "color")]
    property color : Int32

  end

  # Telegram API type: BackgroundFillGradient
  # The background is a gradient fill.
  struct BackgroundFillGradient
    include JSON::Serializable

    # Type of the background fill, always "gradient"
    @[JSON::Field(key: "type")]
    property type : String

    # Top color of the gradient in the RGB24 format
    @[JSON::Field(key: "top_color")]
    property top_color : Int32

    # Bottom color of the gradient in the RGB24 format
    @[JSON::Field(key: "bottom_color")]
    property bottom_color : Int32

    # Clockwise rotation angle of the background fill in degrees; 0-359
    @[JSON::Field(key: "rotation_angle")]
    property rotation_angle : Int32

  end

  # Telegram API type: BackgroundFillFreeformGradient
  # The background is a freeform gradient that rotates after every message in the chat.
  struct BackgroundFillFreeformGradient
    include JSON::Serializable

    # Type of the background fill, always "freeform_gradient"
    @[JSON::Field(key: "type")]
    property type : String

    # A list of the 3 or 4 base colors that are used to generate the freeform gradient in the RGB24 format
    @[JSON::Field(key: "colors")]
    property colors : Array(Int32)

  end

  # Telegram API type: BackgroundType
  # This object describes the type of a background. Currently, it can be one of
  # - BackgroundTypeFill
  # - BackgroundTypeWallpaper
  # - BackgroundTypePattern
  # - BackgroundTypeChatTheme
  struct BackgroundType
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: BackgroundTypeFill
  # The background is automatically filled based on the selected colors.
  struct BackgroundTypeFill
    include JSON::Serializable

    # Type of the background, always "fill"
    @[JSON::Field(key: "type")]
    property type : String

    # The background fill
    @[JSON::Field(key: "fill")]
    property fill : BackgroundFill

    # Dimming of the background in dark themes, as a percentage; 0-100
    @[JSON::Field(key: "dark_theme_dimming")]
    property dark_theme_dimming : Int32

  end

  # Telegram API type: BackgroundTypeWallpaper
  # The background is a wallpaper in the JPEG format.
  struct BackgroundTypeWallpaper
    include JSON::Serializable

    # Type of the background, always "wallpaper"
    @[JSON::Field(key: "type")]
    property type : String

    # Document with the wallpaper
    @[JSON::Field(key: "document")]
    property document : Document

    # Dimming of the background in dark themes, as a percentage; 0-100
    @[JSON::Field(key: "dark_theme_dimming")]
    property dark_theme_dimming : Int32

    # Optional. True, if the wallpaper is downscaled to fit in a 450x450 square and then box-blurred with radius 12
    @[JSON::Field(key: "is_blurred")]
    property is_blurred : Bool?

    # Optional. True, if the background moves slightly when the device is tilted
    @[JSON::Field(key: "is_moving")]
    property is_moving : Bool?

  end

  # Telegram API type: BackgroundTypePattern
  # The background is a .PNG or .TGV (gzipped subset of SVG with MIME type "application/x-tgwallpattern") pattern to be combined with the background fill chosen by the user.
  struct BackgroundTypePattern
    include JSON::Serializable

    # Type of the background, always "pattern"
    @[JSON::Field(key: "type")]
    property type : String

    # Document with the pattern
    @[JSON::Field(key: "document")]
    property document : Document

    # The background fill that is combined with the pattern
    @[JSON::Field(key: "fill")]
    property fill : BackgroundFill

    # Intensity of the pattern when it is shown above the filled background; 0-100
    @[JSON::Field(key: "intensity")]
    property intensity : Int32

    # Optional. True, if the background fill must be applied only to the pattern itself. All other pixels are black in this case. For dark themes only
    @[JSON::Field(key: "is_inverted")]
    property is_inverted : Bool?

    # Optional. True, if the background moves slightly when the device is tilted
    @[JSON::Field(key: "is_moving")]
    property is_moving : Bool?

  end

  # Telegram API type: BackgroundTypeChatTheme
  # The background is taken directly from a built-in chat theme.
  struct BackgroundTypeChatTheme
    include JSON::Serializable

    # Type of the background, always "chat_theme"
    @[JSON::Field(key: "type")]
    property type : String

    # Name of the chat theme, which is usually an emoji
    @[JSON::Field(key: "theme_name")]
    property theme_name : String

  end

  # Telegram API type: ChatBackground
  # This object represents a chat background.
  struct ChatBackground
    include JSON::Serializable

    # Type of the background
    @[JSON::Field(key: "type")]
    property type : BackgroundType

  end

  # Telegram API type: ForumTopicCreated
  # This object represents a service message about a new forum topic created in the chat.
  struct ForumTopicCreated
    include JSON::Serializable

    # Name of the topic
    @[JSON::Field(key: "name")]
    property name : String

    # Color of the topic icon in RGB format
    @[JSON::Field(key: "icon_color")]
    property icon_color : Int32

    # Optional. Unique identifier of the custom emoji shown as the topic icon
    @[JSON::Field(key: "icon_custom_emoji_id")]
    property icon_custom_emoji_id : String?

  end

  # Telegram API type: ForumTopicClosed
  # This object represents a service message about a forum topic closed in the chat. Currently holds no information.
  struct ForumTopicClosed
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: ForumTopicEdited
  # This object represents a service message about an edited forum topic.
  struct ForumTopicEdited
    include JSON::Serializable

    # Optional. New name of the topic, if it was edited
    @[JSON::Field(key: "name")]
    property name : String?

    # Optional. New identifier of the custom emoji shown as the topic icon, if it was edited; an empty string if the icon was removed
    @[JSON::Field(key: "icon_custom_emoji_id")]
    property icon_custom_emoji_id : String?

  end

  # Telegram API type: ForumTopicReopened
  # This object represents a service message about a forum topic reopened in the chat. Currently holds no information.
  struct ForumTopicReopened
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: GeneralForumTopicHidden
  # This object represents a service message about General forum topic hidden in the chat. Currently holds no information.
  struct GeneralForumTopicHidden
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: GeneralForumTopicUnhidden
  # This object represents a service message about General forum topic unhidden in the chat. Currently holds no information.
  struct GeneralForumTopicUnhidden
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: SharedUser
  # This object contains information about a user that was shared with the bot using a KeyboardButtonRequestUsers button.
  struct SharedUser
    include JSON::Serializable

    # Identifier of the shared user. This number may have more than 32 significant bits and some programming languages may have difficulty/silent defects in interpreting it. But it has at most 52 significant bits, so 64-bit integers or double-precision float types are safe for storing these identifiers. The bot may not have access to the user and could be unable to use this identifier, unless the user is already known to the bot by some other means.
    @[JSON::Field(key: "user_id")]
    property user_id : Int32

    # Optional. First name of the user, if the name was requested by the bot
    @[JSON::Field(key: "first_name")]
    property first_name : String?

    # Optional. Last name of the user, if the name was requested by the bot
    @[JSON::Field(key: "last_name")]
    property last_name : String?

    # Optional. Username of the user, if the username was requested by the bot
    @[JSON::Field(key: "username")]
    property username : String?

    # Optional. Available sizes of the chat photo, if the photo was requested by the bot
    @[JSON::Field(key: "photo")]
    property photo : Array(PhotoSize)?

  end

  # Telegram API type: UsersShared
  # This object contains information about the users whose identifiers were shared with the bot using a KeyboardButtonRequestUsers button.
  struct UsersShared
    include JSON::Serializable

    # Identifier of the request
    @[JSON::Field(key: "request_id")]
    property request_id : Int32

    # Information about users shared with the bot.
    @[JSON::Field(key: "users")]
    property users : Array(SharedUser)

  end

  # Telegram API type: ChatShared
  # This object contains information about a chat that was shared with the bot using a KeyboardButtonRequestChat button.
  struct ChatShared
    include JSON::Serializable

    # Identifier of the request
    @[JSON::Field(key: "request_id")]
    property request_id : Int32

    # Identifier of the shared chat. This number may have more than 32 significant bits and some programming languages may have difficulty/silent defects in interpreting it. But it has at most 52 significant bits, so a 64-bit integer or double-precision float type are safe for storing this identifier. The bot may not have access to the chat and could be unable to use this identifier, unless the chat is already known to the bot by some other means.
    @[JSON::Field(key: "chat_id")]
    property chat_id : Int32

    # Optional. Title of the chat, if the title was requested by the bot.
    @[JSON::Field(key: "title")]
    property title : String?

    # Optional. Username of the chat, if the username was requested by the bot and available.
    @[JSON::Field(key: "username")]
    property username : String?

    # Optional. Available sizes of the chat photo, if the photo was requested by the bot
    @[JSON::Field(key: "photo")]
    property photo : Array(PhotoSize)?

  end

  # Telegram API type: WriteAccessAllowed
  # This object represents a service message about a user allowing a bot to write messages after adding it to the attachment menu, launching a Web App from a link, or accepting an explicit request from a Web App sent by the method requestWriteAccess.
  struct WriteAccessAllowed
    include JSON::Serializable

    # Optional. True, if the access was granted after the user accepted an explicit request from a Web App sent by the method requestWriteAccess
    @[JSON::Field(key: "from_request")]
    property from_request : Bool?

    # Optional. Name of the Web App, if the access was granted when the Web App was launched from a link
    @[JSON::Field(key: "web_app_name")]
    property web_app_name : String?

    # Optional. True, if the access was granted when the bot was added to the attachment or side menu
    @[JSON::Field(key: "from_attachment_menu")]
    property from_attachment_menu : Bool?

  end

  # Telegram API type: VideoChatScheduled
  # This object represents a service message about a video chat scheduled in the chat.
  struct VideoChatScheduled
    include JSON::Serializable

    # Point in time (Unix timestamp) when the video chat is supposed to be started by a chat administrator
    @[JSON::Field(key: "start_date")]
    property start_date : Int32

  end

  # Telegram API type: VideoChatStarted
  # This object represents a service message about a video chat started in the chat. Currently holds no information.
  struct VideoChatStarted
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: VideoChatEnded
  # This object represents a service message about a video chat ended in the chat.
  struct VideoChatEnded
    include JSON::Serializable

    # Video chat duration in seconds
    @[JSON::Field(key: "duration")]
    property duration : Int32

  end

  # Telegram API type: VideoChatParticipantsInvited
  # This object represents a service message about new members invited to a video chat.
  struct VideoChatParticipantsInvited
    include JSON::Serializable

    # New members that were invited to the video chat
    @[JSON::Field(key: "users")]
    property users : Array(User)

  end

  # Telegram API type: PaidMessagePriceChanged
  # Describes a service message about a change in the price of paid messages within a chat.
  struct PaidMessagePriceChanged
    include JSON::Serializable

    # The new number of Telegram Stars that must be paid by non-administrator users of the supergroup chat for each sent message
    @[JSON::Field(key: "paid_message_star_count")]
    property paid_message_star_count : Int32

  end

  # Telegram API type: DirectMessagePriceChanged
  # Describes a service message about a change in the price of direct messages sent to a channel chat.
  struct DirectMessagePriceChanged
    include JSON::Serializable

    # True, if direct messages are enabled for the channel chat; false otherwise
    @[JSON::Field(key: "are_direct_messages_enabled")]
    property are_direct_messages_enabled : Bool

    # Optional. The new number of Telegram Stars that must be paid by users for each direct message sent to the channel. Does not apply to users who have been exempted by administrators. Defaults to 0.
    @[JSON::Field(key: "direct_message_star_count")]
    property direct_message_star_count : Int32?

  end

  # Telegram API type: SuggestedPostApproved
  # Describes a service message about the approval of a suggested post.
  struct SuggestedPostApproved
    include JSON::Serializable

    # Optional. Message containing the suggested post. Note that the Message object in this field will not contain the reply_to_message field even if it itself is a reply.
    @[JSON::Field(key: "suggested_post_message")]
    property suggested_post_message : Message?

    # Optional. Amount paid for the post
    @[JSON::Field(key: "price")]
    property price : SuggestedPostPrice?

    # Date when the post will be published
    @[JSON::Field(key: "send_date")]
    property send_date : Int32

  end

  # Telegram API type: SuggestedPostApprovalFailed
  # Describes a service message about the failed approval of a suggested post. Currently, only caused by insufficient user funds at the time of approval.
  struct SuggestedPostApprovalFailed
    include JSON::Serializable

    # Optional. Message containing the suggested post whose approval has failed. Note that the Message object in this field will not contain the reply_to_message field even if it itself is a reply.
    @[JSON::Field(key: "suggested_post_message")]
    property suggested_post_message : Message?

    # Expected price of the post
    @[JSON::Field(key: "price")]
    property price : SuggestedPostPrice

  end

  # Telegram API type: SuggestedPostDeclined
  # Describes a service message about the rejection of a suggested post.
  struct SuggestedPostDeclined
    include JSON::Serializable

    # Optional. Message containing the suggested post. Note that the Message object in this field will not contain the reply_to_message field even if it itself is a reply.
    @[JSON::Field(key: "suggested_post_message")]
    property suggested_post_message : Message?

    # Optional. Comment with which the post was declined
    @[JSON::Field(key: "comment")]
    property comment : String?

  end

  # Telegram API type: SuggestedPostPaid
  # Describes a service message about a successful payment for a suggested post.
  struct SuggestedPostPaid
    include JSON::Serializable

    # Optional. Message containing the suggested post. Note that the Message object in this field will not contain the reply_to_message field even if it itself is a reply.
    @[JSON::Field(key: "suggested_post_message")]
    property suggested_post_message : Message?

    # Currency in which the payment was made. Currently, one of "XTR" for Telegram Stars or "TON" for toncoins
    @[JSON::Field(key: "currency")]
    property currency : String

    # Optional. The amount of the currency that was received by the channel in nanotoncoins; for payments in toncoins only
    @[JSON::Field(key: "amount")]
    property amount : Int32?

    # Optional. The amount of Telegram Stars that was received by the channel; for payments in Telegram Stars only
    @[JSON::Field(key: "star_amount")]
    property star_amount : StarAmount?

  end

  # Telegram API type: SuggestedPostRefunded
  # Describes a service message about a payment refund for a suggested post.
  struct SuggestedPostRefunded
    include JSON::Serializable

    # Optional. Message containing the suggested post. Note that the Message object in this field will not contain the reply_to_message field even if it itself is a reply.
    @[JSON::Field(key: "suggested_post_message")]
    property suggested_post_message : Message?

    # Reason for the refund. Currently, one of "post_deleted" if the post was deleted within 24 hours of being posted or removed from scheduled messages without being posted, or "payment_refunded" if the payer refunded their payment.
    @[JSON::Field(key: "reason")]
    property reason : String

  end

  # Telegram API type: GiveawayCreated
  # This object represents a service message about the creation of a scheduled giveaway.
  struct GiveawayCreated
    include JSON::Serializable

    # Optional. The number of Telegram Stars to be split between giveaway winners; for Telegram Star giveaways only
    @[JSON::Field(key: "prize_star_count")]
    property prize_star_count : Int32?

  end

  # Telegram API type: Giveaway
  # This object represents a message about a scheduled giveaway.
  struct Giveaway
    include JSON::Serializable

    # The list of chats which the user must join to participate in the giveaway
    @[JSON::Field(key: "chats")]
    property chats : Array(Chat)

    # Point in time (Unix timestamp) when winners of the giveaway will be selected
    @[JSON::Field(key: "winners_selection_date")]
    property winners_selection_date : Int32

    # The number of users which are supposed to be selected as winners of the giveaway
    @[JSON::Field(key: "winner_count")]
    property winner_count : Int32

    # Optional. True, if only users who join the chats after the giveaway started should be eligible to win
    @[JSON::Field(key: "only_new_members")]
    property only_new_members : Bool?

    # Optional. True, if the list of giveaway winners will be visible to everyone
    @[JSON::Field(key: "has_public_winners")]
    property has_public_winners : Bool?

    # Optional. Description of additional giveaway prize
    @[JSON::Field(key: "prize_description")]
    property prize_description : String?

    # Optional. A list of two-letter ISO 3166-1 alpha-2 country codes indicating the countries from which eligible users for the giveaway must come. If empty, then all users can participate in the giveaway. Users with a phone number that was bought on Fragment can always participate in giveaways.
    @[JSON::Field(key: "country_codes")]
    property country_codes : Array(String)?

    # Optional. The number of Telegram Stars to be split between giveaway winners; for Telegram Star giveaways only
    @[JSON::Field(key: "prize_star_count")]
    property prize_star_count : Int32?

    # Optional. The number of months the Telegram Premium subscription won from the giveaway will be active for; for Telegram Premium giveaways only
    @[JSON::Field(key: "premium_subscription_month_count")]
    property premium_subscription_month_count : Int32?

  end

  # Telegram API type: GiveawayWinners
  # This object represents a message about the completion of a giveaway with public winners.
  struct GiveawayWinners
    include JSON::Serializable

    # The chat that created the giveaway
    @[JSON::Field(key: "chat")]
    property chat : Chat

    # Identifier of the message with the giveaway in the chat
    @[JSON::Field(key: "giveaway_message_id")]
    property giveaway_message_id : Int32

    # Point in time (Unix timestamp) when winners of the giveaway were selected
    @[JSON::Field(key: "winners_selection_date")]
    property winners_selection_date : Int32

    # Total number of winners in the giveaway
    @[JSON::Field(key: "winner_count")]
    property winner_count : Int32

    # List of up to 100 winners of the giveaway
    @[JSON::Field(key: "winners")]
    property winners : Array(User)

    # Optional. The number of other chats the user had to join in order to be eligible for the giveaway
    @[JSON::Field(key: "additional_chat_count")]
    property additional_chat_count : Int32?

    # Optional. The number of Telegram Stars that were split between giveaway winners; for Telegram Star giveaways only
    @[JSON::Field(key: "prize_star_count")]
    property prize_star_count : Int32?

    # Optional. The number of months the Telegram Premium subscription won from the giveaway will be active for; for Telegram Premium giveaways only
    @[JSON::Field(key: "premium_subscription_month_count")]
    property premium_subscription_month_count : Int32?

    # Optional. Number of undistributed prizes
    @[JSON::Field(key: "unclaimed_prize_count")]
    property unclaimed_prize_count : Int32?

    # Optional. True, if only users who had joined the chats after the giveaway started were eligible to win
    @[JSON::Field(key: "only_new_members")]
    property only_new_members : Bool?

    # Optional. True, if the giveaway was canceled because the payment for it was refunded
    @[JSON::Field(key: "was_refunded")]
    property was_refunded : Bool?

    # Optional. Description of additional giveaway prize
    @[JSON::Field(key: "prize_description")]
    property prize_description : String?

  end

  # Telegram API type: GiveawayCompleted
  # This object represents a service message about the completion of a giveaway without public winners.
  struct GiveawayCompleted
    include JSON::Serializable

    # Number of winners in the giveaway
    @[JSON::Field(key: "winner_count")]
    property winner_count : Int32

    # Optional. Number of undistributed prizes
    @[JSON::Field(key: "unclaimed_prize_count")]
    property unclaimed_prize_count : Int32?

    # Optional. Message with the giveaway that was completed, if it wasn't deleted
    @[JSON::Field(key: "giveaway_message")]
    property giveaway_message : Message?

    # Optional. True, if the giveaway is a Telegram Star giveaway. Otherwise, currently, the giveaway is a Telegram Premium giveaway.
    @[JSON::Field(key: "is_star_giveaway")]
    property is_star_giveaway : Bool?

  end

  # Telegram API type: LinkPreviewOptions
  # Describes the options used for link preview generation.
  struct LinkPreviewOptions
    include JSON::Serializable

    # Optional. True, if the link preview is disabled
    @[JSON::Field(key: "is_disabled")]
    property is_disabled : Bool?

    # Optional. URL to use for the link preview. If empty, then the first URL found in the message text will be used
    @[JSON::Field(key: "url")]
    property url : String?

    # Optional. True, if the media in the link preview is supposed to be shrunk; ignored if the URL isn't explicitly specified or media size change isn't supported for the preview
    @[JSON::Field(key: "prefer_small_media")]
    property prefer_small_media : Bool?

    # Optional. True, if the media in the link preview is supposed to be enlarged; ignored if the URL isn't explicitly specified or media size change isn't supported for the preview
    @[JSON::Field(key: "prefer_large_media")]
    property prefer_large_media : Bool?

    # Optional. True, if the link preview must be shown above the message text; otherwise, the link preview will be shown below the message text
    @[JSON::Field(key: "show_above_text")]
    property show_above_text : Bool?

  end

  # Telegram API type: SuggestedPostPrice
  # Describes the price of a suggested post.
  struct SuggestedPostPrice
    include JSON::Serializable

    # Currency in which the post will be paid. Currently, must be one of "XTR" for Telegram Stars or "TON" for toncoins
    @[JSON::Field(key: "currency")]
    property currency : String

    # The amount of the currency that will be paid for the post in the smallest units of the currency, i.e. Telegram Stars or nanotoncoins. Currently, price in Telegram Stars must be between 5 and 100000, and price in nanotoncoins must be between 10000000 and 10000000000000.
    @[JSON::Field(key: "amount")]
    property amount : Int32

  end

  # Telegram API type: SuggestedPostInfo
  # Contains information about a suggested post.
  struct SuggestedPostInfo
    include JSON::Serializable

    # State of the suggested post. Currently, it can be one of "pending", "approved", "declined".
    @[JSON::Field(key: "state")]
    property state : String

    # Optional. Proposed price of the post. If the field is omitted, then the post is unpaid.
    @[JSON::Field(key: "price")]
    property price : SuggestedPostPrice?

    # Optional. Proposed send date of the post. If the field is omitted, then the post can be published at any time within 30 days at the sole discretion of the user or administrator who approves it.
    @[JSON::Field(key: "send_date")]
    property send_date : Int32?

  end

  # Telegram API type: SuggestedPostParameters
  # Contains parameters of a post that is being suggested by the bot.
  struct SuggestedPostParameters
    include JSON::Serializable

    # Optional. Proposed price for the post. If the field is omitted, then the post is unpaid.
    @[JSON::Field(key: "price")]
    property price : SuggestedPostPrice?

    # Optional. Proposed send date of the post. If specified, then the date must be between 300 second and 2678400 seconds (30 days) in the future. If the field is omitted, then the post can be published at any time within 30 days at the sole discretion of the user who approves it.
    @[JSON::Field(key: "send_date")]
    property send_date : Int32?

  end

  # Telegram API type: DirectMessagesTopic
  # Describes a topic of a direct messages chat.
  struct DirectMessagesTopic
    include JSON::Serializable

    # Unique identifier of the topic. This number may have more than 32 significant bits and some programming languages may have difficulty/silent defects in interpreting it. But it has at most 52 significant bits, so a 64-bit integer or double-precision float type are safe for storing this identifier.
    @[JSON::Field(key: "topic_id")]
    property topic_id : Int32

    # Optional. Information about the user that created the topic. Currently, it is always present
    @[JSON::Field(key: "user")]
    property user : User?

  end

  # Telegram API type: UserProfilePhotos
  # This object represent a user's profile pictures.
  struct UserProfilePhotos
    include JSON::Serializable

    # Total number of profile pictures the target user has
    @[JSON::Field(key: "total_count")]
    property total_count : Int32

    # Requested profile pictures (in up to 4 sizes each)
    @[JSON::Field(key: "photos")]
    property photos : Array(Array(PhotoSize))

  end

  # Telegram API type: File
  # This object represents a file ready to be downloaded. The file can be downloaded via the link https://api.telegram.org/file/bot<token>/<file_path>. It is guaranteed that the link will be valid for at least 1 hour. When the link expires, a new one can be requested by calling getFile.
  struct TelegramFile
    include JSON::Serializable

    # Identifier for this file, which can be used to download or reuse the file
    @[JSON::Field(key: "file_id")]
    property file_id : String

    # Unique identifier for this file, which is supposed to be the same over time and for different bots. Can't be used to download or reuse the file.
    @[JSON::Field(key: "file_unique_id")]
    property file_unique_id : String

    # Optional. File size in bytes. It can be bigger than 2^31 and some programming languages may have difficulty/silent defects in interpreting it. But it has at most 52 significant bits, so a signed 64-bit integer or double-precision float type are safe for storing this value.
    @[JSON::Field(key: "file_size")]
    property file_size : Int32?

    # Optional. File path. Use https://api.telegram.org/file/bot<token>/<file_path> to get the file.
    @[JSON::Field(key: "file_path")]
    property file_path : String?

  end

  # Telegram API type: WebAppInfo
  # Describes a Web App.
  struct WebAppInfo
    include JSON::Serializable

    # An HTTPS URL of a Web App to be opened with additional data as specified in Initializing Web Apps
    @[JSON::Field(key: "url")]
    property url : String

  end

  # Telegram API type: ReplyKeyboardMarkup
  # This object represents a custom keyboard with reply options (see Introduction to bots for details and examples). Not supported in channels and for messages sent on behalf of a Telegram Business account.
  struct ReplyKeyboardMarkup
    include JSON::Serializable

    # Array of button rows, each represented by an Array of KeyboardButton objects
    @[JSON::Field(key: "keyboard")]
    property keyboard : Array(Array(KeyboardButton))

    # Optional. Requests clients to always show the keyboard when the regular keyboard is hidden. Defaults to false, in which case the custom keyboard can be hidden and opened with a keyboard icon.
    @[JSON::Field(key: "is_persistent")]
    property is_persistent : Bool?

    # Optional. Requests clients to resize the keyboard vertically for optimal fit (e.g., make the keyboard smaller if there are just two rows of buttons). Defaults to false, in which case the custom keyboard is always of the same height as the app's standard keyboard.
    @[JSON::Field(key: "resize_keyboard")]
    property resize_keyboard : Bool?

    # Optional. Requests clients to hide the keyboard as soon as it's been used. The keyboard will still be available, but clients will automatically display the usual letter-keyboard in the chat - the user can press a special button in the input field to see the custom keyboard again. Defaults to false.
    @[JSON::Field(key: "one_time_keyboard")]
    property one_time_keyboard : Bool?

    # Optional. The placeholder to be shown in the input field when the keyboard is active; 1-64 characters
    @[JSON::Field(key: "input_field_placeholder")]
    property input_field_placeholder : String?

    # Optional. Use this parameter if you want to show the keyboard to specific users only. Targets: 1) users that are @mentioned in the text of the Message object; 2) if the bot's message is a reply to a message in the same chat and forum topic, sender of the original message. Example: A user requests to change the bot's language, bot replies to the request with a keyboard to select the new language. Other users in the group don't see the keyboard.
    @[JSON::Field(key: "selective")]
    property selective : Bool?

  end

  # Telegram API type: KeyboardButton
  # This object represents one button of the reply keyboard. At most one of the optional fields must be used to specify type of the button. For simple text buttons, String can be used instead of this object to specify the button text.
  # Note: request_users and request_chat options will only work in Telegram versions released after 3 February, 2023. Older clients will display unsupported message.
  struct KeyboardButton
    include JSON::Serializable

    # Text of the button. If none of the optional fields are used, it will be sent as a message when the button is pressed
    @[JSON::Field(key: "text")]
    property text : String

    # Optional. If specified, pressing the button will open a list of suitable users. Identifiers of selected users will be sent to the bot in a "users_shared" service message. Available in private chats only.
    @[JSON::Field(key: "request_users")]
    property request_users : KeyboardButtonRequestUsers?

    # Optional. If specified, pressing the button will open a list of suitable chats. Tapping on a chat will send its identifier to the bot in a "chat_shared" service message. Available in private chats only.
    @[JSON::Field(key: "request_chat")]
    property request_chat : KeyboardButtonRequestChat?

    # Optional. If True, the user's phone number will be sent as a contact when the button is pressed. Available in private chats only.
    @[JSON::Field(key: "request_contact")]
    property request_contact : Bool?

    # Optional. If True, the user's current location will be sent when the button is pressed. Available in private chats only.
    @[JSON::Field(key: "request_location")]
    property request_location : Bool?

    # Optional. If specified, the user will be asked to create a poll and send it to the bot when the button is pressed. Available in private chats only.
    @[JSON::Field(key: "request_poll")]
    property request_poll : KeyboardButtonPollType?

    # Optional. If specified, the described Web App will be launched when the button is pressed. The Web App will be able to send a "web_app_data" service message. Available in private chats only.
    @[JSON::Field(key: "web_app")]
    property web_app : WebAppInfo?

  end

  # Telegram API type: KeyboardButtonRequestUsers
  # This object defines the criteria used to request suitable users. Information about the selected users will be shared with the bot when the corresponding button is pressed. More about requesting users: https://core.telegram.org/bots/features#chat-and-user-selection
  struct KeyboardButtonRequestUsers
    include JSON::Serializable

    # Signed 32-bit identifier of the request that will be received back in the UsersShared object. Must be unique within the message
    @[JSON::Field(key: "request_id")]
    property request_id : Int32

    # Optional. Pass True to request bots, pass False to request regular users. If not specified, no additional restrictions are applied.
    @[JSON::Field(key: "user_is_bot")]
    property user_is_bot : Bool?

    # Optional. Pass True to request premium users, pass False to request non-premium users. If not specified, no additional restrictions are applied.
    @[JSON::Field(key: "user_is_premium")]
    property user_is_premium : Bool?

    # Optional. The maximum number of users to be selected; 1-10. Defaults to 1.
    @[JSON::Field(key: "max_quantity")]
    property max_quantity : Int32?

    # Optional. Pass True to request the users' first and last names
    @[JSON::Field(key: "request_name")]
    property request_name : Bool?

    # Optional. Pass True to request the users' usernames
    @[JSON::Field(key: "request_username")]
    property request_username : Bool?

    # Optional. Pass True to request the users' photos
    @[JSON::Field(key: "request_photo")]
    property request_photo : Bool?

  end

  # Telegram API type: KeyboardButtonRequestChat
  # This object defines the criteria used to request a suitable chat. Information about the selected chat will be shared with the bot when the corresponding button is pressed. The bot will be granted requested rights in the chat if appropriate. More about requesting chats: https://core.telegram.org/bots/features#chat-and-user-selection.
  struct KeyboardButtonRequestChat
    include JSON::Serializable

    # Signed 32-bit identifier of the request, which will be received back in the ChatShared object. Must be unique within the message
    @[JSON::Field(key: "request_id")]
    property request_id : Int32

    # Pass True to request a channel chat, pass False to request a group or a supergroup chat.
    @[JSON::Field(key: "chat_is_channel")]
    property chat_is_channel : Bool

    # Optional. Pass True to request a forum supergroup, pass False to request a non-forum chat. If not specified, no additional restrictions are applied.
    @[JSON::Field(key: "chat_is_forum")]
    property chat_is_forum : Bool?

    # Optional. Pass True to request a supergroup or a channel with a username, pass False to request a chat without a username. If not specified, no additional restrictions are applied.
    @[JSON::Field(key: "chat_has_username")]
    property chat_has_username : Bool?

    # Optional. Pass True to request a chat owned by the user. Otherwise, no additional restrictions are applied.
    @[JSON::Field(key: "chat_is_created")]
    property chat_is_created : Bool?

    # Optional. A JSON-serialized object listing the required administrator rights of the user in the chat. The rights must be a superset of bot_administrator_rights. If not specified, no additional restrictions are applied.
    @[JSON::Field(key: "user_administrator_rights")]
    property user_administrator_rights : ChatAdministratorRights?

    # Optional. A JSON-serialized object listing the required administrator rights of the bot in the chat. The rights must be a subset of user_administrator_rights. If not specified, no additional restrictions are applied.
    @[JSON::Field(key: "bot_administrator_rights")]
    property bot_administrator_rights : ChatAdministratorRights?

    # Optional. Pass True to request a chat with the bot as a member. Otherwise, no additional restrictions are applied.
    @[JSON::Field(key: "bot_is_member")]
    property bot_is_member : Bool?

    # Optional. Pass True to request the chat's title
    @[JSON::Field(key: "request_title")]
    property request_title : Bool?

    # Optional. Pass True to request the chat's username
    @[JSON::Field(key: "request_username")]
    property request_username : Bool?

    # Optional. Pass True to request the chat's photo
    @[JSON::Field(key: "request_photo")]
    property request_photo : Bool?

  end

  # Telegram API type: KeyboardButtonPollType
  # This object represents type of a poll, which is allowed to be created and sent when the corresponding button is pressed.
  struct KeyboardButtonPollType
    include JSON::Serializable

    # Optional. If quiz is passed, the user will be allowed to create only polls in the quiz mode. If regular is passed, only regular polls will be allowed. Otherwise, the user will be allowed to create a poll of any type.
    @[JSON::Field(key: "type")]
    property type : String?

  end

  # Telegram API type: ReplyKeyboardRemove
  # Upon receiving a message with this object, Telegram clients will remove the current custom keyboard and display the default letter-keyboard. By default, custom keyboards are displayed until a new keyboard is sent by a bot. An exception is made for one-time keyboards that are hidden immediately after the user presses a button (see ReplyKeyboardMarkup). Not supported in channels and for messages sent on behalf of a Telegram Business account.
  struct ReplyKeyboardRemove
    include JSON::Serializable

    # Requests clients to remove the custom keyboard (user will not be able to summon this keyboard; if you want to hide the keyboard from sight but keep it accessible, use one_time_keyboard in ReplyKeyboardMarkup)
    @[JSON::Field(key: "remove_keyboard")]
    property remove_keyboard : Bool

    # Optional. Use this parameter if you want to remove the keyboard for specific users only. Targets: 1) users that are @mentioned in the text of the Message object; 2) if the bot's message is a reply to a message in the same chat and forum topic, sender of the original message. Example: A user votes in a poll, bot returns confirmation message in reply to the vote and removes the keyboard for that user, while still showing the keyboard with poll options to users who haven't voted yet.
    @[JSON::Field(key: "selective")]
    property selective : Bool?

  end

  # Telegram API type: InlineKeyboardMarkup
  # This object represents an inline keyboard that appears right next to the message it belongs to.
  struct InlineKeyboardMarkup
    include JSON::Serializable

    # Array of button rows, each represented by an Array of InlineKeyboardButton objects
    @[JSON::Field(key: "inline_keyboard")]
    property inline_keyboard : Array(Array(InlineKeyboardButton))

  end

  # Telegram API type: InlineKeyboardButton
  # This object represents one button of an inline keyboard. Exactly one of the optional fields must be used to specify type of the button.
  struct InlineKeyboardButton
    include JSON::Serializable

    # Label text on the button
    @[JSON::Field(key: "text")]
    property text : String

    # Optional. HTTP or tg:// URL to be opened when the button is pressed. Links tg://user?id=<user_id> can be used to mention a user by their identifier without using a username, if this is allowed by their privacy settings.
    @[JSON::Field(key: "url")]
    property url : String?

    # Optional. Data to be sent in a callback query to the bot when the button is pressed, 1-64 bytes
    @[JSON::Field(key: "callback_data")]
    property callback_data : String?

    # Optional. Description of the Web App that will be launched when the user presses the button. The Web App will be able to send an arbitrary message on behalf of the user using the method answerWebAppQuery. Available only in private chats between a user and the bot. Not supported for messages sent on behalf of a Telegram Business account.
    @[JSON::Field(key: "web_app")]
    property web_app : WebAppInfo?

    # Optional. An HTTPS URL used to automatically authorize the user. Can be used as a replacement for the Telegram Login Widget.
    @[JSON::Field(key: "login_url")]
    property login_url : LoginUrl?

    # Optional. If set, pressing the button will prompt the user to select one of their chats, open that chat and insert the bot's username and the specified inline query in the input field. May be empty, in which case just the bot's username will be inserted. Not supported for messages sent in channel direct messages chats and on behalf of a Telegram Business account.
    @[JSON::Field(key: "switch_inline_query")]
    property switch_inline_query : String?

    # Optional. If set, pressing the button will insert the bot's username and the specified inline query in the current chat's input field. May be empty, in which case only the bot's username will be inserted. This offers a quick way for the user to open your bot in inline mode in the same chat - good for selecting something from multiple options. Not supported in channels and for messages sent in channel direct messages chats and on behalf of a Telegram Business account.
    @[JSON::Field(key: "switch_inline_query_current_chat")]
    property switch_inline_query_current_chat : String?

    # Optional. If set, pressing the button will prompt the user to select one of their chats of the specified type, open that chat and insert the bot's username and the specified inline query in the input field. Not supported for messages sent in channel direct messages chats and on behalf of a Telegram Business account.
    @[JSON::Field(key: "switch_inline_query_chosen_chat")]
    property switch_inline_query_chosen_chat : SwitchInlineQueryChosenChat?

    # Optional. Description of the button that copies the specified text to the clipboard.
    @[JSON::Field(key: "copy_text")]
    property copy_text : CopyTextButton?

    # Optional. Description of the game that will be launched when the user presses the button. NOTE: This type of button must always be the first button in the first row.
    @[JSON::Field(key: "callback_game")]
    property callback_game : CallbackGame?

    # Optional. Specify True, to send a Pay button. Substrings "⭐" and "XTR" in the buttons's text will be replaced with a Telegram Star icon. NOTE: This type of button must always be the first button in the first row and can only be used in invoice messages.
    @[JSON::Field(key: "pay")]
    property pay : Bool?

  end

  # Telegram API type: LoginUrl
  # This object represents a parameter of the inline keyboard button used to automatically authorize a user. Serves as a great replacement for the Telegram Login Widget when the user is coming from Telegram. All the user needs to do is tap/click a button and confirm that they want to log in:
  # Telegram apps support these buttons as of version 5.7.
  struct LoginUrl
    include JSON::Serializable

    # An HTTPS URL to be opened with user authorization data added to the query string when the button is pressed. If the user refuses to provide authorization data, the original URL without information about the user will be opened. The data added is the same as described in Receiving authorization data. NOTE: You must always check the hash of the received data to verify the authentication and the integrity of the data as described in Checking authorization.
    @[JSON::Field(key: "url")]
    property url : String

    # Optional. New text of the button in forwarded messages.
    @[JSON::Field(key: "forward_text")]
    property forward_text : String?

    # Optional. Username of a bot, which will be used for user authorization. See Setting up a bot for more details. If not specified, the current bot's username will be assumed. The url's domain must be the same as the domain linked with the bot. See Linking your domain to the bot for more details.
    @[JSON::Field(key: "bot_username")]
    property bot_username : String?

    # Optional. Pass True to request the permission for your bot to send messages to the user.
    @[JSON::Field(key: "request_write_access")]
    property request_write_access : Bool?

  end

  # Telegram API type: SwitchInlineQueryChosenChat
  # This object represents an inline button that switches the current user to inline mode in a chosen chat, with an optional default inline query.
  struct SwitchInlineQueryChosenChat
    include JSON::Serializable

    # Optional. The default inline query to be inserted in the input field. If left empty, only the bot's username will be inserted
    @[JSON::Field(key: "query")]
    property query : String?

    # Optional. True, if private chats with users can be chosen
    @[JSON::Field(key: "allow_user_chats")]
    property allow_user_chats : Bool?

    # Optional. True, if private chats with bots can be chosen
    @[JSON::Field(key: "allow_bot_chats")]
    property allow_bot_chats : Bool?

    # Optional. True, if group and supergroup chats can be chosen
    @[JSON::Field(key: "allow_group_chats")]
    property allow_group_chats : Bool?

    # Optional. True, if channel chats can be chosen
    @[JSON::Field(key: "allow_channel_chats")]
    property allow_channel_chats : Bool?

  end

  # Telegram API type: CopyTextButton
  # This object represents an inline keyboard button that copies specified text to the clipboard.
  struct CopyTextButton
    include JSON::Serializable

    # The text to be copied to the clipboard; 1-256 characters
    @[JSON::Field(key: "text")]
    property text : String

  end

  # Telegram API type: CallbackQuery
  # This object represents an incoming callback query from a callback button in an inline keyboard. If the button that originated the query was attached to a message sent by the bot, the field message will be present. If the button was attached to a message sent via the bot (in inline mode), the field inline_message_id will be present. Exactly one of the fields data or game_short_name will be present.
  class CallbackQuery
    include JSON::Serializable

    # Unique identifier for this query
    @[JSON::Field(key: "id")]
    property id : String

    # Sender
    @[JSON::Field(key: "from")]
    property from : User

    # Optional. Message sent by the bot with the callback button that originated the query
    @[JSON::Field(key: "message")]
    property message : MaybeInaccessibleMessage?

    # Optional. Identifier of the message sent via the bot in inline mode, that originated the query.
    @[JSON::Field(key: "inline_message_id")]
    property inline_message_id : String?

    # Global identifier, uniquely corresponding to the chat to which the message with the callback button was sent. Useful for high scores in games.
    @[JSON::Field(key: "chat_instance")]
    property chat_instance : String

    # Optional. Data associated with the callback button. Be aware that the message originated the query can contain no callback buttons with this data.
    @[JSON::Field(key: "data")]
    property data : String?

    # Optional. Short name of a Game to be returned, serves as the unique identifier for the game
    @[JSON::Field(key: "game_short_name")]
    property game_short_name : String?

  end

  # Telegram API type: ForceReply
  # Upon receiving a message with this object, Telegram clients will display a reply interface to the user (act as if the user has selected the bot's message and tapped 'Reply'). This can be extremely useful if you want to create user-friendly step-by-step interfaces without having to sacrifice privacy mode. Not supported in channels and for messages sent on behalf of a Telegram Business account.
  struct ForceReply
    include JSON::Serializable

    # Shows reply interface to the user, as if they manually selected the bot's message and tapped 'Reply'
    @[JSON::Field(key: "force_reply")]
    property force_reply : Bool

    # Optional. The placeholder to be shown in the input field when the reply is active; 1-64 characters
    @[JSON::Field(key: "input_field_placeholder")]
    property input_field_placeholder : String?

    # Optional. Use this parameter if you want to force reply from specific users only. Targets: 1) users that are @mentioned in the text of the Message object; 2) if the bot's message is a reply to a message in the same chat and forum topic, sender of the original message.
    @[JSON::Field(key: "selective")]
    property selective : Bool?

  end

  # Telegram API type: ChatPhoto
  # This object represents a chat photo.
  struct ChatPhoto
    include JSON::Serializable

    # File identifier of small (160x160) chat photo. This file_id can be used only for photo download and only for as long as the photo is not changed.
    @[JSON::Field(key: "small_file_id")]
    property small_file_id : String

    # Unique file identifier of small (160x160) chat photo, which is supposed to be the same over time and for different bots. Can't be used to download or reuse the file.
    @[JSON::Field(key: "small_file_unique_id")]
    property small_file_unique_id : String

    # File identifier of big (640x640) chat photo. This file_id can be used only for photo download and only for as long as the photo is not changed.
    @[JSON::Field(key: "big_file_id")]
    property big_file_id : String

    # Unique file identifier of big (640x640) chat photo, which is supposed to be the same over time and for different bots. Can't be used to download or reuse the file.
    @[JSON::Field(key: "big_file_unique_id")]
    property big_file_unique_id : String

  end

  # Telegram API type: ChatInviteLink
  # Represents an invite link for a chat.
  struct ChatInviteLink
    include JSON::Serializable

    # The invite link. If the link was created by another chat administrator, then the second part of the link will be replaced with "...".
    @[JSON::Field(key: "invite_link")]
    property invite_link : String

    # Creator of the link
    @[JSON::Field(key: "creator")]
    property creator : User

    # True, if users joining the chat via the link need to be approved by chat administrators
    @[JSON::Field(key: "creates_join_request")]
    property creates_join_request : Bool

    # True, if the link is primary
    @[JSON::Field(key: "is_primary")]
    property is_primary : Bool

    # True, if the link is revoked
    @[JSON::Field(key: "is_revoked")]
    property is_revoked : Bool

    # Optional. Invite link name
    @[JSON::Field(key: "name")]
    property name : String?

    # Optional. Point in time (Unix timestamp) when the link will expire or has been expired
    @[JSON::Field(key: "expire_date")]
    property expire_date : Int32?

    # Optional. The maximum number of users that can be members of the chat simultaneously after joining the chat via this invite link; 1-99999
    @[JSON::Field(key: "member_limit")]
    property member_limit : Int32?

    # Optional. Number of pending join requests created using this link
    @[JSON::Field(key: "pending_join_request_count")]
    property pending_join_request_count : Int32?

    # Optional. The number of seconds the subscription will be active for before the next payment
    @[JSON::Field(key: "subscription_period")]
    property subscription_period : Int32?

    # Optional. The amount of Telegram Stars a user must pay initially and after each subsequent subscription period to be a member of the chat using the link
    @[JSON::Field(key: "subscription_price")]
    property subscription_price : Int32?

  end

  # Telegram API type: ChatAdministratorRights
  # Represents the rights of an administrator in a chat.
  struct ChatAdministratorRights
    include JSON::Serializable

    # True, if the user's presence in the chat is hidden
    @[JSON::Field(key: "is_anonymous")]
    property is_anonymous : Bool

    # True, if the administrator can access the chat event log, get boost list, see hidden supergroup and channel members, report spam messages, ignore slow mode, and send messages to the chat without paying Telegram Stars. Implied by any other administrator privilege.
    @[JSON::Field(key: "can_manage_chat")]
    property can_manage_chat : Bool

    # True, if the administrator can delete messages of other users
    @[JSON::Field(key: "can_delete_messages")]
    property can_delete_messages : Bool

    # True, if the administrator can manage video chats
    @[JSON::Field(key: "can_manage_video_chats")]
    property can_manage_video_chats : Bool

    # True, if the administrator can restrict, ban or unban chat members, or access supergroup statistics
    @[JSON::Field(key: "can_restrict_members")]
    property can_restrict_members : Bool

    # True, if the administrator can add new administrators with a subset of their own privileges or demote administrators that they have promoted, directly or indirectly (promoted by administrators that were appointed by the user)
    @[JSON::Field(key: "can_promote_members")]
    property can_promote_members : Bool

    # True, if the user is allowed to change the chat title, photo and other settings
    @[JSON::Field(key: "can_change_info")]
    property can_change_info : Bool

    # True, if the user is allowed to invite new users to the chat
    @[JSON::Field(key: "can_invite_users")]
    property can_invite_users : Bool

    # True, if the administrator can post stories to the chat
    @[JSON::Field(key: "can_post_stories")]
    property can_post_stories : Bool

    # True, if the administrator can edit stories posted by other users, post stories to the chat page, pin chat stories, and access the chat's story archive
    @[JSON::Field(key: "can_edit_stories")]
    property can_edit_stories : Bool

    # True, if the administrator can delete stories posted by other users
    @[JSON::Field(key: "can_delete_stories")]
    property can_delete_stories : Bool

    # Optional. True, if the administrator can post messages in the channel, approve suggested posts, or access channel statistics; for channels only
    @[JSON::Field(key: "can_post_messages")]
    property can_post_messages : Bool?

    # Optional. True, if the administrator can edit messages of other users and can pin messages; for channels only
    @[JSON::Field(key: "can_edit_messages")]
    property can_edit_messages : Bool?

    # Optional. True, if the user is allowed to pin messages; for groups and supergroups only
    @[JSON::Field(key: "can_pin_messages")]
    property can_pin_messages : Bool?

    # Optional. True, if the user is allowed to create, rename, close, and reopen forum topics; for supergroups only
    @[JSON::Field(key: "can_manage_topics")]
    property can_manage_topics : Bool?

    # Optional. True, if the administrator can manage direct messages of the channel and decline suggested posts; for channels only
    @[JSON::Field(key: "can_manage_direct_messages")]
    property can_manage_direct_messages : Bool?

  end

  # Telegram API type: ChatMemberUpdated
  # This object represents changes in the status of a chat member.
  struct ChatMemberUpdated
    include JSON::Serializable

    # Chat the user belongs to
    @[JSON::Field(key: "chat")]
    property chat : Chat

    # Performer of the action, which resulted in the change
    @[JSON::Field(key: "from")]
    property from : User

    # Date the change was done in Unix time
    @[JSON::Field(key: "date")]
    property date : Int32

    # Previous information about the chat member
    @[JSON::Field(key: "old_chat_member")]
    property old_chat_member : ChatMember

    # New information about the chat member
    @[JSON::Field(key: "new_chat_member")]
    property new_chat_member : ChatMember

    # Optional. Chat invite link, which was used by the user to join the chat; for joining by invite link events only.
    @[JSON::Field(key: "invite_link")]
    property invite_link : ChatInviteLink?

    # Optional. True, if the user joined the chat after sending a direct join request without using an invite link and being approved by an administrator
    @[JSON::Field(key: "via_join_request")]
    property via_join_request : Bool?

    # Optional. True, if the user joined the chat via a chat folder invite link
    @[JSON::Field(key: "via_chat_folder_invite_link")]
    property via_chat_folder_invite_link : Bool?

  end

  # Telegram API type: ChatMember
  # This object contains information about one member of a chat. Currently, the following 6 types of chat members are supported:
  # - ChatMemberOwner
  # - ChatMemberAdministrator
  # - ChatMemberMember
  # - ChatMemberRestricted
  # - ChatMemberLeft
  # - ChatMemberBanned
  struct ChatMember
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: ChatMemberOwner
  # Represents a chat member that owns the chat and has all administrator privileges.
  struct ChatMemberOwner
    include JSON::Serializable

    # The member's status in the chat, always "creator"
    @[JSON::Field(key: "status")]
    property status : String

    # Information about the user
    @[JSON::Field(key: "user")]
    property user : User

    # True, if the user's presence in the chat is hidden
    @[JSON::Field(key: "is_anonymous")]
    property is_anonymous : Bool

    # Optional. Custom title for this user
    @[JSON::Field(key: "custom_title")]
    property custom_title : String?

  end

  # Telegram API type: ChatMemberAdministrator
  # Represents a chat member that has some additional privileges.
  struct ChatMemberAdministrator
    include JSON::Serializable

    # The member's status in the chat, always "administrator"
    @[JSON::Field(key: "status")]
    property status : String

    # Information about the user
    @[JSON::Field(key: "user")]
    property user : User

    # True, if the bot is allowed to edit administrator privileges of that user
    @[JSON::Field(key: "can_be_edited")]
    property can_be_edited : Bool

    # True, if the user's presence in the chat is hidden
    @[JSON::Field(key: "is_anonymous")]
    property is_anonymous : Bool

    # True, if the administrator can access the chat event log, get boost list, see hidden supergroup and channel members, report spam messages, ignore slow mode, and send messages to the chat without paying Telegram Stars. Implied by any other administrator privilege.
    @[JSON::Field(key: "can_manage_chat")]
    property can_manage_chat : Bool

    # True, if the administrator can delete messages of other users
    @[JSON::Field(key: "can_delete_messages")]
    property can_delete_messages : Bool

    # True, if the administrator can manage video chats
    @[JSON::Field(key: "can_manage_video_chats")]
    property can_manage_video_chats : Bool

    # True, if the administrator can restrict, ban or unban chat members, or access supergroup statistics
    @[JSON::Field(key: "can_restrict_members")]
    property can_restrict_members : Bool

    # True, if the administrator can add new administrators with a subset of their own privileges or demote administrators that they have promoted, directly or indirectly (promoted by administrators that were appointed by the user)
    @[JSON::Field(key: "can_promote_members")]
    property can_promote_members : Bool

    # True, if the user is allowed to change the chat title, photo and other settings
    @[JSON::Field(key: "can_change_info")]
    property can_change_info : Bool

    # True, if the user is allowed to invite new users to the chat
    @[JSON::Field(key: "can_invite_users")]
    property can_invite_users : Bool

    # True, if the administrator can post stories to the chat
    @[JSON::Field(key: "can_post_stories")]
    property can_post_stories : Bool

    # True, if the administrator can edit stories posted by other users, post stories to the chat page, pin chat stories, and access the chat's story archive
    @[JSON::Field(key: "can_edit_stories")]
    property can_edit_stories : Bool

    # True, if the administrator can delete stories posted by other users
    @[JSON::Field(key: "can_delete_stories")]
    property can_delete_stories : Bool

    # Optional. True, if the administrator can post messages in the channel, approve suggested posts, or access channel statistics; for channels only
    @[JSON::Field(key: "can_post_messages")]
    property can_post_messages : Bool?

    # Optional. True, if the administrator can edit messages of other users and can pin messages; for channels only
    @[JSON::Field(key: "can_edit_messages")]
    property can_edit_messages : Bool?

    # Optional. True, if the user is allowed to pin messages; for groups and supergroups only
    @[JSON::Field(key: "can_pin_messages")]
    property can_pin_messages : Bool?

    # Optional. True, if the user is allowed to create, rename, close, and reopen forum topics; for supergroups only
    @[JSON::Field(key: "can_manage_topics")]
    property can_manage_topics : Bool?

    # Optional. True, if the administrator can manage direct messages of the channel and decline suggested posts; for channels only
    @[JSON::Field(key: "can_manage_direct_messages")]
    property can_manage_direct_messages : Bool?

    # Optional. Custom title for this user
    @[JSON::Field(key: "custom_title")]
    property custom_title : String?

  end

  # Telegram API type: ChatMemberMember
  # Represents a chat member that has no additional privileges or restrictions.
  struct ChatMemberMember
    include JSON::Serializable

    # The member's status in the chat, always "member"
    @[JSON::Field(key: "status")]
    property status : String

    # Information about the user
    @[JSON::Field(key: "user")]
    property user : User

    # Optional. Date when the user's subscription will expire; Unix time
    @[JSON::Field(key: "until_date")]
    property until_date : Int32?

  end

  # Telegram API type: ChatMemberRestricted
  # Represents a chat member that is under certain restrictions in the chat. Supergroups only.
  struct ChatMemberRestricted
    include JSON::Serializable

    # The member's status in the chat, always "restricted"
    @[JSON::Field(key: "status")]
    property status : String

    # Information about the user
    @[JSON::Field(key: "user")]
    property user : User

    # True, if the user is a member of the chat at the moment of the request
    @[JSON::Field(key: "is_member")]
    property is_member : Bool

    # True, if the user is allowed to send text messages, contacts, giveaways, giveaway winners, invoices, locations and venues
    @[JSON::Field(key: "can_send_messages")]
    property can_send_messages : Bool

    # True, if the user is allowed to send audios
    @[JSON::Field(key: "can_send_audios")]
    property can_send_audios : Bool

    # True, if the user is allowed to send documents
    @[JSON::Field(key: "can_send_documents")]
    property can_send_documents : Bool

    # True, if the user is allowed to send photos
    @[JSON::Field(key: "can_send_photos")]
    property can_send_photos : Bool

    # True, if the user is allowed to send videos
    @[JSON::Field(key: "can_send_videos")]
    property can_send_videos : Bool

    # True, if the user is allowed to send video notes
    @[JSON::Field(key: "can_send_video_notes")]
    property can_send_video_notes : Bool

    # True, if the user is allowed to send voice notes
    @[JSON::Field(key: "can_send_voice_notes")]
    property can_send_voice_notes : Bool

    # True, if the user is allowed to send polls and checklists
    @[JSON::Field(key: "can_send_polls")]
    property can_send_polls : Bool

    # True, if the user is allowed to send animations, games, stickers and use inline bots
    @[JSON::Field(key: "can_send_other_messages")]
    property can_send_other_messages : Bool

    # True, if the user is allowed to add web page previews to their messages
    @[JSON::Field(key: "can_add_web_page_previews")]
    property can_add_web_page_previews : Bool

    # True, if the user is allowed to change the chat title, photo and other settings
    @[JSON::Field(key: "can_change_info")]
    property can_change_info : Bool

    # True, if the user is allowed to invite new users to the chat
    @[JSON::Field(key: "can_invite_users")]
    property can_invite_users : Bool

    # True, if the user is allowed to pin messages
    @[JSON::Field(key: "can_pin_messages")]
    property can_pin_messages : Bool

    # True, if the user is allowed to create forum topics
    @[JSON::Field(key: "can_manage_topics")]
    property can_manage_topics : Bool

    # Date when restrictions will be lifted for this user; Unix time. If 0, then the user is restricted forever
    @[JSON::Field(key: "until_date")]
    property until_date : Int32

  end

  # Telegram API type: ChatMemberLeft
  # Represents a chat member that isn't currently a member of the chat, but may join it themselves.
  struct ChatMemberLeft
    include JSON::Serializable

    # The member's status in the chat, always "left"
    @[JSON::Field(key: "status")]
    property status : String

    # Information about the user
    @[JSON::Field(key: "user")]
    property user : User

  end

  # Telegram API type: ChatMemberBanned
  # Represents a chat member that was banned in the chat and can't return to the chat or view chat messages.
  struct ChatMemberBanned
    include JSON::Serializable

    # The member's status in the chat, always "kicked"
    @[JSON::Field(key: "status")]
    property status : String

    # Information about the user
    @[JSON::Field(key: "user")]
    property user : User

    # Date when restrictions will be lifted for this user; Unix time. If 0, then the user is banned forever
    @[JSON::Field(key: "until_date")]
    property until_date : Int32

  end

  # Telegram API type: ChatJoinRequest
  # Represents a join request sent to a chat.
  struct ChatJoinRequest
    include JSON::Serializable

    # Chat to which the request was sent
    @[JSON::Field(key: "chat")]
    property chat : Chat

    # User that sent the join request
    @[JSON::Field(key: "from")]
    property from : User

    # Identifier of a private chat with the user who sent the join request. This number may have more than 32 significant bits and some programming languages may have difficulty/silent defects in interpreting it. But it has at most 52 significant bits, so a 64-bit integer or double-precision float type are safe for storing this identifier. The bot can use this identifier for 5 minutes to send messages until the join request is processed, assuming no other administrator contacted the user.
    @[JSON::Field(key: "user_chat_id")]
    property user_chat_id : Int32

    # Date the request was sent in Unix time
    @[JSON::Field(key: "date")]
    property date : Int32

    # Optional. Bio of the user.
    @[JSON::Field(key: "bio")]
    property bio : String?

    # Optional. Chat invite link that was used by the user to send the join request
    @[JSON::Field(key: "invite_link")]
    property invite_link : ChatInviteLink?

  end

  # Telegram API type: ChatPermissions
  # Describes actions that a non-administrator user is allowed to take in a chat.
  struct ChatPermissions
    include JSON::Serializable

    # Optional. True, if the user is allowed to send text messages, contacts, giveaways, giveaway winners, invoices, locations and venues
    @[JSON::Field(key: "can_send_messages")]
    property can_send_messages : Bool?

    # Optional. True, if the user is allowed to send audios
    @[JSON::Field(key: "can_send_audios")]
    property can_send_audios : Bool?

    # Optional. True, if the user is allowed to send documents
    @[JSON::Field(key: "can_send_documents")]
    property can_send_documents : Bool?

    # Optional. True, if the user is allowed to send photos
    @[JSON::Field(key: "can_send_photos")]
    property can_send_photos : Bool?

    # Optional. True, if the user is allowed to send videos
    @[JSON::Field(key: "can_send_videos")]
    property can_send_videos : Bool?

    # Optional. True, if the user is allowed to send video notes
    @[JSON::Field(key: "can_send_video_notes")]
    property can_send_video_notes : Bool?

    # Optional. True, if the user is allowed to send voice notes
    @[JSON::Field(key: "can_send_voice_notes")]
    property can_send_voice_notes : Bool?

    # Optional. True, if the user is allowed to send polls and checklists
    @[JSON::Field(key: "can_send_polls")]
    property can_send_polls : Bool?

    # Optional. True, if the user is allowed to send animations, games, stickers and use inline bots
    @[JSON::Field(key: "can_send_other_messages")]
    property can_send_other_messages : Bool?

    # Optional. True, if the user is allowed to add web page previews to their messages
    @[JSON::Field(key: "can_add_web_page_previews")]
    property can_add_web_page_previews : Bool?

    # Optional. True, if the user is allowed to change the chat title, photo and other settings. Ignored in public supergroups
    @[JSON::Field(key: "can_change_info")]
    property can_change_info : Bool?

    # Optional. True, if the user is allowed to invite new users to the chat
    @[JSON::Field(key: "can_invite_users")]
    property can_invite_users : Bool?

    # Optional. True, if the user is allowed to pin messages. Ignored in public supergroups
    @[JSON::Field(key: "can_pin_messages")]
    property can_pin_messages : Bool?

    # Optional. True, if the user is allowed to create forum topics. If omitted defaults to the value of can_pin_messages
    @[JSON::Field(key: "can_manage_topics")]
    property can_manage_topics : Bool?

  end

  # Telegram API type: Birthdate
  # Describes the birthdate of a user.
  struct Birthdate
    include JSON::Serializable

    # Day of the user's birth; 1-31
    @[JSON::Field(key: "day")]
    property day : Int32

    # Month of the user's birth; 1-12
    @[JSON::Field(key: "month")]
    property month : Int32

    # Optional. Year of the user's birth
    @[JSON::Field(key: "year")]
    property year : Int32?

  end

  # Telegram API type: BusinessIntro
  # Contains information about the start page settings of a Telegram Business account.
  struct BusinessIntro
    include JSON::Serializable

    # Optional. Title text of the business intro
    @[JSON::Field(key: "title")]
    property title : String?

    # Optional. Message text of the business intro
    @[JSON::Field(key: "message")]
    property message : String?

    # Optional. Sticker of the business intro
    @[JSON::Field(key: "sticker")]
    property sticker : Sticker?

  end

  # Telegram API type: BusinessLocation
  # Contains information about the location of a Telegram Business account.
  struct BusinessLocation
    include JSON::Serializable

    # Address of the business
    @[JSON::Field(key: "address")]
    property address : String

    # Optional. Location of the business
    @[JSON::Field(key: "location")]
    property location : Location?

  end

  # Telegram API type: BusinessOpeningHoursInterval
  # Describes an interval of time during which a business is open.
  struct BusinessOpeningHoursInterval
    include JSON::Serializable

    # The minute's sequence number in a week, starting on Monday, marking the start of the time interval during which the business is open; 0 - 7 * 24 * 60
    @[JSON::Field(key: "opening_minute")]
    property opening_minute : Int32

    # The minute's sequence number in a week, starting on Monday, marking the end of the time interval during which the business is open; 0 - 8 * 24 * 60
    @[JSON::Field(key: "closing_minute")]
    property closing_minute : Int32

  end

  # Telegram API type: BusinessOpeningHours
  # Describes the opening hours of a business.
  struct BusinessOpeningHours
    include JSON::Serializable

    # Unique name of the time zone for which the opening hours are defined
    @[JSON::Field(key: "time_zone_name")]
    property time_zone_name : String

    # List of time intervals describing business opening hours
    @[JSON::Field(key: "opening_hours")]
    property opening_hours : Array(BusinessOpeningHoursInterval)

  end

  # Telegram API type: StoryAreaPosition
  # Describes the position of a clickable area within a story.
  struct StoryAreaPosition
    include JSON::Serializable

    # The abscissa of the area's center, as a percentage of the media width
    @[JSON::Field(key: "x_percentage")]
    property x_percentage : Float64

    # The ordinate of the area's center, as a percentage of the media height
    @[JSON::Field(key: "y_percentage")]
    property y_percentage : Float64

    # The width of the area's rectangle, as a percentage of the media width
    @[JSON::Field(key: "width_percentage")]
    property width_percentage : Float64

    # The height of the area's rectangle, as a percentage of the media height
    @[JSON::Field(key: "height_percentage")]
    property height_percentage : Float64

    # The clockwise rotation angle of the rectangle, in degrees; 0-360
    @[JSON::Field(key: "rotation_angle")]
    property rotation_angle : Float64

    # The radius of the rectangle corner rounding, as a percentage of the media width
    @[JSON::Field(key: "corner_radius_percentage")]
    property corner_radius_percentage : Float64

  end

  # Telegram API type: LocationAddress
  # Describes the physical address of a location.
  struct LocationAddress
    include JSON::Serializable

    # The two-letter ISO 3166-1 alpha-2 country code of the country where the location is located
    @[JSON::Field(key: "country_code")]
    property country_code : String

    # Optional. State of the location
    @[JSON::Field(key: "state")]
    property state : String?

    # Optional. City of the location
    @[JSON::Field(key: "city")]
    property city : String?

    # Optional. Street address of the location
    @[JSON::Field(key: "street")]
    property street : String?

  end

  # Telegram API type: StoryAreaType
  # Describes the type of a clickable area on a story. Currently, it can be one of
  # - StoryAreaTypeLocation
  # - StoryAreaTypeSuggestedReaction
  # - StoryAreaTypeLink
  # - StoryAreaTypeWeather
  # - StoryAreaTypeUniqueGift
  struct StoryAreaType
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: StoryAreaTypeLocation
  # Describes a story area pointing to a location. Currently, a story can have up to 10 location areas.
  struct StoryAreaTypeLocation
    include JSON::Serializable

    # Type of the area, always "location"
    @[JSON::Field(key: "type")]
    property type : String

    # Location latitude in degrees
    @[JSON::Field(key: "latitude")]
    property latitude : Float64

    # Location longitude in degrees
    @[JSON::Field(key: "longitude")]
    property longitude : Float64

    # Optional. Address of the location
    @[JSON::Field(key: "address")]
    property address : LocationAddress?

  end

  # Telegram API type: StoryAreaTypeSuggestedReaction
  # Describes a story area pointing to a suggested reaction. Currently, a story can have up to 5 suggested reaction areas.
  struct StoryAreaTypeSuggestedReaction
    include JSON::Serializable

    # Type of the area, always "suggested_reaction"
    @[JSON::Field(key: "type")]
    property type : String

    # Type of the reaction
    @[JSON::Field(key: "reaction_type")]
    property reaction_type : ReactionType

    # Optional. Pass True if the reaction area has a dark background
    @[JSON::Field(key: "is_dark")]
    property is_dark : Bool?

    # Optional. Pass True if reaction area corner is flipped
    @[JSON::Field(key: "is_flipped")]
    property is_flipped : Bool?

  end

  # Telegram API type: StoryAreaTypeLink
  # Describes a story area pointing to an HTTP or tg:// link. Currently, a story can have up to 3 link areas.
  struct StoryAreaTypeLink
    include JSON::Serializable

    # Type of the area, always "link"
    @[JSON::Field(key: "type")]
    property type : String

    # HTTP or tg:// URL to be opened when the area is clicked
    @[JSON::Field(key: "url")]
    property url : String

  end

  # Telegram API type: StoryAreaTypeWeather
  # Describes a story area containing weather information. Currently, a story can have up to 3 weather areas.
  struct StoryAreaTypeWeather
    include JSON::Serializable

    # Type of the area, always "weather"
    @[JSON::Field(key: "type")]
    property type : String

    # Temperature, in degree Celsius
    @[JSON::Field(key: "temperature")]
    property temperature : Float64

    # Emoji representing the weather
    @[JSON::Field(key: "emoji")]
    property emoji : String

    # A color of the area background in the ARGB format
    @[JSON::Field(key: "background_color")]
    property background_color : Int32

  end

  # Telegram API type: StoryAreaTypeUniqueGift
  # Describes a story area pointing to a unique gift. Currently, a story can have at most 1 unique gift area.
  struct StoryAreaTypeUniqueGift
    include JSON::Serializable

    # Type of the area, always "unique_gift"
    @[JSON::Field(key: "type")]
    property type : String

    # Unique name of the gift
    @[JSON::Field(key: "name")]
    property name : String

  end

  # Telegram API type: StoryArea
  # Describes a clickable area on a story media.
  struct StoryArea
    include JSON::Serializable

    # Position of the area
    @[JSON::Field(key: "position")]
    property position : StoryAreaPosition

    # Type of the area
    @[JSON::Field(key: "type")]
    property type : StoryAreaType

  end

  # Telegram API type: ChatLocation
  # Represents a location to which a chat is connected.
  struct ChatLocation
    include JSON::Serializable

    # The location to which the supergroup is connected. Can't be a live location.
    @[JSON::Field(key: "location")]
    property location : Location

    # Location address; 1-64 characters, as defined by the chat owner
    @[JSON::Field(key: "address")]
    property address : String

  end

  # Telegram API type: ReactionType
  # This object describes the type of a reaction. Currently, it can be one of
  # - ReactionTypeEmoji
  # - ReactionTypeCustomEmoji
  # - ReactionTypePaid
  struct ReactionType
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: ReactionTypeEmoji
  # The reaction is based on an emoji.
  struct ReactionTypeEmoji
    include JSON::Serializable

    # Type of the reaction, always "emoji"
    @[JSON::Field(key: "type")]
    property type : String

    # Reaction emoji. Currently, it can be one of "❤", "👍", "👎", "🔥", "🥰", "👏", "😁", "🤔", "🤯", "😱", "🤬", "😢", "🎉", "🤩", "🤮", "💩", "🙏", "👌", "🕊", "🤡", "🥱", "🥴", "😍", "🐳", "❤‍🔥", "🌚", "🌭", "💯", "🤣", "⚡", "🍌", "🏆", "💔", "🤨", "😐", "🍓", "🍾", "💋", "🖕", "😈", "😴", "😭", "🤓", "👻", "👨‍💻", "👀", "🎃", "🙈", "😇", "😨", "🤝", "✍", "🤗", "🫡", "🎅", "🎄", "☃", "💅", "🤪", "🗿", "🆒", "💘", "🙉", "🦄", "😘", "💊", "🙊", "😎", "👾", "🤷‍♂", "🤷", "🤷‍♀", "😡"
    @[JSON::Field(key: "emoji")]
    property emoji : String

  end

  # Telegram API type: ReactionTypeCustomEmoji
  # The reaction is based on a custom emoji.
  struct ReactionTypeCustomEmoji
    include JSON::Serializable

    # Type of the reaction, always "custom_emoji"
    @[JSON::Field(key: "type")]
    property type : String

    # Custom emoji identifier
    @[JSON::Field(key: "custom_emoji_id")]
    property custom_emoji_id : String

  end

  # Telegram API type: ReactionTypePaid
  # The reaction is paid.
  struct ReactionTypePaid
    include JSON::Serializable

    # Type of the reaction, always "paid"
    @[JSON::Field(key: "type")]
    property type : String

  end

  # Telegram API type: ReactionCount
  # Represents a reaction added to a message along with the number of times it was added.
  struct ReactionCount
    include JSON::Serializable

    # Type of the reaction
    @[JSON::Field(key: "type")]
    property type : ReactionType

    # Number of times the reaction was added
    @[JSON::Field(key: "total_count")]
    property total_count : Int32

  end

  # Telegram API type: MessageReactionUpdated
  # This object represents a change of a reaction on a message performed by a user.
  struct MessageReactionUpdated
    include JSON::Serializable

    # The chat containing the message the user reacted to
    @[JSON::Field(key: "chat")]
    property chat : Chat

    # Unique identifier of the message inside the chat
    @[JSON::Field(key: "message_id")]
    property message_id : Int32

    # Optional. The user that changed the reaction, if the user isn't anonymous
    @[JSON::Field(key: "user")]
    property user : User?

    # Optional. The chat on behalf of which the reaction was changed, if the user is anonymous
    @[JSON::Field(key: "actor_chat")]
    property actor_chat : Chat?

    # Date of the change in Unix time
    @[JSON::Field(key: "date")]
    property date : Int32

    # Previous list of reaction types that were set by the user
    @[JSON::Field(key: "old_reaction")]
    property old_reaction : Array(ReactionType)

    # New list of reaction types that have been set by the user
    @[JSON::Field(key: "new_reaction")]
    property new_reaction : Array(ReactionType)

  end

  # Telegram API type: MessageReactionCountUpdated
  # This object represents reaction changes on a message with anonymous reactions.
  struct MessageReactionCountUpdated
    include JSON::Serializable

    # The chat containing the message
    @[JSON::Field(key: "chat")]
    property chat : Chat

    # Unique message identifier inside the chat
    @[JSON::Field(key: "message_id")]
    property message_id : Int32

    # Date of the change in Unix time
    @[JSON::Field(key: "date")]
    property date : Int32

    # List of reactions that are present on the message
    @[JSON::Field(key: "reactions")]
    property reactions : Array(ReactionCount)

  end

  # Telegram API type: ForumTopic
  # This object represents a forum topic.
  struct ForumTopic
    include JSON::Serializable

    # Unique identifier of the forum topic
    @[JSON::Field(key: "message_thread_id")]
    property message_thread_id : Int32

    # Name of the topic
    @[JSON::Field(key: "name")]
    property name : String

    # Color of the topic icon in RGB format
    @[JSON::Field(key: "icon_color")]
    property icon_color : Int32

    # Optional. Unique identifier of the custom emoji shown as the topic icon
    @[JSON::Field(key: "icon_custom_emoji_id")]
    property icon_custom_emoji_id : String?

  end

  # Telegram API type: Gift
  # This object represents a gift that can be sent by the bot.
  struct Gift
    include JSON::Serializable

    # Unique identifier of the gift
    @[JSON::Field(key: "id")]
    property id : String

    # The sticker that represents the gift
    @[JSON::Field(key: "sticker")]
    property sticker : Sticker

    # The number of Telegram Stars that must be paid to send the sticker
    @[JSON::Field(key: "star_count")]
    property star_count : Int32

    # Optional. The number of Telegram Stars that must be paid to upgrade the gift to a unique one
    @[JSON::Field(key: "upgrade_star_count")]
    property upgrade_star_count : Int32?

    # Optional. The total number of the gifts of this type that can be sent; for limited gifts only
    @[JSON::Field(key: "total_count")]
    property total_count : Int32?

    # Optional. The number of remaining gifts of this type that can be sent; for limited gifts only
    @[JSON::Field(key: "remaining_count")]
    property remaining_count : Int32?

    # Optional. Information about the chat that published the gift
    @[JSON::Field(key: "publisher_chat")]
    property publisher_chat : Chat?

  end

  # Telegram API type: Gifts
  # This object represent a list of gifts.
  struct Gifts
    include JSON::Serializable

    # The list of gifts
    @[JSON::Field(key: "gifts")]
    property gifts : Array(Gift)

  end

  # Telegram API type: UniqueGiftModel
  # This object describes the model of a unique gift.
  struct UniqueGiftModel
    include JSON::Serializable

    # Name of the model
    @[JSON::Field(key: "name")]
    property name : String

    # The sticker that represents the unique gift
    @[JSON::Field(key: "sticker")]
    property sticker : Sticker

    # The number of unique gifts that receive this model for every 1000 gifts upgraded
    @[JSON::Field(key: "rarity_per_mille")]
    property rarity_per_mille : Int32

  end

  # Telegram API type: UniqueGiftSymbol
  # This object describes the symbol shown on the pattern of a unique gift.
  struct UniqueGiftSymbol
    include JSON::Serializable

    # Name of the symbol
    @[JSON::Field(key: "name")]
    property name : String

    # The sticker that represents the unique gift
    @[JSON::Field(key: "sticker")]
    property sticker : Sticker

    # The number of unique gifts that receive this model for every 1000 gifts upgraded
    @[JSON::Field(key: "rarity_per_mille")]
    property rarity_per_mille : Int32

  end

  # Telegram API type: UniqueGiftBackdropColors
  # This object describes the colors of the backdrop of a unique gift.
  struct UniqueGiftBackdropColors
    include JSON::Serializable

    # The color in the center of the backdrop in RGB format
    @[JSON::Field(key: "center_color")]
    property center_color : Int32

    # The color on the edges of the backdrop in RGB format
    @[JSON::Field(key: "edge_color")]
    property edge_color : Int32

    # The color to be applied to the symbol in RGB format
    @[JSON::Field(key: "symbol_color")]
    property symbol_color : Int32

    # The color for the text on the backdrop in RGB format
    @[JSON::Field(key: "text_color")]
    property text_color : Int32

  end

  # Telegram API type: UniqueGiftBackdrop
  # This object describes the backdrop of a unique gift.
  struct UniqueGiftBackdrop
    include JSON::Serializable

    # Name of the backdrop
    @[JSON::Field(key: "name")]
    property name : String

    # Colors of the backdrop
    @[JSON::Field(key: "colors")]
    property colors : UniqueGiftBackdropColors

    # The number of unique gifts that receive this backdrop for every 1000 gifts upgraded
    @[JSON::Field(key: "rarity_per_mille")]
    property rarity_per_mille : Int32

  end

  # Telegram API type: UniqueGift
  # This object describes a unique gift that was upgraded from a regular gift.
  struct UniqueGift
    include JSON::Serializable

    # Human-readable name of the regular gift from which this unique gift was upgraded
    @[JSON::Field(key: "base_name")]
    property base_name : String

    # Unique name of the gift. This name can be used in https://t.me/nft/... links and story areas
    @[JSON::Field(key: "name")]
    property name : String

    # Unique number of the upgraded gift among gifts upgraded from the same regular gift
    @[JSON::Field(key: "number")]
    property number : Int32

    # Model of the gift
    @[JSON::Field(key: "model")]
    property model : UniqueGiftModel

    # Symbol of the gift
    @[JSON::Field(key: "symbol")]
    property symbol : UniqueGiftSymbol

    # Backdrop of the gift
    @[JSON::Field(key: "backdrop")]
    property backdrop : UniqueGiftBackdrop

    # Optional. Information about the chat that published the gift
    @[JSON::Field(key: "publisher_chat")]
    property publisher_chat : Chat?

  end

  # Telegram API type: GiftInfo
  # Describes a service message about a regular gift that was sent or received.
  struct GiftInfo
    include JSON::Serializable

    # Information about the gift
    @[JSON::Field(key: "gift")]
    property gift : Gift

    # Optional. Unique identifier of the received gift for the bot; only present for gifts received on behalf of business accounts
    @[JSON::Field(key: "owned_gift_id")]
    property owned_gift_id : String?

    # Optional. Number of Telegram Stars that can be claimed by the receiver by converting the gift; omitted if conversion to Telegram Stars is impossible
    @[JSON::Field(key: "convert_star_count")]
    property convert_star_count : Int32?

    # Optional. Number of Telegram Stars that were prepaid by the sender for the ability to upgrade the gift
    @[JSON::Field(key: "prepaid_upgrade_star_count")]
    property prepaid_upgrade_star_count : Int32?

    # Optional. True, if the gift can be upgraded to a unique gift
    @[JSON::Field(key: "can_be_upgraded")]
    property can_be_upgraded : Bool?

    # Optional. Text of the message that was added to the gift
    @[JSON::Field(key: "text")]
    property text : String?

    # Optional. Special entities that appear in the text
    @[JSON::Field(key: "entities")]
    property entities : Array(MessageEntity)?

    # Optional. True, if the sender and gift text are shown only to the gift receiver; otherwise, everyone will be able to see them
    @[JSON::Field(key: "is_private")]
    property is_private : Bool?

  end

  # Telegram API type: UniqueGiftInfo
  # Describes a service message about a unique gift that was sent or received.
  struct UniqueGiftInfo
    include JSON::Serializable

    # Information about the gift
    @[JSON::Field(key: "gift")]
    property gift : UniqueGift

    # Origin of the gift. Currently, either "upgrade" for gifts upgraded from regular gifts, "transfer" for gifts transferred from other users or channels, or "resale" for gifts bought from other users
    @[JSON::Field(key: "origin")]
    property origin : String

    # Optional. For gifts bought from other users, the price paid for the gift
    @[JSON::Field(key: "last_resale_star_count")]
    property last_resale_star_count : Int32?

    # Optional. Unique identifier of the received gift for the bot; only present for gifts received on behalf of business accounts
    @[JSON::Field(key: "owned_gift_id")]
    property owned_gift_id : String?

    # Optional. Number of Telegram Stars that must be paid to transfer the gift; omitted if the bot cannot transfer the gift
    @[JSON::Field(key: "transfer_star_count")]
    property transfer_star_count : Int32?

    # Optional. Point in time (Unix timestamp) when the gift can be transferred. If it is in the past, then the gift can be transferred now
    @[JSON::Field(key: "next_transfer_date")]
    property next_transfer_date : Int32?

  end

  # Telegram API type: OwnedGift
  # This object describes a gift received and owned by a user or a chat. Currently, it can be one of
  # - OwnedGiftRegular
  # - OwnedGiftUnique
  struct OwnedGift
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: OwnedGiftRegular
  # Describes a regular gift owned by a user or a chat.
  struct OwnedGiftRegular
    include JSON::Serializable

    # Type of the gift, always "regular"
    @[JSON::Field(key: "type")]
    property type : String

    # Information about the regular gift
    @[JSON::Field(key: "gift")]
    property gift : Gift

    # Optional. Unique identifier of the gift for the bot; for gifts received on behalf of business accounts only
    @[JSON::Field(key: "owned_gift_id")]
    property owned_gift_id : String?

    # Optional. Sender of the gift if it is a known user
    @[JSON::Field(key: "sender_user")]
    property sender_user : User?

    # Date the gift was sent in Unix time
    @[JSON::Field(key: "send_date")]
    property send_date : Int32

    # Optional. Text of the message that was added to the gift
    @[JSON::Field(key: "text")]
    property text : String?

    # Optional. Special entities that appear in the text
    @[JSON::Field(key: "entities")]
    property entities : Array(MessageEntity)?

    # Optional. True, if the sender and gift text are shown only to the gift receiver; otherwise, everyone will be able to see them
    @[JSON::Field(key: "is_private")]
    property is_private : Bool?

    # Optional. True, if the gift is displayed on the account's profile page; for gifts received on behalf of business accounts only
    @[JSON::Field(key: "is_saved")]
    property is_saved : Bool?

    # Optional. True, if the gift can be upgraded to a unique gift; for gifts received on behalf of business accounts only
    @[JSON::Field(key: "can_be_upgraded")]
    property can_be_upgraded : Bool?

    # Optional. True, if the gift was refunded and isn't available anymore
    @[JSON::Field(key: "was_refunded")]
    property was_refunded : Bool?

    # Optional. Number of Telegram Stars that can be claimed by the receiver instead of the gift; omitted if the gift cannot be converted to Telegram Stars
    @[JSON::Field(key: "convert_star_count")]
    property convert_star_count : Int32?

    # Optional. Number of Telegram Stars that were paid by the sender for the ability to upgrade the gift
    @[JSON::Field(key: "prepaid_upgrade_star_count")]
    property prepaid_upgrade_star_count : Int32?

  end

  # Telegram API type: OwnedGiftUnique
  # Describes a unique gift received and owned by a user or a chat.
  struct OwnedGiftUnique
    include JSON::Serializable

    # Type of the gift, always "unique"
    @[JSON::Field(key: "type")]
    property type : String

    # Information about the unique gift
    @[JSON::Field(key: "gift")]
    property gift : UniqueGift

    # Optional. Unique identifier of the received gift for the bot; for gifts received on behalf of business accounts only
    @[JSON::Field(key: "owned_gift_id")]
    property owned_gift_id : String?

    # Optional. Sender of the gift if it is a known user
    @[JSON::Field(key: "sender_user")]
    property sender_user : User?

    # Date the gift was sent in Unix time
    @[JSON::Field(key: "send_date")]
    property send_date : Int32

    # Optional. True, if the gift is displayed on the account's profile page; for gifts received on behalf of business accounts only
    @[JSON::Field(key: "is_saved")]
    property is_saved : Bool?

    # Optional. True, if the gift can be transferred to another owner; for gifts received on behalf of business accounts only
    @[JSON::Field(key: "can_be_transferred")]
    property can_be_transferred : Bool?

    # Optional. Number of Telegram Stars that must be paid to transfer the gift; omitted if the bot cannot transfer the gift
    @[JSON::Field(key: "transfer_star_count")]
    property transfer_star_count : Int32?

    # Optional. Point in time (Unix timestamp) when the gift can be transferred. If it is in the past, then the gift can be transferred now
    @[JSON::Field(key: "next_transfer_date")]
    property next_transfer_date : Int32?

  end

  # Telegram API type: OwnedGifts
  # Contains the list of gifts received and owned by a user or a chat.
  struct OwnedGifts
    include JSON::Serializable

    # The total number of gifts owned by the user or the chat
    @[JSON::Field(key: "total_count")]
    property total_count : Int32

    # The list of gifts
    @[JSON::Field(key: "gifts")]
    property gifts : Array(OwnedGift)

    # Optional. Offset for the next request. If empty, then there are no more results
    @[JSON::Field(key: "next_offset")]
    property next_offset : String?

  end

  # Telegram API type: AcceptedGiftTypes
  # This object describes the types of gifts that can be gifted to a user or a chat.
  struct AcceptedGiftTypes
    include JSON::Serializable

    # True, if unlimited regular gifts are accepted
    @[JSON::Field(key: "unlimited_gifts")]
    property unlimited_gifts : Bool

    # True, if limited regular gifts are accepted
    @[JSON::Field(key: "limited_gifts")]
    property limited_gifts : Bool

    # True, if unique gifts or gifts that can be upgraded to unique for free are accepted
    @[JSON::Field(key: "unique_gifts")]
    property unique_gifts : Bool

    # True, if a Telegram Premium subscription is accepted
    @[JSON::Field(key: "premium_subscription")]
    property premium_subscription : Bool

  end

  # Telegram API type: StarAmount
  # Describes an amount of Telegram Stars.
  struct StarAmount
    include JSON::Serializable

    # Integer amount of Telegram Stars, rounded to 0; can be negative
    @[JSON::Field(key: "amount")]
    property amount : Int32

    # Optional. The number of 1/1000000000 shares of Telegram Stars; from -999999999 to 999999999; can be negative if and only if amount is non-positive
    @[JSON::Field(key: "nanostar_amount")]
    property nanostar_amount : Int32?

  end

  # Telegram API type: BotCommand
  # This object represents a bot command.
  class BotCommand
    include JSON::Serializable

    # Text of the command; 1-32 characters. Can contain only lowercase English letters, digits and underscores.
    @[JSON::Field(key: "command")]
    property command : String

    # Description of the command; 1-256 characters.
    @[JSON::Field(key: "description")]
    property description : String

  end

  # Telegram API type: BotCommandScope
  # This object represents the scope to which bot commands are applied. Currently, the following 7 scopes are supported:
  # - BotCommandScopeDefault
  # - BotCommandScopeAllPrivateChats
  # - BotCommandScopeAllGroupChats
  # - BotCommandScopeAllChatAdministrators
  # - BotCommandScopeChat
  # - BotCommandScopeChatAdministrators
  # - BotCommandScopeChatMember
  struct BotCommandScope
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: BotCommandScopeDefault
  # Represents the default scope of bot commands. Default commands are used if no commands with a narrower scope are specified for the user.
  struct BotCommandScopeDefault
    include JSON::Serializable

    # Scope type, must be default
    @[JSON::Field(key: "type")]
    property type : String

  end

  # Telegram API type: BotCommandScopeAllPrivateChats
  # Represents the scope of bot commands, covering all private chats.
  struct BotCommandScopeAllPrivateChats
    include JSON::Serializable

    # Scope type, must be all_private_chats
    @[JSON::Field(key: "type")]
    property type : String

  end

  # Telegram API type: BotCommandScopeAllGroupChats
  # Represents the scope of bot commands, covering all group and supergroup chats.
  struct BotCommandScopeAllGroupChats
    include JSON::Serializable

    # Scope type, must be all_group_chats
    @[JSON::Field(key: "type")]
    property type : String

  end

  # Telegram API type: BotCommandScopeAllChatAdministrators
  # Represents the scope of bot commands, covering all group and supergroup chat administrators.
  struct BotCommandScopeAllChatAdministrators
    include JSON::Serializable

    # Scope type, must be all_chat_administrators
    @[JSON::Field(key: "type")]
    property type : String

  end

  # Telegram API type: BotCommandScopeChat
  # Represents the scope of bot commands, covering a specific chat.
  struct BotCommandScopeChat
    include JSON::Serializable

    # Scope type, must be chat
    @[JSON::Field(key: "type")]
    property type : String

    # Unique identifier for the target chat or username of the target supergroup (in the format @supergroupusername). Channel direct messages chats and channel chats aren't supported.
    @[JSON::Field(key: "chat_id")]
    property chat_id : Int32 | String

  end

  # Telegram API type: BotCommandScopeChatAdministrators
  # Represents the scope of bot commands, covering all administrators of a specific group or supergroup chat.
  struct BotCommandScopeChatAdministrators
    include JSON::Serializable

    # Scope type, must be chat_administrators
    @[JSON::Field(key: "type")]
    property type : String

    # Unique identifier for the target chat or username of the target supergroup (in the format @supergroupusername). Channel direct messages chats and channel chats aren't supported.
    @[JSON::Field(key: "chat_id")]
    property chat_id : Int32 | String

  end

  # Telegram API type: BotCommandScopeChatMember
  # Represents the scope of bot commands, covering a specific member of a group or supergroup chat.
  struct BotCommandScopeChatMember
    include JSON::Serializable

    # Scope type, must be chat_member
    @[JSON::Field(key: "type")]
    property type : String

    # Unique identifier for the target chat or username of the target supergroup (in the format @supergroupusername). Channel direct messages chats and channel chats aren't supported.
    @[JSON::Field(key: "chat_id")]
    property chat_id : Int32 | String

    # Unique identifier of the target user
    @[JSON::Field(key: "user_id")]
    property user_id : Int32

  end

  # Telegram API type: BotName
  # This object represents the bot's name.
  struct BotName
    include JSON::Serializable

    # The bot's name
    @[JSON::Field(key: "name")]
    property name : String

  end

  # Telegram API type: BotDescription
  # This object represents the bot's description.
  struct BotDescription
    include JSON::Serializable

    # The bot's description
    @[JSON::Field(key: "description")]
    property description : String

  end

  # Telegram API type: BotShortDescription
  # This object represents the bot's short description.
  struct BotShortDescription
    include JSON::Serializable

    # The bot's short description
    @[JSON::Field(key: "short_description")]
    property short_description : String

  end

  # Telegram API type: MenuButton
  # This object describes the bot's menu button in a private chat. It should be one of
  # - MenuButtonCommands
  # - MenuButtonWebApp
  # - MenuButtonDefault
  # If a menu button other than MenuButtonDefault is set for a private chat, then it is applied in the chat. Otherwise the default menu button is applied. By default, the menu button opens the list of bot commands.
  struct MenuButton
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: MenuButtonCommands
  # Represents a menu button, which opens the bot's list of commands.
  struct MenuButtonCommands
    include JSON::Serializable

    # Type of the button, must be commands
    @[JSON::Field(key: "type")]
    property type : String

  end

  # Telegram API type: MenuButtonWebApp
  # Represents a menu button, which launches a Web App.
  struct MenuButtonWebApp
    include JSON::Serializable

    # Type of the button, must be web_app
    @[JSON::Field(key: "type")]
    property type : String

    # Text on the button
    @[JSON::Field(key: "text")]
    property text : String

    # Description of the Web App that will be launched when the user presses the button. The Web App will be able to send an arbitrary message on behalf of the user using the method answerWebAppQuery. Alternatively, a t.me link to a Web App of the bot can be specified in the object instead of the Web App's URL, in which case the Web App will be opened as if the user pressed the link.
    @[JSON::Field(key: "web_app")]
    property web_app : WebAppInfo

  end

  # Telegram API type: MenuButtonDefault
  # Describes that no specific value for the menu button was set.
  struct MenuButtonDefault
    include JSON::Serializable

    # Type of the button, must be default
    @[JSON::Field(key: "type")]
    property type : String

  end

  # Telegram API type: ChatBoostSource
  # This object describes the source of a chat boost. It can be one of
  # - ChatBoostSourcePremium
  # - ChatBoostSourceGiftCode
  # - ChatBoostSourceGiveaway
  struct ChatBoostSource
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: ChatBoostSourcePremium
  # The boost was obtained by subscribing to Telegram Premium or by gifting a Telegram Premium subscription to another user.
  struct ChatBoostSourcePremium
    include JSON::Serializable

    # Source of the boost, always "premium"
    @[JSON::Field(key: "source")]
    property source : String

    # User that boosted the chat
    @[JSON::Field(key: "user")]
    property user : User

  end

  # Telegram API type: ChatBoostSourceGiftCode
  # The boost was obtained by the creation of Telegram Premium gift codes to boost a chat. Each such code boosts the chat 4 times for the duration of the corresponding Telegram Premium subscription.
  struct ChatBoostSourceGiftCode
    include JSON::Serializable

    # Source of the boost, always "gift_code"
    @[JSON::Field(key: "source")]
    property source : String

    # User for which the gift code was created
    @[JSON::Field(key: "user")]
    property user : User

  end

  # Telegram API type: ChatBoostSourceGiveaway
  # The boost was obtained by the creation of a Telegram Premium or a Telegram Star giveaway. This boosts the chat 4 times for the duration of the corresponding Telegram Premium subscription for Telegram Premium giveaways and prize_star_count / 500 times for one year for Telegram Star giveaways.
  struct ChatBoostSourceGiveaway
    include JSON::Serializable

    # Source of the boost, always "giveaway"
    @[JSON::Field(key: "source")]
    property source : String

    # Identifier of a message in the chat with the giveaway; the message could have been deleted already. May be 0 if the message isn't sent yet.
    @[JSON::Field(key: "giveaway_message_id")]
    property giveaway_message_id : Int32

    # Optional. User that won the prize in the giveaway if any; for Telegram Premium giveaways only
    @[JSON::Field(key: "user")]
    property user : User?

    # Optional. The number of Telegram Stars to be split between giveaway winners; for Telegram Star giveaways only
    @[JSON::Field(key: "prize_star_count")]
    property prize_star_count : Int32?

    # Optional. True, if the giveaway was completed, but there was no user to win the prize
    @[JSON::Field(key: "is_unclaimed")]
    property is_unclaimed : Bool?

  end

  # Telegram API type: ChatBoost
  # This object contains information about a chat boost.
  struct ChatBoost
    include JSON::Serializable

    # Unique identifier of the boost
    @[JSON::Field(key: "boost_id")]
    property boost_id : String

    # Point in time (Unix timestamp) when the chat was boosted
    @[JSON::Field(key: "add_date")]
    property add_date : Int32

    # Point in time (Unix timestamp) when the boost will automatically expire, unless the booster's Telegram Premium subscription is prolonged
    @[JSON::Field(key: "expiration_date")]
    property expiration_date : Int32

    # Source of the added boost
    @[JSON::Field(key: "source")]
    property source : ChatBoostSource

  end

  # Telegram API type: ChatBoostUpdated
  # This object represents a boost added to a chat or changed.
  struct ChatBoostUpdated
    include JSON::Serializable

    # Chat which was boosted
    @[JSON::Field(key: "chat")]
    property chat : Chat

    # Information about the chat boost
    @[JSON::Field(key: "boost")]
    property boost : ChatBoost

  end

  # Telegram API type: ChatBoostRemoved
  # This object represents a boost removed from a chat.
  struct ChatBoostRemoved
    include JSON::Serializable

    # Chat which was boosted
    @[JSON::Field(key: "chat")]
    property chat : Chat

    # Unique identifier of the boost
    @[JSON::Field(key: "boost_id")]
    property boost_id : String

    # Point in time (Unix timestamp) when the boost was removed
    @[JSON::Field(key: "remove_date")]
    property remove_date : Int32

    # Source of the removed boost
    @[JSON::Field(key: "source")]
    property source : ChatBoostSource

  end

  # Telegram API type: UserChatBoosts
  # This object represents a list of boosts added to a chat by a user.
  struct UserChatBoosts
    include JSON::Serializable

    # The list of boosts added to the chat by the user
    @[JSON::Field(key: "boosts")]
    property boosts : Array(ChatBoost)

  end

  # Telegram API type: BusinessBotRights
  # Represents the rights of a business bot.
  struct BusinessBotRights
    include JSON::Serializable

    # Optional. True, if the bot can send and edit messages in the private chats that had incoming messages in the last 24 hours
    @[JSON::Field(key: "can_reply")]
    property can_reply : Bool?

    # Optional. True, if the bot can mark incoming private messages as read
    @[JSON::Field(key: "can_read_messages")]
    property can_read_messages : Bool?

    # Optional. True, if the bot can delete messages sent by the bot
    @[JSON::Field(key: "can_delete_sent_messages")]
    property can_delete_sent_messages : Bool?

    # Optional. True, if the bot can delete all private messages in managed chats
    @[JSON::Field(key: "can_delete_all_messages")]
    property can_delete_all_messages : Bool?

    # Optional. True, if the bot can edit the first and last name of the business account
    @[JSON::Field(key: "can_edit_name")]
    property can_edit_name : Bool?

    # Optional. True, if the bot can edit the bio of the business account
    @[JSON::Field(key: "can_edit_bio")]
    property can_edit_bio : Bool?

    # Optional. True, if the bot can edit the profile photo of the business account
    @[JSON::Field(key: "can_edit_profile_photo")]
    property can_edit_profile_photo : Bool?

    # Optional. True, if the bot can edit the username of the business account
    @[JSON::Field(key: "can_edit_username")]
    property can_edit_username : Bool?

    # Optional. True, if the bot can change the privacy settings pertaining to gifts for the business account
    @[JSON::Field(key: "can_change_gift_settings")]
    property can_change_gift_settings : Bool?

    # Optional. True, if the bot can view gifts and the amount of Telegram Stars owned by the business account
    @[JSON::Field(key: "can_view_gifts_and_stars")]
    property can_view_gifts_and_stars : Bool?

    # Optional. True, if the bot can convert regular gifts owned by the business account to Telegram Stars
    @[JSON::Field(key: "can_convert_gifts_to_stars")]
    property can_convert_gifts_to_stars : Bool?

    # Optional. True, if the bot can transfer and upgrade gifts owned by the business account
    @[JSON::Field(key: "can_transfer_and_upgrade_gifts")]
    property can_transfer_and_upgrade_gifts : Bool?

    # Optional. True, if the bot can transfer Telegram Stars received by the business account to its own account, or use them to upgrade and transfer gifts
    @[JSON::Field(key: "can_transfer_stars")]
    property can_transfer_stars : Bool?

    # Optional. True, if the bot can post, edit and delete stories on behalf of the business account
    @[JSON::Field(key: "can_manage_stories")]
    property can_manage_stories : Bool?

  end

  # Telegram API type: BusinessConnection
  # Describes the connection of the bot with a business account.
  struct BusinessConnection
    include JSON::Serializable

    # Unique identifier of the business connection
    @[JSON::Field(key: "id")]
    property id : String

    # Business account user that created the business connection
    @[JSON::Field(key: "user")]
    property user : User

    # Identifier of a private chat with the user who created the business connection. This number may have more than 32 significant bits and some programming languages may have difficulty/silent defects in interpreting it. But it has at most 52 significant bits, so a 64-bit integer or double-precision float type are safe for storing this identifier.
    @[JSON::Field(key: "user_chat_id")]
    property user_chat_id : Int32

    # Date the connection was established in Unix time
    @[JSON::Field(key: "date")]
    property date : Int32

    # Optional. Rights of the business bot
    @[JSON::Field(key: "rights")]
    property rights : BusinessBotRights?

    # True, if the connection is active
    @[JSON::Field(key: "is_enabled")]
    property is_enabled : Bool

  end

  # Telegram API type: BusinessMessagesDeleted
  # This object is received when messages are deleted from a connected business account.
  struct BusinessMessagesDeleted
    include JSON::Serializable

    # Unique identifier of the business connection
    @[JSON::Field(key: "business_connection_id")]
    property business_connection_id : String

    # Information about a chat in the business account. The bot may not have access to the chat or the corresponding user.
    @[JSON::Field(key: "chat")]
    property chat : Chat

    # The list of identifiers of deleted messages in the chat of the business account
    @[JSON::Field(key: "message_ids")]
    property message_ids : Array(Int32)

  end

  # Telegram API type: ResponseParameters
  # Describes why a request was unsuccessful.
  struct ResponseParameters
    include JSON::Serializable

    # Optional. The group has been migrated to a supergroup with the specified identifier. This number may have more than 32 significant bits and some programming languages may have difficulty/silent defects in interpreting it. But it has at most 52 significant bits, so a signed 64-bit integer or double-precision float type are safe for storing this identifier.
    @[JSON::Field(key: "migrate_to_chat_id")]
    property migrate_to_chat_id : Int32?

    # Optional. In case of exceeding flood control, the number of seconds left to wait before the request can be repeated
    @[JSON::Field(key: "retry_after")]
    property retry_after : Int32?

  end

  # Telegram API type: InputMedia
  # This object represents the content of a media message to be sent. It should be one of
  # - InputMediaAnimation
  # - InputMediaDocument
  # - InputMediaAudio
  # - InputMediaPhoto
  # - InputMediaVideo
  struct InputMedia
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: InputMediaPhoto
  # Represents a photo to be sent.
  struct InputMediaPhoto
    include JSON::Serializable

    # Type of the result, must be photo
    @[JSON::Field(key: "type")]
    property type : String

    # File to send. Pass a file_id to send a file that exists on the Telegram servers (recommended), pass an HTTP URL for Telegram to get a file from the Internet, or pass "attach://<file_attach_name>" to upload a new one using multipart/form-data under <file_attach_name> name. More information on Sending Files: https://core.telegram.org/bots/api#sending-files
    @[JSON::Field(key: "media")]
    property media : String

    # Optional. Caption of the photo to be sent, 0-1024 characters after entities parsing
    @[JSON::Field(key: "caption")]
    property caption : String?

    # Optional. Mode for parsing entities in the photo caption. See formatting options for more details.
    @[JSON::Field(key: "parse_mode")]
    property parse_mode : String?

    # Optional. List of special entities that appear in the caption, which can be specified instead of parse_mode
    @[JSON::Field(key: "caption_entities")]
    property caption_entities : Array(MessageEntity)?

    # Optional. Pass True, if the caption must be shown above the message media
    @[JSON::Field(key: "show_caption_above_media")]
    property show_caption_above_media : Bool?

    # Optional. Pass True if the photo needs to be covered with a spoiler animation
    @[JSON::Field(key: "has_spoiler")]
    property has_spoiler : Bool?

  end

  # Telegram API type: InputMediaVideo
  # Represents a video to be sent.
  struct InputMediaVideo
    include JSON::Serializable

    # Type of the result, must be video
    @[JSON::Field(key: "type")]
    property type : String

    # File to send. Pass a file_id to send a file that exists on the Telegram servers (recommended), pass an HTTP URL for Telegram to get a file from the Internet, or pass "attach://<file_attach_name>" to upload a new one using multipart/form-data under <file_attach_name> name. More information on Sending Files: https://core.telegram.org/bots/api#sending-files
    @[JSON::Field(key: "media")]
    property media : String

    # Optional. Thumbnail of the file sent; can be ignored if thumbnail generation for the file is supported server-side. The thumbnail should be in JPEG format and less than 200 kB in size. A thumbnail's width and height should not exceed 320. Ignored if the file is not uploaded using multipart/form-data. Thumbnails can't be reused and can be only uploaded as a new file, so you can pass "attach://<file_attach_name>" if the thumbnail was uploaded using multipart/form-data under <file_attach_name>. More information on Sending Files: https://core.telegram.org/bots/api#sending-files
    @[JSON::Field(key: "thumbnail")]
    property thumbnail : String?

    # Optional. Cover for the video in the message. Pass a file_id to send a file that exists on the Telegram servers (recommended), pass an HTTP URL for Telegram to get a file from the Internet, or pass "attach://<file_attach_name>" to upload a new one using multipart/form-data under <file_attach_name> name. More information on Sending Files: https://core.telegram.org/bots/api#sending-files
    @[JSON::Field(key: "cover")]
    property cover : String?

    # Optional. Start timestamp for the video in the message
    @[JSON::Field(key: "start_timestamp")]
    property start_timestamp : Int32?

    # Optional. Caption of the video to be sent, 0-1024 characters after entities parsing
    @[JSON::Field(key: "caption")]
    property caption : String?

    # Optional. Mode for parsing entities in the video caption. See formatting options for more details.
    @[JSON::Field(key: "parse_mode")]
    property parse_mode : String?

    # Optional. List of special entities that appear in the caption, which can be specified instead of parse_mode
    @[JSON::Field(key: "caption_entities")]
    property caption_entities : Array(MessageEntity)?

    # Optional. Pass True, if the caption must be shown above the message media
    @[JSON::Field(key: "show_caption_above_media")]
    property show_caption_above_media : Bool?

    # Optional. Video width
    @[JSON::Field(key: "width")]
    property width : Int32?

    # Optional. Video height
    @[JSON::Field(key: "height")]
    property height : Int32?

    # Optional. Video duration in seconds
    @[JSON::Field(key: "duration")]
    property duration : Int32?

    # Optional. Pass True if the uploaded video is suitable for streaming
    @[JSON::Field(key: "supports_streaming")]
    property supports_streaming : Bool?

    # Optional. Pass True if the video needs to be covered with a spoiler animation
    @[JSON::Field(key: "has_spoiler")]
    property has_spoiler : Bool?

  end

  # Telegram API type: InputMediaAnimation
  # Represents an animation file (GIF or H.264/MPEG-4 AVC video without sound) to be sent.
  struct InputMediaAnimation
    include JSON::Serializable

    # Type of the result, must be animation
    @[JSON::Field(key: "type")]
    property type : String

    # File to send. Pass a file_id to send a file that exists on the Telegram servers (recommended), pass an HTTP URL for Telegram to get a file from the Internet, or pass "attach://<file_attach_name>" to upload a new one using multipart/form-data under <file_attach_name> name. More information on Sending Files: https://core.telegram.org/bots/api#sending-files
    @[JSON::Field(key: "media")]
    property media : String

    # Optional. Thumbnail of the file sent; can be ignored if thumbnail generation for the file is supported server-side. The thumbnail should be in JPEG format and less than 200 kB in size. A thumbnail's width and height should not exceed 320. Ignored if the file is not uploaded using multipart/form-data. Thumbnails can't be reused and can be only uploaded as a new file, so you can pass "attach://<file_attach_name>" if the thumbnail was uploaded using multipart/form-data under <file_attach_name>. More information on Sending Files: https://core.telegram.org/bots/api#sending-files
    @[JSON::Field(key: "thumbnail")]
    property thumbnail : String?

    # Optional. Caption of the animation to be sent, 0-1024 characters after entities parsing
    @[JSON::Field(key: "caption")]
    property caption : String?

    # Optional. Mode for parsing entities in the animation caption. See formatting options for more details.
    @[JSON::Field(key: "parse_mode")]
    property parse_mode : String?

    # Optional. List of special entities that appear in the caption, which can be specified instead of parse_mode
    @[JSON::Field(key: "caption_entities")]
    property caption_entities : Array(MessageEntity)?

    # Optional. Pass True, if the caption must be shown above the message media
    @[JSON::Field(key: "show_caption_above_media")]
    property show_caption_above_media : Bool?

    # Optional. Animation width
    @[JSON::Field(key: "width")]
    property width : Int32?

    # Optional. Animation height
    @[JSON::Field(key: "height")]
    property height : Int32?

    # Optional. Animation duration in seconds
    @[JSON::Field(key: "duration")]
    property duration : Int32?

    # Optional. Pass True if the animation needs to be covered with a spoiler animation
    @[JSON::Field(key: "has_spoiler")]
    property has_spoiler : Bool?

  end

  # Telegram API type: InputMediaAudio
  # Represents an audio file to be treated as music to be sent.
  struct InputMediaAudio
    include JSON::Serializable

    # Type of the result, must be audio
    @[JSON::Field(key: "type")]
    property type : String

    # File to send. Pass a file_id to send a file that exists on the Telegram servers (recommended), pass an HTTP URL for Telegram to get a file from the Internet, or pass "attach://<file_attach_name>" to upload a new one using multipart/form-data under <file_attach_name> name. More information on Sending Files: https://core.telegram.org/bots/api#sending-files
    @[JSON::Field(key: "media")]
    property media : String

    # Optional. Thumbnail of the file sent; can be ignored if thumbnail generation for the file is supported server-side. The thumbnail should be in JPEG format and less than 200 kB in size. A thumbnail's width and height should not exceed 320. Ignored if the file is not uploaded using multipart/form-data. Thumbnails can't be reused and can be only uploaded as a new file, so you can pass "attach://<file_attach_name>" if the thumbnail was uploaded using multipart/form-data under <file_attach_name>. More information on Sending Files: https://core.telegram.org/bots/api#sending-files
    @[JSON::Field(key: "thumbnail")]
    property thumbnail : String?

    # Optional. Caption of the audio to be sent, 0-1024 characters after entities parsing
    @[JSON::Field(key: "caption")]
    property caption : String?

    # Optional. Mode for parsing entities in the audio caption. See formatting options for more details.
    @[JSON::Field(key: "parse_mode")]
    property parse_mode : String?

    # Optional. List of special entities that appear in the caption, which can be specified instead of parse_mode
    @[JSON::Field(key: "caption_entities")]
    property caption_entities : Array(MessageEntity)?

    # Optional. Duration of the audio in seconds
    @[JSON::Field(key: "duration")]
    property duration : Int32?

    # Optional. Performer of the audio
    @[JSON::Field(key: "performer")]
    property performer : String?

    # Optional. Title of the audio
    @[JSON::Field(key: "title")]
    property title : String?

  end

  # Telegram API type: InputMediaDocument
  # Represents a general file to be sent.
  struct InputMediaDocument
    include JSON::Serializable

    # Type of the result, must be document
    @[JSON::Field(key: "type")]
    property type : String

    # File to send. Pass a file_id to send a file that exists on the Telegram servers (recommended), pass an HTTP URL for Telegram to get a file from the Internet, or pass "attach://<file_attach_name>" to upload a new one using multipart/form-data under <file_attach_name> name. More information on Sending Files: https://core.telegram.org/bots/api#sending-files
    @[JSON::Field(key: "media")]
    property media : String

    # Optional. Thumbnail of the file sent; can be ignored if thumbnail generation for the file is supported server-side. The thumbnail should be in JPEG format and less than 200 kB in size. A thumbnail's width and height should not exceed 320. Ignored if the file is not uploaded using multipart/form-data. Thumbnails can't be reused and can be only uploaded as a new file, so you can pass "attach://<file_attach_name>" if the thumbnail was uploaded using multipart/form-data under <file_attach_name>. More information on Sending Files: https://core.telegram.org/bots/api#sending-files
    @[JSON::Field(key: "thumbnail")]
    property thumbnail : String?

    # Optional. Caption of the document to be sent, 0-1024 characters after entities parsing
    @[JSON::Field(key: "caption")]
    property caption : String?

    # Optional. Mode for parsing entities in the document caption. See formatting options for more details.
    @[JSON::Field(key: "parse_mode")]
    property parse_mode : String?

    # Optional. List of special entities that appear in the caption, which can be specified instead of parse_mode
    @[JSON::Field(key: "caption_entities")]
    property caption_entities : Array(MessageEntity)?

    # Optional. Disables automatic server-side content type detection for files uploaded using multipart/form-data. Always True, if the document is sent as part of an album.
    @[JSON::Field(key: "disable_content_type_detection")]
    property disable_content_type_detection : Bool?

  end

  # Telegram API type: InputFile
  # This object represents the contents of a file to be uploaded. Must be posted using multipart/form-data in the usual way that files are uploaded via the browser.
  struct InputFile
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: InputPaidMedia
  # This object describes the paid media to be sent. Currently, it can be one of
  # - InputPaidMediaPhoto
  # - InputPaidMediaVideo
  struct InputPaidMedia
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: InputPaidMediaPhoto
  # The paid media to send is a photo.
  struct InputPaidMediaPhoto
    include JSON::Serializable

    # Type of the media, must be photo
    @[JSON::Field(key: "type")]
    property type : String

    # File to send. Pass a file_id to send a file that exists on the Telegram servers (recommended), pass an HTTP URL for Telegram to get a file from the Internet, or pass "attach://<file_attach_name>" to upload a new one using multipart/form-data under <file_attach_name> name. More information on Sending Files: https://core.telegram.org/bots/api#sending-files
    @[JSON::Field(key: "media")]
    property media : String

  end

  # Telegram API type: InputPaidMediaVideo
  # The paid media to send is a video.
  struct InputPaidMediaVideo
    include JSON::Serializable

    # Type of the media, must be video
    @[JSON::Field(key: "type")]
    property type : String

    # File to send. Pass a file_id to send a file that exists on the Telegram servers (recommended), pass an HTTP URL for Telegram to get a file from the Internet, or pass "attach://<file_attach_name>" to upload a new one using multipart/form-data under <file_attach_name> name. More information on Sending Files: https://core.telegram.org/bots/api#sending-files
    @[JSON::Field(key: "media")]
    property media : String

    # Optional. Thumbnail of the file sent; can be ignored if thumbnail generation for the file is supported server-side. The thumbnail should be in JPEG format and less than 200 kB in size. A thumbnail's width and height should not exceed 320. Ignored if the file is not uploaded using multipart/form-data. Thumbnails can't be reused and can be only uploaded as a new file, so you can pass "attach://<file_attach_name>" if the thumbnail was uploaded using multipart/form-data under <file_attach_name>. More information on Sending Files: https://core.telegram.org/bots/api#sending-files
    @[JSON::Field(key: "thumbnail")]
    property thumbnail : String?

    # Optional. Cover for the video in the message. Pass a file_id to send a file that exists on the Telegram servers (recommended), pass an HTTP URL for Telegram to get a file from the Internet, or pass "attach://<file_attach_name>" to upload a new one using multipart/form-data under <file_attach_name> name. More information on Sending Files: https://core.telegram.org/bots/api#sending-files
    @[JSON::Field(key: "cover")]
    property cover : String?

    # Optional. Start timestamp for the video in the message
    @[JSON::Field(key: "start_timestamp")]
    property start_timestamp : Int32?

    # Optional. Video width
    @[JSON::Field(key: "width")]
    property width : Int32?

    # Optional. Video height
    @[JSON::Field(key: "height")]
    property height : Int32?

    # Optional. Video duration in seconds
    @[JSON::Field(key: "duration")]
    property duration : Int32?

    # Optional. Pass True if the uploaded video is suitable for streaming
    @[JSON::Field(key: "supports_streaming")]
    property supports_streaming : Bool?

  end

  # Telegram API type: InputProfilePhoto
  # This object describes a profile photo to set. Currently, it can be one of
  # - InputProfilePhotoStatic
  # - InputProfilePhotoAnimated
  struct InputProfilePhoto
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: InputProfilePhotoStatic
  # A static profile photo in the .JPG format.
  struct InputProfilePhotoStatic
    include JSON::Serializable

    # Type of the profile photo, must be static
    @[JSON::Field(key: "type")]
    property type : String

    # The static profile photo. Profile photos can't be reused and can only be uploaded as a new file, so you can pass "attach://<file_attach_name>" if the photo was uploaded using multipart/form-data under <file_attach_name>. More information on Sending Files: https://core.telegram.org/bots/api#sending-files
    @[JSON::Field(key: "photo")]
    property photo : String

  end

  # Telegram API type: InputProfilePhotoAnimated
  # An animated profile photo in the MPEG4 format.
  struct InputProfilePhotoAnimated
    include JSON::Serializable

    # Type of the profile photo, must be animated
    @[JSON::Field(key: "type")]
    property type : String

    # The animated profile photo. Profile photos can't be reused and can only be uploaded as a new file, so you can pass "attach://<file_attach_name>" if the photo was uploaded using multipart/form-data under <file_attach_name>. More information on Sending Files: https://core.telegram.org/bots/api#sending-files
    @[JSON::Field(key: "animation")]
    property animation : String

    # Optional. Timestamp in seconds of the frame that will be used as the static profile photo. Defaults to 0.0.
    @[JSON::Field(key: "main_frame_timestamp")]
    property main_frame_timestamp : Float64?

  end

  # Telegram API type: InputStoryContent
  # This object describes the content of a story to post. Currently, it can be one of
  # - InputStoryContentPhoto
  # - InputStoryContentVideo
  struct InputStoryContent
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: InputStoryContentPhoto
  # Describes a photo to post as a story.
  struct InputStoryContentPhoto
    include JSON::Serializable

    # Type of the content, must be photo
    @[JSON::Field(key: "type")]
    property type : String

    # The photo to post as a story. The photo must be of the size 1080x1920 and must not exceed 10 MB. The photo can't be reused and can only be uploaded as a new file, so you can pass "attach://<file_attach_name>" if the photo was uploaded using multipart/form-data under <file_attach_name>. More information on Sending Files: https://core.telegram.org/bots/api#sending-files
    @[JSON::Field(key: "photo")]
    property photo : String

  end

  # Telegram API type: InputStoryContentVideo
  # Describes a video to post as a story.
  struct InputStoryContentVideo
    include JSON::Serializable

    # Type of the content, must be video
    @[JSON::Field(key: "type")]
    property type : String

    # The video to post as a story. The video must be of the size 720x1280, streamable, encoded with H.265 codec, with key frames added each second in the MPEG4 format, and must not exceed 30 MB. The video can't be reused and can only be uploaded as a new file, so you can pass "attach://<file_attach_name>" if the video was uploaded using multipart/form-data under <file_attach_name>. More information on Sending Files: https://core.telegram.org/bots/api#sending-files
    @[JSON::Field(key: "video")]
    property video : String

    # Optional. Precise duration of the video in seconds; 0-60
    @[JSON::Field(key: "duration")]
    property duration : Float64?

    # Optional. Timestamp in seconds of the frame that will be used as the static cover for the story. Defaults to 0.0.
    @[JSON::Field(key: "cover_frame_timestamp")]
    property cover_frame_timestamp : Float64?

    # Optional. Pass True if the video has no sound
    @[JSON::Field(key: "is_animation")]
    property is_animation : Bool?

  end

  # Telegram API type: Sticker
  # This object represents a sticker.
  struct Sticker
    include JSON::Serializable

    # Identifier for this file, which can be used to download or reuse the file
    @[JSON::Field(key: "file_id")]
    property file_id : String

    # Unique identifier for this file, which is supposed to be the same over time and for different bots. Can't be used to download or reuse the file.
    @[JSON::Field(key: "file_unique_id")]
    property file_unique_id : String

    # Type of the sticker, currently one of "regular", "mask", "custom_emoji". The type of the sticker is independent from its format, which is determined by the fields is_animated and is_video.
    @[JSON::Field(key: "type")]
    property type : String

    # Sticker width
    @[JSON::Field(key: "width")]
    property width : Int32

    # Sticker height
    @[JSON::Field(key: "height")]
    property height : Int32

    # True, if the sticker is animated
    @[JSON::Field(key: "is_animated")]
    property is_animated : Bool

    # True, if the sticker is a video sticker
    @[JSON::Field(key: "is_video")]
    property is_video : Bool

    # Optional. Sticker thumbnail in the .WEBP or .JPG format
    @[JSON::Field(key: "thumbnail")]
    property thumbnail : PhotoSize?

    # Optional. Emoji associated with the sticker
    @[JSON::Field(key: "emoji")]
    property emoji : String?

    # Optional. Name of the sticker set to which the sticker belongs
    @[JSON::Field(key: "set_name")]
    property set_name : String?

    # Optional. For premium regular stickers, premium animation for the sticker
    @[JSON::Field(key: "premium_animation")]
    property premium_animation : TelegramFile?

    # Optional. For mask stickers, the position where the mask should be placed
    @[JSON::Field(key: "mask_position")]
    property mask_position : MaskPosition?

    # Optional. For custom emoji stickers, unique identifier of the custom emoji
    @[JSON::Field(key: "custom_emoji_id")]
    property custom_emoji_id : String?

    # Optional. True, if the sticker must be repainted to a text color in messages, the color of the Telegram Premium badge in emoji status, white color on chat photos, or another appropriate color in other places
    @[JSON::Field(key: "needs_repainting")]
    property needs_repainting : Bool?

    # Optional. File size in bytes
    @[JSON::Field(key: "file_size")]
    property file_size : Int32?

  end

  # Telegram API type: StickerSet
  # This object represents a sticker set.
  struct StickerSet
    include JSON::Serializable

    # Sticker set name
    @[JSON::Field(key: "name")]
    property name : String

    # Sticker set title
    @[JSON::Field(key: "title")]
    property title : String

    # Type of stickers in the set, currently one of "regular", "mask", "custom_emoji"
    @[JSON::Field(key: "sticker_type")]
    property sticker_type : String

    # List of all set stickers
    @[JSON::Field(key: "stickers")]
    property stickers : Array(Sticker)

    # Optional. Sticker set thumbnail in the .WEBP, .TGS, or .WEBM format
    @[JSON::Field(key: "thumbnail")]
    property thumbnail : PhotoSize?

  end

  # Telegram API type: MaskPosition
  # This object describes the position on faces where a mask should be placed by default.
  struct MaskPosition
    include JSON::Serializable

    # The part of the face relative to which the mask should be placed. One of "forehead", "eyes", "mouth", or "chin".
    @[JSON::Field(key: "point")]
    property point : String

    # Shift by X-axis measured in widths of the mask scaled to the face size, from left to right. For example, choosing -1.0 will place mask just to the left of the default mask position.
    @[JSON::Field(key: "x_shift")]
    property x_shift : Float64

    # Shift by Y-axis measured in heights of the mask scaled to the face size, from top to bottom. For example, 1.0 will place the mask just below the default mask position.
    @[JSON::Field(key: "y_shift")]
    property y_shift : Float64

    # Mask scaling coefficient. For example, 2.0 means double size.
    @[JSON::Field(key: "scale")]
    property scale : Float64

  end

  # Telegram API type: InputSticker
  # This object describes a sticker to be added to a sticker set.
  struct InputSticker
    include JSON::Serializable

    # The added sticker. Pass a file_id as a String to send a file that already exists on the Telegram servers, pass an HTTP URL as a String for Telegram to get a file from the Internet, or pass "attach://<file_attach_name>" to upload a new file using multipart/form-data under <file_attach_name> name. Animated and video stickers can't be uploaded via HTTP URL. More information on Sending Files: https://core.telegram.org/bots/api#sending-files
    @[JSON::Field(key: "sticker")]
    property sticker : String

    # Format of the added sticker, must be one of "static" for a .WEBP or .PNG image, "animated" for a .TGS animation, "video" for a .WEBM video
    @[JSON::Field(key: "format")]
    property format : String

    # List of 1-20 emoji associated with the sticker
    @[JSON::Field(key: "emoji_list")]
    property emoji_list : Array(String)

    # Optional. Position where the mask should be placed on faces. For "mask" stickers only.
    @[JSON::Field(key: "mask_position")]
    property mask_position : MaskPosition?

    # Optional. List of 0-20 search keywords for the sticker with total length of up to 64 characters. For "regular" and "custom_emoji" stickers only.
    @[JSON::Field(key: "keywords")]
    property keywords : Array(String)?

  end

  # Telegram API type: InlineQuery
  # This object represents an incoming inline query. When the user sends an empty query, your bot could return some default or trending results.
  class InlineQuery
    include JSON::Serializable

    # Unique identifier for this query
    @[JSON::Field(key: "id")]
    property id : String

    # Sender
    @[JSON::Field(key: "from")]
    property from : User

    # Text of the query (up to 256 characters)
    @[JSON::Field(key: "query")]
    property query : String

    # Offset of the results to be returned, can be controlled by the bot
    @[JSON::Field(key: "offset")]
    property offset : String

    # Optional. Type of the chat from which the inline query was sent. Can be either "sender" for a private chat with the inline query sender, "private", "group", "supergroup", or "channel". The chat type should be always known for requests sent from official clients and most third-party clients, unless the request was sent from a secret chat
    @[JSON::Field(key: "chat_type")]
    property chat_type : String?

    # Optional. Sender location, only for bots that request user location
    @[JSON::Field(key: "location")]
    property location : Location?

  end

  # Telegram API type: InlineQueryResultsButton
  # This object represents a button to be shown above inline query results. You must use exactly one of the optional fields.
  struct InlineQueryResultsButton
    include JSON::Serializable

    # Label text on the button
    @[JSON::Field(key: "text")]
    property text : String

    # Optional. Description of the Web App that will be launched when the user presses the button. The Web App will be able to switch back to the inline mode using the method switchInlineQuery inside the Web App.
    @[JSON::Field(key: "web_app")]
    property web_app : WebAppInfo?

    # Optional. Deep-linking parameter for the /start message sent to the bot when a user presses the button. 1-64 characters, only A-Z, a-z, 0-9, _ and - are allowed. Example: An inline bot that sends YouTube videos can ask the user to connect the bot to their YouTube account to adapt search results accordingly. To do this, it displays a 'Connect your YouTube account' button above the results, or even before showing any. The user presses the button, switches to a private chat with the bot and, in doing so, passes a start parameter that instructs the bot to return an OAuth link. Once done, the bot can offer a switch_inline button so that the user can easily return to the chat where they wanted to use the bot's inline capabilities.
    @[JSON::Field(key: "start_parameter")]
    property start_parameter : String?

  end

  # Telegram API type: InlineQueryResult
  # This object represents one result of an inline query. Telegram clients currently support results of the following 20 types:
  # - InlineQueryResultCachedAudio
  # - InlineQueryResultCachedDocument
  # - InlineQueryResultCachedGif
  # - InlineQueryResultCachedMpeg4Gif
  # - InlineQueryResultCachedPhoto
  # - InlineQueryResultCachedSticker
  # - InlineQueryResultCachedVideo
  # - InlineQueryResultCachedVoice
  # - InlineQueryResultArticle
  # - InlineQueryResultAudio
  # - InlineQueryResultContact
  # - InlineQueryResultGame
  # - InlineQueryResultDocument
  # - InlineQueryResultGif
  # - InlineQueryResultLocation
  # - InlineQueryResultMpeg4Gif
  # - InlineQueryResultPhoto
  # - InlineQueryResultVenue
  # - InlineQueryResultVideo
  # - InlineQueryResultVoice
  # Note: All URLs passed in inline query results will be available to end users and therefore must be assumed to be public.
  struct InlineQueryResult
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: InlineQueryResultArticle
  # Represents a link to an article or web page.
  struct InlineQueryResultArticle
    include JSON::Serializable

    # Type of the result, must be article
    @[JSON::Field(key: "type")]
    property type : String

    # Unique identifier for this result, 1-64 Bytes
    @[JSON::Field(key: "id")]
    property id : String

    # Title of the result
    @[JSON::Field(key: "title")]
    property title : String

    # Content of the message to be sent
    @[JSON::Field(key: "input_message_content")]
    property input_message_content : InputMessageContent

    # Optional. Inline keyboard attached to the message
    @[JSON::Field(key: "reply_markup")]
    property reply_markup : InlineKeyboardMarkup?

    # Optional. URL of the result
    @[JSON::Field(key: "url")]
    property url : String?

    # Optional. Short description of the result
    @[JSON::Field(key: "description")]
    property description : String?

    # Optional. Url of the thumbnail for the result
    @[JSON::Field(key: "thumbnail_url")]
    property thumbnail_url : String?

    # Optional. Thumbnail width
    @[JSON::Field(key: "thumbnail_width")]
    property thumbnail_width : Int32?

    # Optional. Thumbnail height
    @[JSON::Field(key: "thumbnail_height")]
    property thumbnail_height : Int32?

  end

  # Telegram API type: InlineQueryResultPhoto
  # Represents a link to a photo. By default, this photo will be sent by the user with optional caption. Alternatively, you can use input_message_content to send a message with the specified content instead of the photo.
  struct InlineQueryResultPhoto
    include JSON::Serializable

    # Type of the result, must be photo
    @[JSON::Field(key: "type")]
    property type : String

    # Unique identifier for this result, 1-64 bytes
    @[JSON::Field(key: "id")]
    property id : String

    # A valid URL of the photo. Photo must be in JPEG format. Photo size must not exceed 5MB
    @[JSON::Field(key: "photo_url")]
    property photo_url : String

    # URL of the thumbnail for the photo
    @[JSON::Field(key: "thumbnail_url")]
    property thumbnail_url : String

    # Optional. Width of the photo
    @[JSON::Field(key: "photo_width")]
    property photo_width : Int32?

    # Optional. Height of the photo
    @[JSON::Field(key: "photo_height")]
    property photo_height : Int32?

    # Optional. Title for the result
    @[JSON::Field(key: "title")]
    property title : String?

    # Optional. Short description of the result
    @[JSON::Field(key: "description")]
    property description : String?

    # Optional. Caption of the photo to be sent, 0-1024 characters after entities parsing
    @[JSON::Field(key: "caption")]
    property caption : String?

    # Optional. Mode for parsing entities in the photo caption. See formatting options for more details.
    @[JSON::Field(key: "parse_mode")]
    property parse_mode : String?

    # Optional. List of special entities that appear in the caption, which can be specified instead of parse_mode
    @[JSON::Field(key: "caption_entities")]
    property caption_entities : Array(MessageEntity)?

    # Optional. Pass True, if the caption must be shown above the message media
    @[JSON::Field(key: "show_caption_above_media")]
    property show_caption_above_media : Bool?

    # Optional. Inline keyboard attached to the message
    @[JSON::Field(key: "reply_markup")]
    property reply_markup : InlineKeyboardMarkup?

    # Optional. Content of the message to be sent instead of the photo
    @[JSON::Field(key: "input_message_content")]
    property input_message_content : InputMessageContent?

  end

  # Telegram API type: InlineQueryResultGif
  # Represents a link to an animated GIF file. By default, this animated GIF file will be sent by the user with optional caption. Alternatively, you can use input_message_content to send a message with the specified content instead of the animation.
  struct InlineQueryResultGif
    include JSON::Serializable

    # Type of the result, must be gif
    @[JSON::Field(key: "type")]
    property type : String

    # Unique identifier for this result, 1-64 bytes
    @[JSON::Field(key: "id")]
    property id : String

    # A valid URL for the GIF file
    @[JSON::Field(key: "gif_url")]
    property gif_url : String

    # Optional. Width of the GIF
    @[JSON::Field(key: "gif_width")]
    property gif_width : Int32?

    # Optional. Height of the GIF
    @[JSON::Field(key: "gif_height")]
    property gif_height : Int32?

    # Optional. Duration of the GIF in seconds
    @[JSON::Field(key: "gif_duration")]
    property gif_duration : Int32?

    # URL of the static (JPEG or GIF) or animated (MPEG4) thumbnail for the result
    @[JSON::Field(key: "thumbnail_url")]
    property thumbnail_url : String

    # Optional. MIME type of the thumbnail, must be one of "image/jpeg", "image/gif", or "video/mp4". Defaults to "image/jpeg"
    @[JSON::Field(key: "thumbnail_mime_type")]
    property thumbnail_mime_type : String?

    # Optional. Title for the result
    @[JSON::Field(key: "title")]
    property title : String?

    # Optional. Caption of the GIF file to be sent, 0-1024 characters after entities parsing
    @[JSON::Field(key: "caption")]
    property caption : String?

    # Optional. Mode for parsing entities in the caption. See formatting options for more details.
    @[JSON::Field(key: "parse_mode")]
    property parse_mode : String?

    # Optional. List of special entities that appear in the caption, which can be specified instead of parse_mode
    @[JSON::Field(key: "caption_entities")]
    property caption_entities : Array(MessageEntity)?

    # Optional. Pass True, if the caption must be shown above the message media
    @[JSON::Field(key: "show_caption_above_media")]
    property show_caption_above_media : Bool?

    # Optional. Inline keyboard attached to the message
    @[JSON::Field(key: "reply_markup")]
    property reply_markup : InlineKeyboardMarkup?

    # Optional. Content of the message to be sent instead of the GIF animation
    @[JSON::Field(key: "input_message_content")]
    property input_message_content : InputMessageContent?

  end

  # Telegram API type: InlineQueryResultMpeg4Gif
  # Represents a link to a video animation (H.264/MPEG-4 AVC video without sound). By default, this animated MPEG-4 file will be sent by the user with optional caption. Alternatively, you can use input_message_content to send a message with the specified content instead of the animation.
  struct InlineQueryResultMpeg4Gif
    include JSON::Serializable

    # Type of the result, must be mpeg4_gif
    @[JSON::Field(key: "type")]
    property type : String

    # Unique identifier for this result, 1-64 bytes
    @[JSON::Field(key: "id")]
    property id : String

    # A valid URL for the MPEG4 file
    @[JSON::Field(key: "mpeg4_url")]
    property mpeg4_url : String

    # Optional. Video width
    @[JSON::Field(key: "mpeg4_width")]
    property mpeg4_width : Int32?

    # Optional. Video height
    @[JSON::Field(key: "mpeg4_height")]
    property mpeg4_height : Int32?

    # Optional. Video duration in seconds
    @[JSON::Field(key: "mpeg4_duration")]
    property mpeg4_duration : Int32?

    # URL of the static (JPEG or GIF) or animated (MPEG4) thumbnail for the result
    @[JSON::Field(key: "thumbnail_url")]
    property thumbnail_url : String

    # Optional. MIME type of the thumbnail, must be one of "image/jpeg", "image/gif", or "video/mp4". Defaults to "image/jpeg"
    @[JSON::Field(key: "thumbnail_mime_type")]
    property thumbnail_mime_type : String?

    # Optional. Title for the result
    @[JSON::Field(key: "title")]
    property title : String?

    # Optional. Caption of the MPEG-4 file to be sent, 0-1024 characters after entities parsing
    @[JSON::Field(key: "caption")]
    property caption : String?

    # Optional. Mode for parsing entities in the caption. See formatting options for more details.
    @[JSON::Field(key: "parse_mode")]
    property parse_mode : String?

    # Optional. List of special entities that appear in the caption, which can be specified instead of parse_mode
    @[JSON::Field(key: "caption_entities")]
    property caption_entities : Array(MessageEntity)?

    # Optional. Pass True, if the caption must be shown above the message media
    @[JSON::Field(key: "show_caption_above_media")]
    property show_caption_above_media : Bool?

    # Optional. Inline keyboard attached to the message
    @[JSON::Field(key: "reply_markup")]
    property reply_markup : InlineKeyboardMarkup?

    # Optional. Content of the message to be sent instead of the video animation
    @[JSON::Field(key: "input_message_content")]
    property input_message_content : InputMessageContent?

  end

  # Telegram API type: InlineQueryResultVideo
  # Represents a link to a page containing an embedded video player or a video file. By default, this video file will be sent by the user with an optional caption. Alternatively, you can use input_message_content to send a message with the specified content instead of the video.
  struct InlineQueryResultVideo
    include JSON::Serializable

    # Type of the result, must be video
    @[JSON::Field(key: "type")]
    property type : String

    # Unique identifier for this result, 1-64 bytes
    @[JSON::Field(key: "id")]
    property id : String

    # A valid URL for the embedded video player or video file
    @[JSON::Field(key: "video_url")]
    property video_url : String

    # MIME type of the content of the video URL, "text/html" or "video/mp4"
    @[JSON::Field(key: "mime_type")]
    property mime_type : String

    # URL of the thumbnail (JPEG only) for the video
    @[JSON::Field(key: "thumbnail_url")]
    property thumbnail_url : String

    # Title for the result
    @[JSON::Field(key: "title")]
    property title : String

    # Optional. Caption of the video to be sent, 0-1024 characters after entities parsing
    @[JSON::Field(key: "caption")]
    property caption : String?

    # Optional. Mode for parsing entities in the video caption. See formatting options for more details.
    @[JSON::Field(key: "parse_mode")]
    property parse_mode : String?

    # Optional. List of special entities that appear in the caption, which can be specified instead of parse_mode
    @[JSON::Field(key: "caption_entities")]
    property caption_entities : Array(MessageEntity)?

    # Optional. Pass True, if the caption must be shown above the message media
    @[JSON::Field(key: "show_caption_above_media")]
    property show_caption_above_media : Bool?

    # Optional. Video width
    @[JSON::Field(key: "video_width")]
    property video_width : Int32?

    # Optional. Video height
    @[JSON::Field(key: "video_height")]
    property video_height : Int32?

    # Optional. Video duration in seconds
    @[JSON::Field(key: "video_duration")]
    property video_duration : Int32?

    # Optional. Short description of the result
    @[JSON::Field(key: "description")]
    property description : String?

    # Optional. Inline keyboard attached to the message
    @[JSON::Field(key: "reply_markup")]
    property reply_markup : InlineKeyboardMarkup?

    # Optional. Content of the message to be sent instead of the video. This field is required if InlineQueryResultVideo is used to send an HTML-page as a result (e.g., a YouTube video).
    @[JSON::Field(key: "input_message_content")]
    property input_message_content : InputMessageContent?

  end

  # Telegram API type: InlineQueryResultAudio
  # Represents a link to an MP3 audio file. By default, this audio file will be sent by the user. Alternatively, you can use input_message_content to send a message with the specified content instead of the audio.
  struct InlineQueryResultAudio
    include JSON::Serializable

    # Type of the result, must be audio
    @[JSON::Field(key: "type")]
    property type : String

    # Unique identifier for this result, 1-64 bytes
    @[JSON::Field(key: "id")]
    property id : String

    # A valid URL for the audio file
    @[JSON::Field(key: "audio_url")]
    property audio_url : String

    # Title
    @[JSON::Field(key: "title")]
    property title : String

    # Optional. Caption, 0-1024 characters after entities parsing
    @[JSON::Field(key: "caption")]
    property caption : String?

    # Optional. Mode for parsing entities in the audio caption. See formatting options for more details.
    @[JSON::Field(key: "parse_mode")]
    property parse_mode : String?

    # Optional. List of special entities that appear in the caption, which can be specified instead of parse_mode
    @[JSON::Field(key: "caption_entities")]
    property caption_entities : Array(MessageEntity)?

    # Optional. Performer
    @[JSON::Field(key: "performer")]
    property performer : String?

    # Optional. Audio duration in seconds
    @[JSON::Field(key: "audio_duration")]
    property audio_duration : Int32?

    # Optional. Inline keyboard attached to the message
    @[JSON::Field(key: "reply_markup")]
    property reply_markup : InlineKeyboardMarkup?

    # Optional. Content of the message to be sent instead of the audio
    @[JSON::Field(key: "input_message_content")]
    property input_message_content : InputMessageContent?

  end

  # Telegram API type: InlineQueryResultVoice
  # Represents a link to a voice recording in an .OGG container encoded with OPUS. By default, this voice recording will be sent by the user. Alternatively, you can use input_message_content to send a message with the specified content instead of the the voice message.
  struct InlineQueryResultVoice
    include JSON::Serializable

    # Type of the result, must be voice
    @[JSON::Field(key: "type")]
    property type : String

    # Unique identifier for this result, 1-64 bytes
    @[JSON::Field(key: "id")]
    property id : String

    # A valid URL for the voice recording
    @[JSON::Field(key: "voice_url")]
    property voice_url : String

    # Recording title
    @[JSON::Field(key: "title")]
    property title : String

    # Optional. Caption, 0-1024 characters after entities parsing
    @[JSON::Field(key: "caption")]
    property caption : String?

    # Optional. Mode for parsing entities in the voice message caption. See formatting options for more details.
    @[JSON::Field(key: "parse_mode")]
    property parse_mode : String?

    # Optional. List of special entities that appear in the caption, which can be specified instead of parse_mode
    @[JSON::Field(key: "caption_entities")]
    property caption_entities : Array(MessageEntity)?

    # Optional. Recording duration in seconds
    @[JSON::Field(key: "voice_duration")]
    property voice_duration : Int32?

    # Optional. Inline keyboard attached to the message
    @[JSON::Field(key: "reply_markup")]
    property reply_markup : InlineKeyboardMarkup?

    # Optional. Content of the message to be sent instead of the voice recording
    @[JSON::Field(key: "input_message_content")]
    property input_message_content : InputMessageContent?

  end

  # Telegram API type: InlineQueryResultDocument
  # Represents a link to a file. By default, this file will be sent by the user with an optional caption. Alternatively, you can use input_message_content to send a message with the specified content instead of the file. Currently, only .PDF and .ZIP files can be sent using this method.
  struct InlineQueryResultDocument
    include JSON::Serializable

    # Type of the result, must be document
    @[JSON::Field(key: "type")]
    property type : String

    # Unique identifier for this result, 1-64 bytes
    @[JSON::Field(key: "id")]
    property id : String

    # Title for the result
    @[JSON::Field(key: "title")]
    property title : String

    # Optional. Caption of the document to be sent, 0-1024 characters after entities parsing
    @[JSON::Field(key: "caption")]
    property caption : String?

    # Optional. Mode for parsing entities in the document caption. See formatting options for more details.
    @[JSON::Field(key: "parse_mode")]
    property parse_mode : String?

    # Optional. List of special entities that appear in the caption, which can be specified instead of parse_mode
    @[JSON::Field(key: "caption_entities")]
    property caption_entities : Array(MessageEntity)?

    # A valid URL for the file
    @[JSON::Field(key: "document_url")]
    property document_url : String

    # MIME type of the content of the file, either "application/pdf" or "application/zip"
    @[JSON::Field(key: "mime_type")]
    property mime_type : String

    # Optional. Short description of the result
    @[JSON::Field(key: "description")]
    property description : String?

    # Optional. Inline keyboard attached to the message
    @[JSON::Field(key: "reply_markup")]
    property reply_markup : InlineKeyboardMarkup?

    # Optional. Content of the message to be sent instead of the file
    @[JSON::Field(key: "input_message_content")]
    property input_message_content : InputMessageContent?

    # Optional. URL of the thumbnail (JPEG only) for the file
    @[JSON::Field(key: "thumbnail_url")]
    property thumbnail_url : String?

    # Optional. Thumbnail width
    @[JSON::Field(key: "thumbnail_width")]
    property thumbnail_width : Int32?

    # Optional. Thumbnail height
    @[JSON::Field(key: "thumbnail_height")]
    property thumbnail_height : Int32?

  end

  # Telegram API type: InlineQueryResultLocation
  # Represents a location on a map. By default, the location will be sent by the user. Alternatively, you can use input_message_content to send a message with the specified content instead of the location.
  struct InlineQueryResultLocation
    include JSON::Serializable

    # Type of the result, must be location
    @[JSON::Field(key: "type")]
    property type : String

    # Unique identifier for this result, 1-64 Bytes
    @[JSON::Field(key: "id")]
    property id : String

    # Location latitude in degrees
    @[JSON::Field(key: "latitude")]
    property latitude : Float64

    # Location longitude in degrees
    @[JSON::Field(key: "longitude")]
    property longitude : Float64

    # Location title
    @[JSON::Field(key: "title")]
    property title : String

    # Optional. The radius of uncertainty for the location, measured in meters; 0-1500
    @[JSON::Field(key: "horizontal_accuracy")]
    property horizontal_accuracy : Float64?

    # Optional. Period in seconds during which the location can be updated, should be between 60 and 86400, or 0x7FFFFFFF for live locations that can be edited indefinitely.
    @[JSON::Field(key: "live_period")]
    property live_period : Int32?

    # Optional. For live locations, a direction in which the user is moving, in degrees. Must be between 1 and 360 if specified.
    @[JSON::Field(key: "heading")]
    property heading : Int32?

    # Optional. For live locations, a maximum distance for proximity alerts about approaching another chat member, in meters. Must be between 1 and 100000 if specified.
    @[JSON::Field(key: "proximity_alert_radius")]
    property proximity_alert_radius : Int32?

    # Optional. Inline keyboard attached to the message
    @[JSON::Field(key: "reply_markup")]
    property reply_markup : InlineKeyboardMarkup?

    # Optional. Content of the message to be sent instead of the location
    @[JSON::Field(key: "input_message_content")]
    property input_message_content : InputMessageContent?

    # Optional. Url of the thumbnail for the result
    @[JSON::Field(key: "thumbnail_url")]
    property thumbnail_url : String?

    # Optional. Thumbnail width
    @[JSON::Field(key: "thumbnail_width")]
    property thumbnail_width : Int32?

    # Optional. Thumbnail height
    @[JSON::Field(key: "thumbnail_height")]
    property thumbnail_height : Int32?

  end

  # Telegram API type: InlineQueryResultVenue
  # Represents a venue. By default, the venue will be sent by the user. Alternatively, you can use input_message_content to send a message with the specified content instead of the venue.
  struct InlineQueryResultVenue
    include JSON::Serializable

    # Type of the result, must be venue
    @[JSON::Field(key: "type")]
    property type : String

    # Unique identifier for this result, 1-64 Bytes
    @[JSON::Field(key: "id")]
    property id : String

    # Latitude of the venue location in degrees
    @[JSON::Field(key: "latitude")]
    property latitude : Float64

    # Longitude of the venue location in degrees
    @[JSON::Field(key: "longitude")]
    property longitude : Float64

    # Title of the venue
    @[JSON::Field(key: "title")]
    property title : String

    # Address of the venue
    @[JSON::Field(key: "address")]
    property address : String

    # Optional. Foursquare identifier of the venue if known
    @[JSON::Field(key: "foursquare_id")]
    property foursquare_id : String?

    # Optional. Foursquare type of the venue, if known. (For example, "arts_entertainment/default", "arts_entertainment/aquarium" or "food/icecream".)
    @[JSON::Field(key: "foursquare_type")]
    property foursquare_type : String?

    # Optional. Google Places identifier of the venue
    @[JSON::Field(key: "google_place_id")]
    property google_place_id : String?

    # Optional. Google Places type of the venue. (See supported types.)
    @[JSON::Field(key: "google_place_type")]
    property google_place_type : String?

    # Optional. Inline keyboard attached to the message
    @[JSON::Field(key: "reply_markup")]
    property reply_markup : InlineKeyboardMarkup?

    # Optional. Content of the message to be sent instead of the venue
    @[JSON::Field(key: "input_message_content")]
    property input_message_content : InputMessageContent?

    # Optional. Url of the thumbnail for the result
    @[JSON::Field(key: "thumbnail_url")]
    property thumbnail_url : String?

    # Optional. Thumbnail width
    @[JSON::Field(key: "thumbnail_width")]
    property thumbnail_width : Int32?

    # Optional. Thumbnail height
    @[JSON::Field(key: "thumbnail_height")]
    property thumbnail_height : Int32?

  end

  # Telegram API type: InlineQueryResultContact
  # Represents a contact with a phone number. By default, this contact will be sent by the user. Alternatively, you can use input_message_content to send a message with the specified content instead of the contact.
  struct InlineQueryResultContact
    include JSON::Serializable

    # Type of the result, must be contact
    @[JSON::Field(key: "type")]
    property type : String

    # Unique identifier for this result, 1-64 Bytes
    @[JSON::Field(key: "id")]
    property id : String

    # Contact's phone number
    @[JSON::Field(key: "phone_number")]
    property phone_number : String

    # Contact's first name
    @[JSON::Field(key: "first_name")]
    property first_name : String

    # Optional. Contact's last name
    @[JSON::Field(key: "last_name")]
    property last_name : String?

    # Optional. Additional data about the contact in the form of a vCard, 0-2048 bytes
    @[JSON::Field(key: "vcard")]
    property vcard : String?

    # Optional. Inline keyboard attached to the message
    @[JSON::Field(key: "reply_markup")]
    property reply_markup : InlineKeyboardMarkup?

    # Optional. Content of the message to be sent instead of the contact
    @[JSON::Field(key: "input_message_content")]
    property input_message_content : InputMessageContent?

    # Optional. Url of the thumbnail for the result
    @[JSON::Field(key: "thumbnail_url")]
    property thumbnail_url : String?

    # Optional. Thumbnail width
    @[JSON::Field(key: "thumbnail_width")]
    property thumbnail_width : Int32?

    # Optional. Thumbnail height
    @[JSON::Field(key: "thumbnail_height")]
    property thumbnail_height : Int32?

  end

  # Telegram API type: InlineQueryResultGame
  # Represents a Game.
  struct InlineQueryResultGame
    include JSON::Serializable

    # Type of the result, must be game
    @[JSON::Field(key: "type")]
    property type : String

    # Unique identifier for this result, 1-64 bytes
    @[JSON::Field(key: "id")]
    property id : String

    # Short name of the game
    @[JSON::Field(key: "game_short_name")]
    property game_short_name : String

    # Optional. Inline keyboard attached to the message
    @[JSON::Field(key: "reply_markup")]
    property reply_markup : InlineKeyboardMarkup?

  end

  # Telegram API type: InlineQueryResultCachedPhoto
  # Represents a link to a photo stored on the Telegram servers. By default, this photo will be sent by the user with an optional caption. Alternatively, you can use input_message_content to send a message with the specified content instead of the photo.
  struct InlineQueryResultCachedPhoto
    include JSON::Serializable

    # Type of the result, must be photo
    @[JSON::Field(key: "type")]
    property type : String

    # Unique identifier for this result, 1-64 bytes
    @[JSON::Field(key: "id")]
    property id : String

    # A valid file identifier of the photo
    @[JSON::Field(key: "photo_file_id")]
    property photo_file_id : String

    # Optional. Title for the result
    @[JSON::Field(key: "title")]
    property title : String?

    # Optional. Short description of the result
    @[JSON::Field(key: "description")]
    property description : String?

    # Optional. Caption of the photo to be sent, 0-1024 characters after entities parsing
    @[JSON::Field(key: "caption")]
    property caption : String?

    # Optional. Mode for parsing entities in the photo caption. See formatting options for more details.
    @[JSON::Field(key: "parse_mode")]
    property parse_mode : String?

    # Optional. List of special entities that appear in the caption, which can be specified instead of parse_mode
    @[JSON::Field(key: "caption_entities")]
    property caption_entities : Array(MessageEntity)?

    # Optional. Pass True, if the caption must be shown above the message media
    @[JSON::Field(key: "show_caption_above_media")]
    property show_caption_above_media : Bool?

    # Optional. Inline keyboard attached to the message
    @[JSON::Field(key: "reply_markup")]
    property reply_markup : InlineKeyboardMarkup?

    # Optional. Content of the message to be sent instead of the photo
    @[JSON::Field(key: "input_message_content")]
    property input_message_content : InputMessageContent?

  end

  # Telegram API type: InlineQueryResultCachedGif
  # Represents a link to an animated GIF file stored on the Telegram servers. By default, this animated GIF file will be sent by the user with an optional caption. Alternatively, you can use input_message_content to send a message with specified content instead of the animation.
  struct InlineQueryResultCachedGif
    include JSON::Serializable

    # Type of the result, must be gif
    @[JSON::Field(key: "type")]
    property type : String

    # Unique identifier for this result, 1-64 bytes
    @[JSON::Field(key: "id")]
    property id : String

    # A valid file identifier for the GIF file
    @[JSON::Field(key: "gif_file_id")]
    property gif_file_id : String

    # Optional. Title for the result
    @[JSON::Field(key: "title")]
    property title : String?

    # Optional. Caption of the GIF file to be sent, 0-1024 characters after entities parsing
    @[JSON::Field(key: "caption")]
    property caption : String?

    # Optional. Mode for parsing entities in the caption. See formatting options for more details.
    @[JSON::Field(key: "parse_mode")]
    property parse_mode : String?

    # Optional. List of special entities that appear in the caption, which can be specified instead of parse_mode
    @[JSON::Field(key: "caption_entities")]
    property caption_entities : Array(MessageEntity)?

    # Optional. Pass True, if the caption must be shown above the message media
    @[JSON::Field(key: "show_caption_above_media")]
    property show_caption_above_media : Bool?

    # Optional. Inline keyboard attached to the message
    @[JSON::Field(key: "reply_markup")]
    property reply_markup : InlineKeyboardMarkup?

    # Optional. Content of the message to be sent instead of the GIF animation
    @[JSON::Field(key: "input_message_content")]
    property input_message_content : InputMessageContent?

  end

  # Telegram API type: InlineQueryResultCachedMpeg4Gif
  # Represents a link to a video animation (H.264/MPEG-4 AVC video without sound) stored on the Telegram servers. By default, this animated MPEG-4 file will be sent by the user with an optional caption. Alternatively, you can use input_message_content to send a message with the specified content instead of the animation.
  struct InlineQueryResultCachedMpeg4Gif
    include JSON::Serializable

    # Type of the result, must be mpeg4_gif
    @[JSON::Field(key: "type")]
    property type : String

    # Unique identifier for this result, 1-64 bytes
    @[JSON::Field(key: "id")]
    property id : String

    # A valid file identifier for the MPEG4 file
    @[JSON::Field(key: "mpeg4_file_id")]
    property mpeg4_file_id : String

    # Optional. Title for the result
    @[JSON::Field(key: "title")]
    property title : String?

    # Optional. Caption of the MPEG-4 file to be sent, 0-1024 characters after entities parsing
    @[JSON::Field(key: "caption")]
    property caption : String?

    # Optional. Mode for parsing entities in the caption. See formatting options for more details.
    @[JSON::Field(key: "parse_mode")]
    property parse_mode : String?

    # Optional. List of special entities that appear in the caption, which can be specified instead of parse_mode
    @[JSON::Field(key: "caption_entities")]
    property caption_entities : Array(MessageEntity)?

    # Optional. Pass True, if the caption must be shown above the message media
    @[JSON::Field(key: "show_caption_above_media")]
    property show_caption_above_media : Bool?

    # Optional. Inline keyboard attached to the message
    @[JSON::Field(key: "reply_markup")]
    property reply_markup : InlineKeyboardMarkup?

    # Optional. Content of the message to be sent instead of the video animation
    @[JSON::Field(key: "input_message_content")]
    property input_message_content : InputMessageContent?

  end

  # Telegram API type: InlineQueryResultCachedSticker
  # Represents a link to a sticker stored on the Telegram servers. By default, this sticker will be sent by the user. Alternatively, you can use input_message_content to send a message with the specified content instead of the sticker.
  struct InlineQueryResultCachedSticker
    include JSON::Serializable

    # Type of the result, must be sticker
    @[JSON::Field(key: "type")]
    property type : String

    # Unique identifier for this result, 1-64 bytes
    @[JSON::Field(key: "id")]
    property id : String

    # A valid file identifier of the sticker
    @[JSON::Field(key: "sticker_file_id")]
    property sticker_file_id : String

    # Optional. Inline keyboard attached to the message
    @[JSON::Field(key: "reply_markup")]
    property reply_markup : InlineKeyboardMarkup?

    # Optional. Content of the message to be sent instead of the sticker
    @[JSON::Field(key: "input_message_content")]
    property input_message_content : InputMessageContent?

  end

  # Telegram API type: InlineQueryResultCachedDocument
  # Represents a link to a file stored on the Telegram servers. By default, this file will be sent by the user with an optional caption. Alternatively, you can use input_message_content to send a message with the specified content instead of the file.
  struct InlineQueryResultCachedDocument
    include JSON::Serializable

    # Type of the result, must be document
    @[JSON::Field(key: "type")]
    property type : String

    # Unique identifier for this result, 1-64 bytes
    @[JSON::Field(key: "id")]
    property id : String

    # Title for the result
    @[JSON::Field(key: "title")]
    property title : String

    # A valid file identifier for the file
    @[JSON::Field(key: "document_file_id")]
    property document_file_id : String

    # Optional. Short description of the result
    @[JSON::Field(key: "description")]
    property description : String?

    # Optional. Caption of the document to be sent, 0-1024 characters after entities parsing
    @[JSON::Field(key: "caption")]
    property caption : String?

    # Optional. Mode for parsing entities in the document caption. See formatting options for more details.
    @[JSON::Field(key: "parse_mode")]
    property parse_mode : String?

    # Optional. List of special entities that appear in the caption, which can be specified instead of parse_mode
    @[JSON::Field(key: "caption_entities")]
    property caption_entities : Array(MessageEntity)?

    # Optional. Inline keyboard attached to the message
    @[JSON::Field(key: "reply_markup")]
    property reply_markup : InlineKeyboardMarkup?

    # Optional. Content of the message to be sent instead of the file
    @[JSON::Field(key: "input_message_content")]
    property input_message_content : InputMessageContent?

  end

  # Telegram API type: InlineQueryResultCachedVideo
  # Represents a link to a video file stored on the Telegram servers. By default, this video file will be sent by the user with an optional caption. Alternatively, you can use input_message_content to send a message with the specified content instead of the video.
  struct InlineQueryResultCachedVideo
    include JSON::Serializable

    # Type of the result, must be video
    @[JSON::Field(key: "type")]
    property type : String

    # Unique identifier for this result, 1-64 bytes
    @[JSON::Field(key: "id")]
    property id : String

    # A valid file identifier for the video file
    @[JSON::Field(key: "video_file_id")]
    property video_file_id : String

    # Title for the result
    @[JSON::Field(key: "title")]
    property title : String

    # Optional. Short description of the result
    @[JSON::Field(key: "description")]
    property description : String?

    # Optional. Caption of the video to be sent, 0-1024 characters after entities parsing
    @[JSON::Field(key: "caption")]
    property caption : String?

    # Optional. Mode for parsing entities in the video caption. See formatting options for more details.
    @[JSON::Field(key: "parse_mode")]
    property parse_mode : String?

    # Optional. List of special entities that appear in the caption, which can be specified instead of parse_mode
    @[JSON::Field(key: "caption_entities")]
    property caption_entities : Array(MessageEntity)?

    # Optional. Pass True, if the caption must be shown above the message media
    @[JSON::Field(key: "show_caption_above_media")]
    property show_caption_above_media : Bool?

    # Optional. Inline keyboard attached to the message
    @[JSON::Field(key: "reply_markup")]
    property reply_markup : InlineKeyboardMarkup?

    # Optional. Content of the message to be sent instead of the video
    @[JSON::Field(key: "input_message_content")]
    property input_message_content : InputMessageContent?

  end

  # Telegram API type: InlineQueryResultCachedVoice
  # Represents a link to a voice message stored on the Telegram servers. By default, this voice message will be sent by the user. Alternatively, you can use input_message_content to send a message with the specified content instead of the voice message.
  struct InlineQueryResultCachedVoice
    include JSON::Serializable

    # Type of the result, must be voice
    @[JSON::Field(key: "type")]
    property type : String

    # Unique identifier for this result, 1-64 bytes
    @[JSON::Field(key: "id")]
    property id : String

    # A valid file identifier for the voice message
    @[JSON::Field(key: "voice_file_id")]
    property voice_file_id : String

    # Voice message title
    @[JSON::Field(key: "title")]
    property title : String

    # Optional. Caption, 0-1024 characters after entities parsing
    @[JSON::Field(key: "caption")]
    property caption : String?

    # Optional. Mode for parsing entities in the voice message caption. See formatting options for more details.
    @[JSON::Field(key: "parse_mode")]
    property parse_mode : String?

    # Optional. List of special entities that appear in the caption, which can be specified instead of parse_mode
    @[JSON::Field(key: "caption_entities")]
    property caption_entities : Array(MessageEntity)?

    # Optional. Inline keyboard attached to the message
    @[JSON::Field(key: "reply_markup")]
    property reply_markup : InlineKeyboardMarkup?

    # Optional. Content of the message to be sent instead of the voice message
    @[JSON::Field(key: "input_message_content")]
    property input_message_content : InputMessageContent?

  end

  # Telegram API type: InlineQueryResultCachedAudio
  # Represents a link to an MP3 audio file stored on the Telegram servers. By default, this audio file will be sent by the user. Alternatively, you can use input_message_content to send a message with the specified content instead of the audio.
  struct InlineQueryResultCachedAudio
    include JSON::Serializable

    # Type of the result, must be audio
    @[JSON::Field(key: "type")]
    property type : String

    # Unique identifier for this result, 1-64 bytes
    @[JSON::Field(key: "id")]
    property id : String

    # A valid file identifier for the audio file
    @[JSON::Field(key: "audio_file_id")]
    property audio_file_id : String

    # Optional. Caption, 0-1024 characters after entities parsing
    @[JSON::Field(key: "caption")]
    property caption : String?

    # Optional. Mode for parsing entities in the audio caption. See formatting options for more details.
    @[JSON::Field(key: "parse_mode")]
    property parse_mode : String?

    # Optional. List of special entities that appear in the caption, which can be specified instead of parse_mode
    @[JSON::Field(key: "caption_entities")]
    property caption_entities : Array(MessageEntity)?

    # Optional. Inline keyboard attached to the message
    @[JSON::Field(key: "reply_markup")]
    property reply_markup : InlineKeyboardMarkup?

    # Optional. Content of the message to be sent instead of the audio
    @[JSON::Field(key: "input_message_content")]
    property input_message_content : InputMessageContent?

  end

  # Telegram API type: InputMessageContent
  # This object represents the content of a message to be sent as a result of an inline query. Telegram clients currently support the following 5 types:
  # - InputTextMessageContent
  # - InputLocationMessageContent
  # - InputVenueMessageContent
  # - InputContactMessageContent
  # - InputInvoiceMessageContent
  struct InputMessageContent
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: InputTextMessageContent
  # Represents the content of a text message to be sent as the result of an inline query.
  struct InputTextMessageContent
    include JSON::Serializable

    # Text of the message to be sent, 1-4096 characters
    @[JSON::Field(key: "message_text")]
    property message_text : String

    # Optional. Mode for parsing entities in the message text. See formatting options for more details.
    @[JSON::Field(key: "parse_mode")]
    property parse_mode : String?

    # Optional. List of special entities that appear in message text, which can be specified instead of parse_mode
    @[JSON::Field(key: "entities")]
    property entities : Array(MessageEntity)?

    # Optional. Link preview generation options for the message
    @[JSON::Field(key: "link_preview_options")]
    property link_preview_options : LinkPreviewOptions?

  end

  # Telegram API type: InputLocationMessageContent
  # Represents the content of a location message to be sent as the result of an inline query.
  struct InputLocationMessageContent
    include JSON::Serializable

    # Latitude of the location in degrees
    @[JSON::Field(key: "latitude")]
    property latitude : Float64

    # Longitude of the location in degrees
    @[JSON::Field(key: "longitude")]
    property longitude : Float64

    # Optional. The radius of uncertainty for the location, measured in meters; 0-1500
    @[JSON::Field(key: "horizontal_accuracy")]
    property horizontal_accuracy : Float64?

    # Optional. Period in seconds during which the location can be updated, should be between 60 and 86400, or 0x7FFFFFFF for live locations that can be edited indefinitely.
    @[JSON::Field(key: "live_period")]
    property live_period : Int32?

    # Optional. For live locations, a direction in which the user is moving, in degrees. Must be between 1 and 360 if specified.
    @[JSON::Field(key: "heading")]
    property heading : Int32?

    # Optional. For live locations, a maximum distance for proximity alerts about approaching another chat member, in meters. Must be between 1 and 100000 if specified.
    @[JSON::Field(key: "proximity_alert_radius")]
    property proximity_alert_radius : Int32?

  end

  # Telegram API type: InputVenueMessageContent
  # Represents the content of a venue message to be sent as the result of an inline query.
  struct InputVenueMessageContent
    include JSON::Serializable

    # Latitude of the venue in degrees
    @[JSON::Field(key: "latitude")]
    property latitude : Float64

    # Longitude of the venue in degrees
    @[JSON::Field(key: "longitude")]
    property longitude : Float64

    # Name of the venue
    @[JSON::Field(key: "title")]
    property title : String

    # Address of the venue
    @[JSON::Field(key: "address")]
    property address : String

    # Optional. Foursquare identifier of the venue, if known
    @[JSON::Field(key: "foursquare_id")]
    property foursquare_id : String?

    # Optional. Foursquare type of the venue, if known. (For example, "arts_entertainment/default", "arts_entertainment/aquarium" or "food/icecream".)
    @[JSON::Field(key: "foursquare_type")]
    property foursquare_type : String?

    # Optional. Google Places identifier of the venue
    @[JSON::Field(key: "google_place_id")]
    property google_place_id : String?

    # Optional. Google Places type of the venue. (See supported types.)
    @[JSON::Field(key: "google_place_type")]
    property google_place_type : String?

  end

  # Telegram API type: InputContactMessageContent
  # Represents the content of a contact message to be sent as the result of an inline query.
  struct InputContactMessageContent
    include JSON::Serializable

    # Contact's phone number
    @[JSON::Field(key: "phone_number")]
    property phone_number : String

    # Contact's first name
    @[JSON::Field(key: "first_name")]
    property first_name : String

    # Optional. Contact's last name
    @[JSON::Field(key: "last_name")]
    property last_name : String?

    # Optional. Additional data about the contact in the form of a vCard, 0-2048 bytes
    @[JSON::Field(key: "vcard")]
    property vcard : String?

  end

  # Telegram API type: InputInvoiceMessageContent
  # Represents the content of an invoice message to be sent as the result of an inline query.
  struct InputInvoiceMessageContent
    include JSON::Serializable

    # Product name, 1-32 characters
    @[JSON::Field(key: "title")]
    property title : String

    # Product description, 1-255 characters
    @[JSON::Field(key: "description")]
    property description : String

    # Bot-defined invoice payload, 1-128 bytes. This will not be displayed to the user, use it for your internal processes.
    @[JSON::Field(key: "payload")]
    property payload : String

    # Optional. Payment provider token, obtained via @BotFather. Pass an empty string for payments in Telegram Stars.
    @[JSON::Field(key: "provider_token")]
    property provider_token : String?

    # Three-letter ISO 4217 currency code, see more on currencies. Pass "XTR" for payments in Telegram Stars.
    @[JSON::Field(key: "currency")]
    property currency : String

    # Price breakdown, a JSON-serialized list of components (e.g. product price, tax, discount, delivery cost, delivery tax, bonus, etc.). Must contain exactly one item for payments in Telegram Stars.
    @[JSON::Field(key: "prices")]
    property prices : Array(LabeledPrice)

    # Optional. The maximum accepted amount for tips in the smallest units of the currency (integer, not float/double). For example, for a maximum tip of US$ 1.45 pass max_tip_amount = 145. See the exp parameter in currencies.json, it shows the number of digits past the decimal point for each currency (2 for the majority of currencies). Defaults to 0. Not supported for payments in Telegram Stars.
    @[JSON::Field(key: "max_tip_amount")]
    property max_tip_amount : Int32?

    # Optional. A JSON-serialized array of suggested amounts of tip in the smallest units of the currency (integer, not float/double). At most 4 suggested tip amounts can be specified. The suggested tip amounts must be positive, passed in a strictly increased order and must not exceed max_tip_amount.
    @[JSON::Field(key: "suggested_tip_amounts")]
    property suggested_tip_amounts : Array(Int32)?

    # Optional. A JSON-serialized object for data about the invoice, which will be shared with the payment provider. A detailed description of the required fields should be provided by the payment provider.
    @[JSON::Field(key: "provider_data")]
    property provider_data : String?

    # Optional. URL of the product photo for the invoice. Can be a photo of the goods or a marketing image for a service.
    @[JSON::Field(key: "photo_url")]
    property photo_url : String?

    # Optional. Photo size in bytes
    @[JSON::Field(key: "photo_size")]
    property photo_size : Int32?

    # Optional. Photo width
    @[JSON::Field(key: "photo_width")]
    property photo_width : Int32?

    # Optional. Photo height
    @[JSON::Field(key: "photo_height")]
    property photo_height : Int32?

    # Optional. Pass True if you require the user's full name to complete the order. Ignored for payments in Telegram Stars.
    @[JSON::Field(key: "need_name")]
    property need_name : Bool?

    # Optional. Pass True if you require the user's phone number to complete the order. Ignored for payments in Telegram Stars.
    @[JSON::Field(key: "need_phone_number")]
    property need_phone_number : Bool?

    # Optional. Pass True if you require the user's email address to complete the order. Ignored for payments in Telegram Stars.
    @[JSON::Field(key: "need_email")]
    property need_email : Bool?

    # Optional. Pass True if you require the user's shipping address to complete the order. Ignored for payments in Telegram Stars.
    @[JSON::Field(key: "need_shipping_address")]
    property need_shipping_address : Bool?

    # Optional. Pass True if the user's phone number should be sent to the provider. Ignored for payments in Telegram Stars.
    @[JSON::Field(key: "send_phone_number_to_provider")]
    property send_phone_number_to_provider : Bool?

    # Optional. Pass True if the user's email address should be sent to the provider. Ignored for payments in Telegram Stars.
    @[JSON::Field(key: "send_email_to_provider")]
    property send_email_to_provider : Bool?

    # Optional. Pass True if the final price depends on the shipping method. Ignored for payments in Telegram Stars.
    @[JSON::Field(key: "is_flexible")]
    property is_flexible : Bool?

  end

  # Telegram API type: ChosenInlineResult
  # Represents a result of an inline query that was chosen by the user and sent to their chat partner.
  # Note: It is necessary to enable inline feedback via @BotFather in order to receive these objects in updates.
  struct ChosenInlineResult
    include JSON::Serializable

    # The unique identifier for the result that was chosen
    @[JSON::Field(key: "result_id")]
    property result_id : String

    # The user that chose the result
    @[JSON::Field(key: "from")]
    property from : User

    # Optional. Sender location, only for bots that require user location
    @[JSON::Field(key: "location")]
    property location : Location?

    # Optional. Identifier of the sent inline message. Available only if there is an inline keyboard attached to the message. Will be also received in callback queries and can be used to edit the message.
    @[JSON::Field(key: "inline_message_id")]
    property inline_message_id : String?

    # The query that was used to obtain the result
    @[JSON::Field(key: "query")]
    property query : String

  end

  # Telegram API type: SentWebAppMessage
  # Describes an inline message sent by a Web App on behalf of a user.
  struct SentWebAppMessage
    include JSON::Serializable

    # Optional. Identifier of the sent inline message. Available only if there is an inline keyboard attached to the message.
    @[JSON::Field(key: "inline_message_id")]
    property inline_message_id : String?

  end

  # Telegram API type: PreparedInlineMessage
  # Describes an inline message to be sent by a user of a Mini App.
  struct PreparedInlineMessage
    include JSON::Serializable

    # Unique identifier of the prepared message
    @[JSON::Field(key: "id")]
    property id : String

    # Expiration date of the prepared message, in Unix time. Expired prepared messages can no longer be used
    @[JSON::Field(key: "expiration_date")]
    property expiration_date : Int32

  end

  # Telegram API type: LabeledPrice
  # This object represents a portion of the price for goods or services.
  struct LabeledPrice
    include JSON::Serializable

    # Portion label
    @[JSON::Field(key: "label")]
    property label : String

    # Price of the product in the smallest units of the currency (integer, not float/double). For example, for a price of US$ 1.45 pass amount = 145. See the exp parameter in currencies.json, it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
    @[JSON::Field(key: "amount")]
    property amount : Int32

  end

  # Telegram API type: Invoice
  # This object contains basic information about an invoice.
  class Invoice
    include JSON::Serializable

    # Product name
    @[JSON::Field(key: "title")]
    property title : String

    # Product description
    @[JSON::Field(key: "description")]
    property description : String

    # Unique bot deep-linking parameter that can be used to generate this invoice
    @[JSON::Field(key: "start_parameter")]
    property start_parameter : String

    # Three-letter ISO 4217 currency code, or "XTR" for payments in Telegram Stars
    @[JSON::Field(key: "currency")]
    property currency : String

    # Total price in the smallest units of the currency (integer, not float/double). For example, for a price of US$ 1.45 pass amount = 145. See the exp parameter in currencies.json, it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
    @[JSON::Field(key: "total_amount")]
    property total_amount : Int32

  end

  # Telegram API type: ShippingAddress
  # This object represents a shipping address.
  struct ShippingAddress
    include JSON::Serializable

    # Two-letter ISO 3166-1 alpha-2 country code
    @[JSON::Field(key: "country_code")]
    property country_code : String

    # State, if applicable
    @[JSON::Field(key: "state")]
    property state : String

    # City
    @[JSON::Field(key: "city")]
    property city : String

    # First line for the address
    @[JSON::Field(key: "street_line1")]
    property street_line1 : String

    # Second line for the address
    @[JSON::Field(key: "street_line2")]
    property street_line2 : String

    # Address post code
    @[JSON::Field(key: "post_code")]
    property post_code : String

  end

  # Telegram API type: OrderInfo
  # This object represents information about an order.
  struct OrderInfo
    include JSON::Serializable

    # Optional. User name
    @[JSON::Field(key: "name")]
    property name : String?

    # Optional. User's phone number
    @[JSON::Field(key: "phone_number")]
    property phone_number : String?

    # Optional. User email
    @[JSON::Field(key: "email")]
    property email : String?

    # Optional. User shipping address
    @[JSON::Field(key: "shipping_address")]
    property shipping_address : ShippingAddress?

  end

  # Telegram API type: ShippingOption
  # This object represents one shipping option.
  struct ShippingOption
    include JSON::Serializable

    # Shipping option identifier
    @[JSON::Field(key: "id")]
    property id : String

    # Option title
    @[JSON::Field(key: "title")]
    property title : String

    # List of price portions
    @[JSON::Field(key: "prices")]
    property prices : Array(LabeledPrice)

  end

  # Telegram API type: SuccessfulPayment
  # This object contains basic information about a successful payment. Note that if the buyer initiates a chargeback with the relevant payment provider following this transaction, the funds may be debited from your balance. This is outside of Telegram's control.
  class SuccessfulPayment
    include JSON::Serializable

    # Three-letter ISO 4217 currency code, or "XTR" for payments in Telegram Stars
    @[JSON::Field(key: "currency")]
    property currency : String

    # Total price in the smallest units of the currency (integer, not float/double). For example, for a price of US$ 1.45 pass amount = 145. See the exp parameter in currencies.json, it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
    @[JSON::Field(key: "total_amount")]
    property total_amount : Int32

    # Bot-specified invoice payload
    @[JSON::Field(key: "invoice_payload")]
    property invoice_payload : String

    # Optional. Expiration date of the subscription, in Unix time; for recurring payments only
    @[JSON::Field(key: "subscription_expiration_date")]
    property subscription_expiration_date : Int32?

    # Optional. True, if the payment is a recurring payment for a subscription
    @[JSON::Field(key: "is_recurring")]
    property is_recurring : Bool?

    # Optional. True, if the payment is the first payment for a subscription
    @[JSON::Field(key: "is_first_recurring")]
    property is_first_recurring : Bool?

    # Optional. Identifier of the shipping option chosen by the user
    @[JSON::Field(key: "shipping_option_id")]
    property shipping_option_id : String?

    # Optional. Order information provided by the user
    @[JSON::Field(key: "order_info")]
    property order_info : OrderInfo?

    # Telegram payment identifier
    @[JSON::Field(key: "telegram_payment_charge_id")]
    property telegram_payment_charge_id : String

    # Provider payment identifier
    @[JSON::Field(key: "provider_payment_charge_id")]
    property provider_payment_charge_id : String

  end

  # Telegram API type: RefundedPayment
  # This object contains basic information about a refunded payment.
  struct RefundedPayment
    include JSON::Serializable

    # Three-letter ISO 4217 currency code, or "XTR" for payments in Telegram Stars. Currently, always "XTR"
    @[JSON::Field(key: "currency")]
    property currency : String

    # Total refunded price in the smallest units of the currency (integer, not float/double). For example, for a price of US$ 1.45, total_amount = 145. See the exp parameter in currencies.json, it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
    @[JSON::Field(key: "total_amount")]
    property total_amount : Int32

    # Bot-specified invoice payload
    @[JSON::Field(key: "invoice_payload")]
    property invoice_payload : String

    # Telegram payment identifier
    @[JSON::Field(key: "telegram_payment_charge_id")]
    property telegram_payment_charge_id : String

    # Optional. Provider payment identifier
    @[JSON::Field(key: "provider_payment_charge_id")]
    property provider_payment_charge_id : String?

  end

  # Telegram API type: ShippingQuery
  # This object contains information about an incoming shipping query.
  class ShippingQuery
    include JSON::Serializable

    # Unique query identifier
    @[JSON::Field(key: "id")]
    property id : String

    # User who sent the query
    @[JSON::Field(key: "from")]
    property from : User

    # Bot-specified invoice payload
    @[JSON::Field(key: "invoice_payload")]
    property invoice_payload : String

    # User specified shipping address
    @[JSON::Field(key: "shipping_address")]
    property shipping_address : ShippingAddress

  end

  # Telegram API type: PreCheckoutQuery
  # This object contains information about an incoming pre-checkout query.
  class PreCheckoutQuery
    include JSON::Serializable

    # Unique query identifier
    @[JSON::Field(key: "id")]
    property id : String

    # User who sent the query
    @[JSON::Field(key: "from")]
    property from : User

    # Three-letter ISO 4217 currency code, or "XTR" for payments in Telegram Stars
    @[JSON::Field(key: "currency")]
    property currency : String

    # Total price in the smallest units of the currency (integer, not float/double). For example, for a price of US$ 1.45 pass amount = 145. See the exp parameter in currencies.json, it shows the number of digits past the decimal point for each currency (2 for the majority of currencies).
    @[JSON::Field(key: "total_amount")]
    property total_amount : Int32

    # Bot-specified invoice payload
    @[JSON::Field(key: "invoice_payload")]
    property invoice_payload : String

    # Optional. Identifier of the shipping option chosen by the user
    @[JSON::Field(key: "shipping_option_id")]
    property shipping_option_id : String?

    # Optional. Order information provided by the user
    @[JSON::Field(key: "order_info")]
    property order_info : OrderInfo?

  end

  # Telegram API type: PaidMediaPurchased
  # This object contains information about a paid media purchase.
  struct PaidMediaPurchased
    include JSON::Serializable

    # User who purchased the media
    @[JSON::Field(key: "from")]
    property from : User

    # Bot-specified paid media payload
    @[JSON::Field(key: "paid_media_payload")]
    property paid_media_payload : String

  end

  # Telegram API type: RevenueWithdrawalState
  # This object describes the state of a revenue withdrawal operation. Currently, it can be one of
  # - RevenueWithdrawalStatePending
  # - RevenueWithdrawalStateSucceeded
  # - RevenueWithdrawalStateFailed
  struct RevenueWithdrawalState
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: RevenueWithdrawalStatePending
  # The withdrawal is in progress.
  struct RevenueWithdrawalStatePending
    include JSON::Serializable

    # Type of the state, always "pending"
    @[JSON::Field(key: "type")]
    property type : String

  end

  # Telegram API type: RevenueWithdrawalStateSucceeded
  # The withdrawal succeeded.
  struct RevenueWithdrawalStateSucceeded
    include JSON::Serializable

    # Type of the state, always "succeeded"
    @[JSON::Field(key: "type")]
    property type : String

    # Date the withdrawal was completed in Unix time
    @[JSON::Field(key: "date")]
    property date : Int32

    # An HTTPS URL that can be used to see transaction details
    @[JSON::Field(key: "url")]
    property url : String

  end

  # Telegram API type: RevenueWithdrawalStateFailed
  # The withdrawal failed and the transaction was refunded.
  struct RevenueWithdrawalStateFailed
    include JSON::Serializable

    # Type of the state, always "failed"
    @[JSON::Field(key: "type")]
    property type : String

  end

  # Telegram API type: AffiliateInfo
  # Contains information about the affiliate that received a commission via this transaction.
  struct AffiliateInfo
    include JSON::Serializable

    # Optional. The bot or the user that received an affiliate commission if it was received by a bot or a user
    @[JSON::Field(key: "affiliate_user")]
    property affiliate_user : User?

    # Optional. The chat that received an affiliate commission if it was received by a chat
    @[JSON::Field(key: "affiliate_chat")]
    property affiliate_chat : Chat?

    # The number of Telegram Stars received by the affiliate for each 1000 Telegram Stars received by the bot from referred users
    @[JSON::Field(key: "commission_per_mille")]
    property commission_per_mille : Int32

    # Integer amount of Telegram Stars received by the affiliate from the transaction, rounded to 0; can be negative for refunds
    @[JSON::Field(key: "amount")]
    property amount : Int32

    # Optional. The number of 1/1000000000 shares of Telegram Stars received by the affiliate; from -999999999 to 999999999; can be negative for refunds
    @[JSON::Field(key: "nanostar_amount")]
    property nanostar_amount : Int32?

  end

  # Telegram API type: TransactionPartner
  # This object describes the source of a transaction, or its recipient for outgoing transactions. Currently, it can be one of
  # - TransactionPartnerUser
  # - TransactionPartnerChat
  # - TransactionPartnerAffiliateProgram
  # - TransactionPartnerFragment
  # - TransactionPartnerTelegramAds
  # - TransactionPartnerTelegramApi
  # - TransactionPartnerOther
  struct TransactionPartner
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: TransactionPartnerUser
  # Describes a transaction with a user.
  struct TransactionPartnerUser
    include JSON::Serializable

    # Type of the transaction partner, always "user"
    @[JSON::Field(key: "type")]
    property type : String

    # Type of the transaction, currently one of "invoice_payment" for payments via invoices, "paid_media_payment" for payments for paid media, "gift_purchase" for gifts sent by the bot, "premium_purchase" for Telegram Premium subscriptions gifted by the bot, "business_account_transfer" for direct transfers from managed business accounts
    @[JSON::Field(key: "transaction_type")]
    property transaction_type : String

    # Information about the user
    @[JSON::Field(key: "user")]
    property user : User

    # Optional. Information about the affiliate that received a commission via this transaction. Can be available only for "invoice_payment" and "paid_media_payment" transactions.
    @[JSON::Field(key: "affiliate")]
    property affiliate : AffiliateInfo?

    # Optional. Bot-specified invoice payload. Can be available only for "invoice_payment" transactions.
    @[JSON::Field(key: "invoice_payload")]
    property invoice_payload : String?

    # Optional. The duration of the paid subscription. Can be available only for "invoice_payment" transactions.
    @[JSON::Field(key: "subscription_period")]
    property subscription_period : Int32?

    # Optional. Information about the paid media bought by the user; for "paid_media_payment" transactions only
    @[JSON::Field(key: "paid_media")]
    property paid_media : Array(PaidMedia)?

    # Optional. Bot-specified paid media payload. Can be available only for "paid_media_payment" transactions.
    @[JSON::Field(key: "paid_media_payload")]
    property paid_media_payload : String?

    # Optional. The gift sent to the user by the bot; for "gift_purchase" transactions only
    @[JSON::Field(key: "gift")]
    property gift : Gift?

    # Optional. Number of months the gifted Telegram Premium subscription will be active for; for "premium_purchase" transactions only
    @[JSON::Field(key: "premium_subscription_duration")]
    property premium_subscription_duration : Int32?

  end

  # Telegram API type: TransactionPartnerChat
  # Describes a transaction with a chat.
  struct TransactionPartnerChat
    include JSON::Serializable

    # Type of the transaction partner, always "chat"
    @[JSON::Field(key: "type")]
    property type : String

    # Information about the chat
    @[JSON::Field(key: "chat")]
    property chat : Chat

    # Optional. The gift sent to the chat by the bot
    @[JSON::Field(key: "gift")]
    property gift : Gift?

  end

  # Telegram API type: TransactionPartnerAffiliateProgram
  # Describes the affiliate program that issued the affiliate commission received via this transaction.
  struct TransactionPartnerAffiliateProgram
    include JSON::Serializable

    # Type of the transaction partner, always "affiliate_program"
    @[JSON::Field(key: "type")]
    property type : String

    # Optional. Information about the bot that sponsored the affiliate program
    @[JSON::Field(key: "sponsor_user")]
    property sponsor_user : User?

    # The number of Telegram Stars received by the bot for each 1000 Telegram Stars received by the affiliate program sponsor from referred users
    @[JSON::Field(key: "commission_per_mille")]
    property commission_per_mille : Int32

  end

  # Telegram API type: TransactionPartnerFragment
  # Describes a withdrawal transaction with Fragment.
  struct TransactionPartnerFragment
    include JSON::Serializable

    # Type of the transaction partner, always "fragment"
    @[JSON::Field(key: "type")]
    property type : String

    # Optional. State of the transaction if the transaction is outgoing
    @[JSON::Field(key: "withdrawal_state")]
    property withdrawal_state : RevenueWithdrawalState?

  end

  # Telegram API type: TransactionPartnerTelegramAds
  # Describes a withdrawal transaction to the Telegram Ads platform.
  struct TransactionPartnerTelegramAds
    include JSON::Serializable

    # Type of the transaction partner, always "telegram_ads"
    @[JSON::Field(key: "type")]
    property type : String

  end

  # Telegram API type: TransactionPartnerTelegramApi
  # Describes a transaction with payment for paid broadcasting.
  struct TransactionPartnerTelegramApi
    include JSON::Serializable

    # Type of the transaction partner, always "telegram_api"
    @[JSON::Field(key: "type")]
    property type : String

    # The number of successful requests that exceeded regular limits and were therefore billed
    @[JSON::Field(key: "request_count")]
    property request_count : Int32

  end

  # Telegram API type: TransactionPartnerOther
  # Describes a transaction with an unknown source or recipient.
  struct TransactionPartnerOther
    include JSON::Serializable

    # Type of the transaction partner, always "other"
    @[JSON::Field(key: "type")]
    property type : String

  end

  # Telegram API type: StarTransaction
  # Describes a Telegram Star transaction. Note that if the buyer initiates a chargeback with the payment provider from whom they acquired Stars (e.g., Apple, Google) following this transaction, the refunded Stars will be deducted from the bot's balance. This is outside of Telegram's control.
  struct StarTransaction
    include JSON::Serializable

    # Unique identifier of the transaction. Coincides with the identifier of the original transaction for refund transactions. Coincides with SuccessfulPayment.telegram_payment_charge_id for successful incoming payments from users.
    @[JSON::Field(key: "id")]
    property id : String

    # Integer amount of Telegram Stars transferred by the transaction
    @[JSON::Field(key: "amount")]
    property amount : Int32

    # Optional. The number of 1/1000000000 shares of Telegram Stars transferred by the transaction; from 0 to 999999999
    @[JSON::Field(key: "nanostar_amount")]
    property nanostar_amount : Int32?

    # Date the transaction was created in Unix time
    @[JSON::Field(key: "date")]
    property date : Int32

    # Optional. Source of an incoming transaction (e.g., a user purchasing goods or services, Fragment refunding a failed withdrawal). Only for incoming transactions
    @[JSON::Field(key: "source")]
    property source : TransactionPartner?

    # Optional. Receiver of an outgoing transaction (e.g., a user for a purchase refund, Fragment for a withdrawal). Only for outgoing transactions
    @[JSON::Field(key: "receiver")]
    property receiver : TransactionPartner?

  end

  # Telegram API type: StarTransactions
  # Contains a list of Telegram Star transactions.
  struct StarTransactions
    include JSON::Serializable

    # The list of transactions
    @[JSON::Field(key: "transactions")]
    property transactions : Array(StarTransaction)

  end

  # Telegram API type: PassportData
  # Describes Telegram Passport data shared with the bot by the user.
  struct PassportData
    include JSON::Serializable

    # Array with information about documents and other Telegram Passport elements that was shared with the bot
    @[JSON::Field(key: "data")]
    property data : Array(EncryptedPassportElement)

    # Encrypted credentials required to decrypt the data
    @[JSON::Field(key: "credentials")]
    property credentials : EncryptedCredentials

  end

  # Telegram API type: PassportFile
  # This object represents a file uploaded to Telegram Passport. Currently all Telegram Passport files are in JPEG format when decrypted and don't exceed 10MB.
  struct PassportFile
    include JSON::Serializable

    # Identifier for this file, which can be used to download or reuse the file
    @[JSON::Field(key: "file_id")]
    property file_id : String

    # Unique identifier for this file, which is supposed to be the same over time and for different bots. Can't be used to download or reuse the file.
    @[JSON::Field(key: "file_unique_id")]
    property file_unique_id : String

    # File size in bytes
    @[JSON::Field(key: "file_size")]
    property file_size : Int32

    # Unix time when the file was uploaded
    @[JSON::Field(key: "file_date")]
    property file_date : Int32

  end

  # Telegram API type: EncryptedPassportElement
  # Describes documents or other Telegram Passport elements shared with the bot by the user.
  struct EncryptedPassportElement
    include JSON::Serializable

    # Element type. One of "personal_details", "passport", "driver_license", "identity_card", "internal_passport", "address", "utility_bill", "bank_statement", "rental_agreement", "passport_registration", "temporary_registration", "phone_number", "email".
    @[JSON::Field(key: "type")]
    property type : String

    # Optional. Base64-encoded encrypted Telegram Passport element data provided by the user; available only for "personal_details", "passport", "driver_license", "identity_card", "internal_passport" and "address" types. Can be decrypted and verified using the accompanying EncryptedCredentials.
    @[JSON::Field(key: "data")]
    property data : String?

    # Optional. User's verified phone number; available only for "phone_number" type
    @[JSON::Field(key: "phone_number")]
    property phone_number : String?

    # Optional. User's verified email address; available only for "email" type
    @[JSON::Field(key: "email")]
    property email : String?

    # Optional. Array of encrypted files with documents provided by the user; available only for "utility_bill", "bank_statement", "rental_agreement", "passport_registration" and "temporary_registration" types. Files can be decrypted and verified using the accompanying EncryptedCredentials.
    @[JSON::Field(key: "files")]
    property files : Array(PassportFile)?

    # Optional. Encrypted file with the front side of the document, provided by the user; available only for "passport", "driver_license", "identity_card" and "internal_passport". The file can be decrypted and verified using the accompanying EncryptedCredentials.
    @[JSON::Field(key: "front_side")]
    property front_side : PassportFile?

    # Optional. Encrypted file with the reverse side of the document, provided by the user; available only for "driver_license" and "identity_card". The file can be decrypted and verified using the accompanying EncryptedCredentials.
    @[JSON::Field(key: "reverse_side")]
    property reverse_side : PassportFile?

    # Optional. Encrypted file with the selfie of the user holding a document, provided by the user; available if requested for "passport", "driver_license", "identity_card" and "internal_passport". The file can be decrypted and verified using the accompanying EncryptedCredentials.
    @[JSON::Field(key: "selfie")]
    property selfie : PassportFile?

    # Optional. Array of encrypted files with translated versions of documents provided by the user; available if requested for "passport", "driver_license", "identity_card", "internal_passport", "utility_bill", "bank_statement", "rental_agreement", "passport_registration" and "temporary_registration" types. Files can be decrypted and verified using the accompanying EncryptedCredentials.
    @[JSON::Field(key: "translation")]
    property translation : Array(PassportFile)?

    # Base64-encoded element hash for using in PassportElementErrorUnspecified
    @[JSON::Field(key: "hash")]
    property hash : String

  end

  # Telegram API type: EncryptedCredentials
  # Describes data required for decrypting and authenticating EncryptedPassportElement. See the Telegram Passport Documentation for a complete description of the data decryption and authentication processes.
  struct EncryptedCredentials
    include JSON::Serializable

    # Base64-encoded encrypted JSON-serialized data with unique user's payload, data hashes and secrets required for EncryptedPassportElement decryption and authentication
    @[JSON::Field(key: "data")]
    property data : String

    # Base64-encoded data hash for data authentication
    @[JSON::Field(key: "hash")]
    property hash : String

    # Base64-encoded secret, encrypted with the bot's public RSA key, required for data decryption
    @[JSON::Field(key: "secret")]
    property secret : String

  end

  # Telegram API type: PassportElementError
  # This object represents an error in the Telegram Passport element which was submitted that should be resolved by the user. It should be one of:
  # - PassportElementErrorDataField
  # - PassportElementErrorFrontSide
  # - PassportElementErrorReverseSide
  # - PassportElementErrorSelfie
  # - PassportElementErrorFile
  # - PassportElementErrorFiles
  # - PassportElementErrorTranslationFile
  # - PassportElementErrorTranslationFiles
  # - PassportElementErrorUnspecified
  struct PassportElementError
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: PassportElementErrorDataField
  # Represents an issue in one of the data fields that was provided by the user. The error is considered resolved when the field's value changes.
  struct PassportElementErrorDataField
    include JSON::Serializable

    # Error source, must be data
    @[JSON::Field(key: "source")]
    property source : String

    # The section of the user's Telegram Passport which has the error, one of "personal_details", "passport", "driver_license", "identity_card", "internal_passport", "address"
    @[JSON::Field(key: "type")]
    property type : String

    # Name of the data field which has the error
    @[JSON::Field(key: "field_name")]
    property field_name : String

    # Base64-encoded data hash
    @[JSON::Field(key: "data_hash")]
    property data_hash : String

    # Error message
    @[JSON::Field(key: "message")]
    property message : String

  end

  # Telegram API type: PassportElementErrorFrontSide
  # Represents an issue with the front side of a document. The error is considered resolved when the file with the front side of the document changes.
  struct PassportElementErrorFrontSide
    include JSON::Serializable

    # Error source, must be front_side
    @[JSON::Field(key: "source")]
    property source : String

    # The section of the user's Telegram Passport which has the issue, one of "passport", "driver_license", "identity_card", "internal_passport"
    @[JSON::Field(key: "type")]
    property type : String

    # Base64-encoded hash of the file with the front side of the document
    @[JSON::Field(key: "file_hash")]
    property file_hash : String

    # Error message
    @[JSON::Field(key: "message")]
    property message : String

  end

  # Telegram API type: PassportElementErrorReverseSide
  # Represents an issue with the reverse side of a document. The error is considered resolved when the file with reverse side of the document changes.
  struct PassportElementErrorReverseSide
    include JSON::Serializable

    # Error source, must be reverse_side
    @[JSON::Field(key: "source")]
    property source : String

    # The section of the user's Telegram Passport which has the issue, one of "driver_license", "identity_card"
    @[JSON::Field(key: "type")]
    property type : String

    # Base64-encoded hash of the file with the reverse side of the document
    @[JSON::Field(key: "file_hash")]
    property file_hash : String

    # Error message
    @[JSON::Field(key: "message")]
    property message : String

  end

  # Telegram API type: PassportElementErrorSelfie
  # Represents an issue with the selfie with a document. The error is considered resolved when the file with the selfie changes.
  struct PassportElementErrorSelfie
    include JSON::Serializable

    # Error source, must be selfie
    @[JSON::Field(key: "source")]
    property source : String

    # The section of the user's Telegram Passport which has the issue, one of "passport", "driver_license", "identity_card", "internal_passport"
    @[JSON::Field(key: "type")]
    property type : String

    # Base64-encoded hash of the file with the selfie
    @[JSON::Field(key: "file_hash")]
    property file_hash : String

    # Error message
    @[JSON::Field(key: "message")]
    property message : String

  end

  # Telegram API type: PassportElementErrorFile
  # Represents an issue with a document scan. The error is considered resolved when the file with the document scan changes.
  struct PassportElementErrorFile
    include JSON::Serializable

    # Error source, must be file
    @[JSON::Field(key: "source")]
    property source : String

    # The section of the user's Telegram Passport which has the issue, one of "utility_bill", "bank_statement", "rental_agreement", "passport_registration", "temporary_registration"
    @[JSON::Field(key: "type")]
    property type : String

    # Base64-encoded file hash
    @[JSON::Field(key: "file_hash")]
    property file_hash : String

    # Error message
    @[JSON::Field(key: "message")]
    property message : String

  end

  # Telegram API type: PassportElementErrorFiles
  # Represents an issue with a list of scans. The error is considered resolved when the list of files containing the scans changes.
  struct PassportElementErrorFiles
    include JSON::Serializable

    # Error source, must be files
    @[JSON::Field(key: "source")]
    property source : String

    # The section of the user's Telegram Passport which has the issue, one of "utility_bill", "bank_statement", "rental_agreement", "passport_registration", "temporary_registration"
    @[JSON::Field(key: "type")]
    property type : String

    # List of base64-encoded file hashes
    @[JSON::Field(key: "file_hashes")]
    property file_hashes : Array(String)

    # Error message
    @[JSON::Field(key: "message")]
    property message : String

  end

  # Telegram API type: PassportElementErrorTranslationFile
  # Represents an issue with one of the files that constitute the translation of a document. The error is considered resolved when the file changes.
  struct PassportElementErrorTranslationFile
    include JSON::Serializable

    # Error source, must be translation_file
    @[JSON::Field(key: "source")]
    property source : String

    # Type of element of the user's Telegram Passport which has the issue, one of "passport", "driver_license", "identity_card", "internal_passport", "utility_bill", "bank_statement", "rental_agreement", "passport_registration", "temporary_registration"
    @[JSON::Field(key: "type")]
    property type : String

    # Base64-encoded file hash
    @[JSON::Field(key: "file_hash")]
    property file_hash : String

    # Error message
    @[JSON::Field(key: "message")]
    property message : String

  end

  # Telegram API type: PassportElementErrorTranslationFiles
  # Represents an issue with the translated version of a document. The error is considered resolved when a file with the document translation change.
  struct PassportElementErrorTranslationFiles
    include JSON::Serializable

    # Error source, must be translation_files
    @[JSON::Field(key: "source")]
    property source : String

    # Type of element of the user's Telegram Passport which has the issue, one of "passport", "driver_license", "identity_card", "internal_passport", "utility_bill", "bank_statement", "rental_agreement", "passport_registration", "temporary_registration"
    @[JSON::Field(key: "type")]
    property type : String

    # List of base64-encoded file hashes
    @[JSON::Field(key: "file_hashes")]
    property file_hashes : Array(String)

    # Error message
    @[JSON::Field(key: "message")]
    property message : String

  end

  # Telegram API type: PassportElementErrorUnspecified
  # Represents an issue in an unspecified place. The error is considered resolved when new data is added.
  struct PassportElementErrorUnspecified
    include JSON::Serializable

    # Error source, must be unspecified
    @[JSON::Field(key: "source")]
    property source : String

    # Type of element of the user's Telegram Passport which has the issue
    @[JSON::Field(key: "type")]
    property type : String

    # Base64-encoded element hash
    @[JSON::Field(key: "element_hash")]
    property element_hash : String

    # Error message
    @[JSON::Field(key: "message")]
    property message : String

  end

  # Telegram API type: Game
  # This object represents a game. Use BotFather to create and edit games, their short names will act as unique identifiers.
  class Game
    include JSON::Serializable

    # Title of the game
    @[JSON::Field(key: "title")]
    property title : String

    # Description of the game
    @[JSON::Field(key: "description")]
    property description : String

    # Photo that will be displayed in the game message in chats.
    @[JSON::Field(key: "photo")]
    property photo : Array(PhotoSize)

    # Optional. Brief description of the game or high scores included in the game message. Can be automatically edited to include current high scores for the game when the bot calls setGameScore, or manually edited using editMessageText. 0-4096 characters.
    @[JSON::Field(key: "text")]
    property text : String?

    # Optional. Special entities that appear in text, such as usernames, URLs, bot commands, etc.
    @[JSON::Field(key: "text_entities")]
    property text_entities : Array(MessageEntity)?

    # Optional. Animation that will be displayed in the game message in chats. Upload via BotFather
    @[JSON::Field(key: "animation")]
    property animation : Animation?

  end

  # Telegram API type: CallbackGame
  # A placeholder, currently holds no information. Use BotFather to set up your game.
  struct CallbackGame
    include JSON::Serializable

    # No fields defined for this type
  end

  # Telegram API type: GameHighScore
  # This object represents one row of the high scores table for a game.
  struct GameHighScore
    include JSON::Serializable

    # Position in high score table for the game
    @[JSON::Field(key: "position")]
    property position : Int32

    # User
    @[JSON::Field(key: "user")]
    property user : User

    # Score
    @[JSON::Field(key: "score")]
    property score : Int32

  end


  VERSION = "Bot API 9.2"
  RELEASE_DATE = "August 15, 2025"

  # Re-export APIClient for convenience
  APIClient = Client::APIClient
end
