class Telegram::API
  class User
    def deleted?
      first_name.empty?
    end

    def full_name
      [first_name, last_name].compact.join(" ")
    end

    def inline_mention(full = false)
      name = full ? full_name : first_name
      name = "Deleted Accont" if name.empty?
      "[#{Helpers.escape_md(name)}](tg://user?id=#{id})"
    end

    def profile_photos(offset = nil, limit = nil)
      client.api.get_user_profile_photos(id, offset, limit)
    end

    def set_game_score(score, **kwargs)
      client.api.set_game_score(id, score, **kwargs)
    end

    def get_game_high_scores(**kwargs)
      client.api.get_game_high_scores(id, **kwargs)
    end

    def add_sticker_to_set(name, png_sticker, emojis, mask_position = nil)
      client.api.add_sticker_to_set(id, name, png_sticker, emojis, mask_position)
    end

    def create_new_sticker_set(name, title, png_sticker, emojis, **kwargs)
      client.api.create_new_sticker_set(id, name, title, png_sticker, emojis, **kwargs)
    end

    def upload_sticker_file(png_sticker)
      client.api.upload_sticker_file(id, png_sticker)
    end
  end
end
