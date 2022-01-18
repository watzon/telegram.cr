require "mime"
require "http/client"

require "./support/parsers"
require "./api/types"
require "./middleware"

module Telegram
  module Helpers
    extend self

    def includes_media?(params)
      params.values.any? do |val|
        case val
        when Array
          val.any? { |v| v.is_a?(File | API::InputMedia) }
        when File, API::InputMedia
          true
        else
          false
        end
      end
    end

    def build_json_config(payload)
      {
        method:  "POST",
        headers: HTTP::Headers{"Content-Type" => "application/json", "Connection" => "keep-alive"},
        body:    payload.to_h.compact.to_json,
      }
    end

    def build_form_data_config(payload)
      boundary = MIME::Multipart.generate_boundary
      formdata = MIME::Multipart.build(boundary) do |form|
        payload.each do |key, value|
          attach_form_value(form, key.to_s, value)
        end
      end

      {
        method:  "POST",
        headers: HTTP::Headers{
          "Content-Type" => "multipart/form-data; boundary=#{boundary}",
          "Connection"   => "keep-alive",
        },
        body: formdata,
      }
    end

    def attach_form_value(form : MIME::Multipart::Builder, id : String, value)
      return unless value
      headers = HTTP::Headers{"Content-Disposition" => "form-data; name=#{id}"}

      case value
      when Array
        # Likely an Array(API::InputMedia)
        items = value.map do |item|
          if item.is_a?(API::InputMedia)
            attach_form_media(form, item)
          end
          item
        end
        form.body_part(headers, items.to_json)
      when API::InputMedia
        attach_form_media(form, value)
        form.body_part(headers, value.to_json)
      when File
        filename = File.basename(value.path)
        form.body_part(
          HTTP::Headers{"Content-Disposition" => "form-data; name=#{id}; filename=#{filename}"},
          value
        )
      else
        form.body_part(headers, value.to_s)
      end
    end

    def attach_form_media(form : MIME::Multipart::Builder, value : API::InputMedia)
      media = value.media
      thumb = value.responds_to?(:thumb) ? value.thumb : nil

      {media: media, thumb: thumb}.each do |key, item|
        item = check_open_local_file(item)
        if item.is_a?(File)
          id = Random.new.random_bytes(16).hexstring
          filename = File.basename(item.path)

          form.body_part(
            HTTP::Headers{"Content-Disposition" => "form-data; name=#{id}; filename=#{filename}"},
            item
          )

          if key == :media
            value.media = "attach://#{id}"
          elsif value.responds_to?(:thumb)
            value.thumb = "attach://#{id}"
          end
        end
      end
    end

    def check_open_local_file(file)
      if file.is_a?(String)
        begin
          if File.file?(file)
            return File.open(file)
          end
        rescue ex
        end
      end
      file
    end

    def random_string(length)
      chars = ('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a
      rands = chars.sample(length)
      rands.join
    end

    def escape_html(text)
      text.to_s
        .gsub('&', "&amp;")
        .gsub('<', "&lt;")
        .gsub('>', "&gt;")
    end

    def escape_md(text, version = 1)
      text = text.to_s

      case version
      when 0, 1
        chars = ['_', '*', '`', '[', ']', '(', ')']
      when 2
        chars = ['_', '*', '[', ']', '(', ')', '~', '`', '>', '#', '+', '-', '=', '|', '{', '}', '.', '!']
      else
        raise "Invalid version #{version} for `escape_md`"
      end

      chars.each do |char|
        text = text.gsub(char, "\\#{char}")
      end

      text
    end

    def pad_utf16(text)
      String.build do |str|
        text.each_char do |c|
          str << c
          if c.ord >= 0x10000 && c.ord <= 0x10FFFF
            str << " "
          end
        end
      end
    end

    def unpad_utf16(text)
      String.build do |str|
        last_char = nil
        text.each_char do |c|
          unless last_char && last_char.ord >= 0x10000 && last_char.ord <= 0x10FFFF
            str << c
          end
          last_char = c
        end
      end
    end

    def parse_text(text : String, parse_mode : API::ParseMode)
      parser = case parse_mode
        in API::ParseMode::HTML
          HTMLParser.new
        in API::ParseMode::Markdown
          raise "unsupported"
        in API::ParseMode::MarkdownV2
          raise "unsupported"
        end
      parser.parse(text)
    end

    def unparse_text(text : String, entities : Array(API::MessageEntity), parse_mode : API::ParseMode)
      parser = case parse_mode
        in API::ParseMode::HTML
          HTMLParser.new
        in API::ParseMode::Markdown
          raise "unsupported"
        in API::ParseMode::MarkdownV2
          raise "unsupported"
        end
      parser.unparse(text, entities)
    end

    def to_array(e)
      e.is_a?(Array) ? e : [e]
    end

    def try_strip(text)
      text.try(&.strip)
    end

    def or_throw(item : U?, method) forall U
      if item.nil?
        raise Error.new("Missing information for API call to #{method.to_s}")
      end
      item
    end
  end
end
