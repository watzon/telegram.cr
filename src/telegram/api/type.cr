require "json"

class Telegram::API
  abstract class Type
    include JSON::Serializable

    def client
      Telegram::Client.instance
    end

    def ==(other)
      self.class == other.class &&
      self.to_json == other.to_json
    end
  end
end
