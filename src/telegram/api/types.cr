require "./type"
require "./sender_type"
require "./generated/types"
require "./overrides/*"

class Telegram::API
  # The Bot API supports basic formatting for messages. You can use bold, italic, underlined,
  # strikethrough, and spoiler text, as well as inline links and pre-formatted code in your
  # bots' messages. Telegram clients will render them accordingly. You can use
  # either markdown-style or HTML-style formatting.
  enum ParseMode
    Markdown
    MarkdownV2
    HTML
  end

  # This object represents the contents of a file to be uploaded. Must be posted using
  # multipart/form-data in the usual way that files are uploaded via the browser.
  alias InputFile = ::File

  # This object represents the content of a media message to be sent.
  alias InputMedia = InputMediaAnimation | InputMediaDocument | InputMediaAudio | InputMediaVideo | InputMediaPhoto

  # This object represents the content of a message to be sent as a result of an inline query.
  alias InputMessageContent = InputTextMessageContent | InputLocationMessageContent | InputVenueMessageContent | InputContactMessageContent | InputInvoiceMessageContent

  # This object represents the scope to which bot commands are applied.
  alias BotCommandScope = BotCommandScopeDefault | BotCommandScopeAllPrivateChats | BotCommandScopeAllGroupChats |
                          BotCommandScopeAllChatAdministrators | BotCommandScopeChat | BotCommandScopeChatAdministrators |
                          BotCommandScopeChatMember

  # Represents an API response from Telegram
  record Response(T), ok : Bool, result : T do
    include JSON::Serializable
  end
end
