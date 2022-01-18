module Telegram
  abstract class BaseParser
    abstract def parse(text : String) : Tuple(String, Array(API::MessageEntity))
    abstract def unparse(text : String, entities : Array(API::MessageEntity)) : String
  end
end
