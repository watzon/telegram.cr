module Telegram
  module InputMediaFileDetection
    private def value_contains_file_data?(value)
      case value
      when InputFile
        true
      when Array
        value.any? { |item| value_contains_file_data?(item) }
      when Hash
        value.any? { |_k, v| value_contains_file_data?(v) }
      when Nil
        false
      else
        value.responds_to?(:contains_file_data?) ? value.contains_file_data? : false
      end
    end
  end

  struct InputMediaPhoto
    include InputMediaFileDetection

    def contains_file_data? : Bool
      value_contains_file_data?(media)
    end
  end

  struct InputMediaVideo
    include InputMediaFileDetection

    def contains_file_data? : Bool
      value_contains_file_data?(media) ||
        value_contains_file_data?(thumbnail) ||
        value_contains_file_data?(cover)
    end
  end

  struct InputMediaAnimation
    include InputMediaFileDetection

    def contains_file_data? : Bool
      value_contains_file_data?(media) ||
        value_contains_file_data?(thumbnail)
    end
  end

  struct InputMediaAudio
    include InputMediaFileDetection

    def contains_file_data? : Bool
      value_contains_file_data?(media) ||
        value_contains_file_data?(thumbnail)
    end
  end

  struct InputMediaDocument
    include InputMediaFileDetection

    def contains_file_data? : Bool
      value_contains_file_data?(media) ||
        value_contains_file_data?(thumbnail)
    end
  end
end
