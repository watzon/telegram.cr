class Telegram::API
  class Poll
    def quiz?
      type == "quiz"
    end
  end
end
