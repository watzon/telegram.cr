module Telegram
  module Helpers
    extend self

    def chunk_text(text, max_len)
      text = text.map(&.strip).join(" ")
      words = text.split(' ')

      chunks = words.reduce([] of Array(String)) do |acc, word|
        line = acc.last?
        if !line
          acc << [] of String
          line = acc.last
        end

        if line.empty?
          line << word
          next acc
        end

        count = line.reduce(0) { |acc, i| acc + i.size }
        if count + word.size > max_len
          # We don't want a space at the beginning of a new line
          next acc if word.strip.empty?
          acc << [word]
        else
          line << word
        end

        acc
      end

      chunks.map(&.join(" "))
    end
  end
end
