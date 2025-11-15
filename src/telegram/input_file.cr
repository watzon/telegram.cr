require "json"

module Telegram
  module Multipart
    @@registry_store = Hash(UInt64, AttachmentRegistry?).new

    class AttachmentRegistry
      struct Attachment
        getter name : String
        getter file : InputFile

        def initialize(@name : String, @file : InputFile)
        end
      end

      getter attachments : Array(Attachment)

      def initialize
        @attachments = [] of Attachment
        @counter = 0
      end

      def register(file : InputFile) : String
        name = "file#{@counter}"
        @counter += 1
        @attachments << Attachment.new(name, file)
        name
      end
    end

    def self.with_registry(registry : AttachmentRegistry, &block)
      fiber_id = Fiber.current.object_id
      previous = @@registry_store[fiber_id]?
      @@registry_store[fiber_id] = registry
      begin
        yield
      ensure
        if previous
          @@registry_store[fiber_id] = previous
        else
          @@registry_store.delete(fiber_id)
        end
      end
    end

    def self.current_registry : AttachmentRegistry?
      @@registry_store[Fiber.current.object_id]?
    end
  end

  struct InputFile
    getter io : IO
    getter filename : String?
    getter content_type : String?

    def initialize(@io : IO, @filename : String? = nil, @content_type : String? = nil)
    end

    def self.from_io(io : IO, filename : String, content_type : String? = nil)
      buffer = IO::Memory.new
      if io.responds_to?(:rewind)
        io.rewind
      end
      IO.copy(io, buffer)
      buffer.rewind
      new(buffer, filename, content_type)
    end

    def self.from_path(path : String, filename : String? = nil, content_type : String? = nil)
      file = File.open(path, "rb")
      io = IO::Memory.new(file.gets_to_end)
      return from_io(io, filename || File.basename(file.path), content_type)
    ensure
      file.close if file
    end

    def self.from_data(data : String | Bytes, filename : String, content_type : String? = nil)
      io = IO::Memory.new(data)
      new(io, filename, content_type)
    end

    def write_to(destination : IO)
      if @io.responds_to?(:rewind)
        @io.rewind
      end
      IO.copy(@io, destination)
      if @io.responds_to?(:rewind)
        @io.rewind
      end
    end

    def to_json(json : JSON::Builder)
      registry = Telegram::Multipart.current_registry
      raise ArgumentError.new("InputFile can only be serialized inside multipart requests") unless registry
      attach_name = registry.register(self)
      json.string("attach://#{attach_name}")
    end

    module JSONConverter
      def self.from_json(pull : JSON::PullParser)
        String.from_json(pull)
      end

      def self.to_json(value : String | InputFile | Nil, json : JSON::Builder)
        case value
        when String
          json.string(value)
        when InputFile
          value.to_json(json)
        when Nil
          json.null
        else
          raise ArgumentError.new("Unsupported value for InputFile conversion")
        end
      end
    end
  end
end
