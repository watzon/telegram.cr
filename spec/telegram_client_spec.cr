require "spec"
require "json"
require "webmock"
require "../src/telegram/generated/telegram"

# Mock successful Telegram API response
MOCK_SUCCESS_RESPONSE = {
  "ok"     => true,
  "result" => {
    "id"         => 123456789,
    "is_bot"     => true,
    "first_name" => "Test Bot",
    "username"   => "testbot",
  },
}.to_json

MOCK_MESSAGE_RESPONSE = {
  "ok"     => true,
  "result" => {
    "message_id" => 123,
    "from"       => {
      "id"         => 123456789,
      "is_bot"     => true,
      "first_name" => "Test Bot",
      "username"   => "testbot",
    },
    "chat" => {
      "id"         => 987654321,
      "first_name" => "Test User",
      "type"       => "private",
    },
    "date" => 1640000000,
    "text" => "Hello",
  },
}.to_json

describe Telegram::Client::APIClient do
  client = Telegram::APIClient.new("test_token")

  describe "HTTP request generation" do
    it "generates correct request URL and method for getMe" do
      WebMock.wrap do
        WebMock.stub("POST", "https://api.telegram.org/bottest_token/getMe")
          .with(body: "{}", headers: {"Content-Type" => "application/json"})
          .to_return(body: MOCK_SUCCESS_RESPONSE)

        result = client.get_me

        result.should be_a(Telegram::User)
        result.id.should eq(123456789)
        result.first_name.should eq("Test Bot")
      end
    end

    it "generates correct JSON request body for sendMessage" do
      WebMock.wrap do
        # Use a block to validate the request dynamically since JSON generation might differ slightly
        WebMock.stub("POST", "https://api.telegram.org/bottest_token/sendMessage")
          .to_return do |request|
            # Check that it has JSON content type
            content_type = request.headers["Content-Type"]?
            content_type.should_not be_nil
            content_type.not_nil!.should eq("application/json")

            # Check that the body contains expected fields
            body = WebMock.body(request)
            body.should_not be_nil
            body.not_nil!.includes?("chat_id").should be_true
            body.not_nil!.includes?("987654321").should be_true
            body.not_nil!.includes?("text").should be_true
            body.not_nil!.includes?("Hello, World!").should be_true

            HTTP::Client::Response.new(200, body: MOCK_MESSAGE_RESPONSE)
          end

        client.send_message(chat_id: 987654321, text: "Hello, World!")
      end
    end

    it "handles optional parameters correctly" do
      WebMock.wrap do
        WebMock.stub("POST", "https://api.telegram.org/bottest_token/sendMessage")
          .to_return do |request|
            # Check that it has JSON content type
            content_type = request.headers["Content-Type"]?
            content_type.should_not be_nil
            content_type.not_nil!.should eq("application/json")

            # Check that the body contains all expected fields
            body = WebMock.body(request)
            body.should_not be_nil
            body.not_nil!.includes?("chat_id").should be_true
            body.not_nil!.includes?("987654321").should be_true
            body.not_nil!.includes?("Hello with formatting").should be_true
            body.not_nil!.includes?("parse_mode").should be_true
            body.not_nil!.includes?("Markdown").should be_true
            body.not_nil!.includes?("disable_notification").should be_true
            body.not_nil!.includes?("true").should be_true

            HTTP::Client::Response.new(200, body: MOCK_MESSAGE_RESPONSE)
          end

        client.send_message(
          chat_id: 987654321,
          text: "Hello with formatting",
          parse_mode: "Markdown",
          disable_notification: true
        )
      end
    end

    it "applies custom HTTP configuration values" do
      WebMock.wrap do
        original_agent = client.http_config.user_agent

        begin
          client.configure_http do |config|
            config.user_agent = "Custom-UA"
          end

          WebMock.stub("POST", "https://api.telegram.org/bottest_token/getMe")
            .to_return do |request|
              request.headers["User-Agent"]?.should eq("Custom-UA")
              HTTP::Client::Response.new(200, body: MOCK_SUCCESS_RESPONSE)
            end

          client.get_me
        ensure
          client.configure_http do |config|
            config.user_agent = original_agent
          end
        end
      end
    end
  end

  describe "multipart form handling for file uploads" do
    it "uses multipart/form-data when uploading files with sendPhoto" do
      WebMock.wrap do
        # Use a block to validate the request dynamically
        WebMock.stub("POST", "https://api.telegram.org/bottest_token/sendPhoto")
          .to_return do |request|
            # Check that the request has multipart content type
            content_type = request.headers["Content-Type"]?
            content_type.should_not be_nil
            content_type.not_nil!.starts_with?("multipart/form-data").should be_true
            content_type.not_nil!.includes?("boundary=").should be_true

            HTTP::Client::Response.new(200, body: MOCK_MESSAGE_RESPONSE)
          end

        # Create a temporary file for testing
        temp_file = File.tempfile("test_photo.jpg")
        temp_file.print("fake image data")
        temp_file.rewind

        client.send_photo(chat_id: 987654321, photo: temp_file)

        temp_file.close
        File.delete(temp_file.path)
      end
    end

    it "handles IO objects for file uploads" do
      WebMock.wrap do
        WebMock.stub("POST", "https://api.telegram.org/bottest_token/sendDocument")
          .to_return do |request|
            # Check that the request has multipart content type
            content_type = request.headers["Content-Type"]?
            content_type.should_not be_nil
            content_type.not_nil!.starts_with?("multipart/form-data").should be_true

            HTTP::Client::Response.new(200, body: MOCK_MESSAGE_RESPONSE)
          end

        # Create an IO memory object for testing
        io = IO::Memory.new("fake document content")

        client.send_document(chat_id: 987654321, document: io)
      end
    end

    it "includes both file data and form fields in multipart requests" do
      WebMock.wrap do
        WebMock.stub("POST", "https://api.telegram.org/bottest_token/sendPhoto")
          .to_return do |request|
            # Check multipart content type
            content_type = request.headers["Content-Type"]?
            content_type.should_not be_nil
            content_type.not_nil!.starts_with?("multipart/form-data").should be_true

            # Check that the multipart body contains expected form fields
            body = WebMock.body(request)
            body.should_not be_nil
            # Check for form-data structure
            body.not_nil!.includes?("Content-Disposition: form-data").should be_true
            body.not_nil!.includes?("name=\"chat_id\"").should be_true
            body.not_nil!.includes?("name=\"caption\"").should be_true
            body.not_nil!.includes?("Test photo caption").should be_true

            HTTP::Client::Response.new(200, body: MOCK_MESSAGE_RESPONSE)
          end

        temp_file = File.tempfile("test_photo.jpg")
        temp_file.print("fake image data")
        temp_file.rewind

        client.send_photo(
          chat_id: 987654321,
          photo: temp_file,
          caption: "Test photo caption"
        )

        temp_file.close
        File.delete(temp_file.path)
      end
    end

    it "supports file uploads inside media groups using InputFile" do
      WebMock.wrap do
        WebMock.stub("POST", "https://api.telegram.org/bottest_token/sendMediaGroup")
          .to_return do |request|
            content_type = request.headers["Content-Type"]?
            content_type.should_not be_nil
            content_type.not_nil!.includes?("multipart/form-data").should be_true

            body = WebMock.body(request)
            body.should_not be_nil
            payload = body.not_nil!
            payload.includes?("name=\"media\"").should be_true
            payload.includes?("attach://file0").should be_true
            payload.includes?("name=\"file0\"").should be_true
            payload.includes?("fake photo bytes").should be_true

            response_body = {
              "ok"     => true,
              "result" => [JSON.parse(MOCK_MESSAGE_RESPONSE)["result"]],
            }.to_json
            HTTP::Client::Response.new(200, body: response_body)
          end

        media = [
          Telegram::InputMediaPhoto.new(
            type: "photo",
            media: Telegram::InputFile.from_data("fake photo bytes", "photo.jpg"),
            caption: "Album photo"
          ),
        ]

        client.send_media_group(chat_id: 987654321, media: media)
      end
    end

    it "sends JSON payloads when using existing file_ids" do
      WebMock.wrap do
        WebMock.stub("POST", "https://api.telegram.org/bottest_token/sendDocument")
          .to_return do |request|
            headers = request.headers
            headers["Content-Type"]?.should eq("application/json")

            body = WebMock.body(request)
            body.should_not be_nil
            json = JSON.parse(body.not_nil!)
            json["chat_id"].as_i.should eq(987654321)
            json["document"].as_s.should eq("FILE_ID")

            HTTP::Client::Response.new(200, body: MOCK_MESSAGE_RESPONSE)
          end

        client.send_document(chat_id: 987654321, document: "FILE_ID")
      end
    end

    it "uploads file content when sendDocument receives IO" do
      WebMock.wrap do
        WebMock.stub("POST", "https://api.telegram.org/bottest_token/sendDocument")
          .to_return do |request|
            content_type = request.headers["Content-Type"]?
            content_type.should_not be_nil
            content_type.not_nil!.includes?("multipart/form-data").should be_true

            body = WebMock.body(request)
            body.should_not be_nil
            payload = body.not_nil!
            payload.includes?("name=\"document\"").should be_true
            payload.includes?("fake document bytes").should be_true

            HTTP::Client::Response.new(200, body: MOCK_MESSAGE_RESPONSE)
          end

        io = IO::Memory.new("fake document bytes")
        client.send_document(chat_id: 987654321, document: io)
      end
    end
  end

  describe "error handling" do
    it "handles API errors correctly" do
      WebMock.wrap do
        error_response = {
          "ok"          => false,
          "error_code"  => 400,
          "description" => "Bad Request: chat not found",
        }.to_json

        WebMock.stub("POST", "https://api.telegram.org/bottest_token/sendMessage")
          .with(body: "{\"chat_id\":999999,\"text\":\"Hello\"}", headers: {"Content-Type" => "application/json"})
          .to_return(status: 200, body: error_response)

        expect_raises(Telegram::APIError, /Bad Request: chat not found/) do
          client.send_message(chat_id: 999999, text: "Hello")
        end
      end
    end

    it "handles HTTP errors correctly" do
      WebMock.wrap do
        WebMock.stub("POST", "https://api.telegram.org/bottest_token/getMe")
          .with(body: "{}", headers: {"Content-Type" => "application/json"})
          .to_return(status: 500, body: "Internal Server Error")

        expect_raises(Telegram::NetworkError, /HTTP error: 500 Internal Server Error/) do
          client.get_me
        end
      end
    end
  end

  describe "type safety" do
    it "returns properly typed objects for getMe" do
      WebMock.wrap do
        WebMock.stub("POST", "https://api.telegram.org/bottest_token/getMe")
          .with(body: "{}", headers: {"Content-Type" => "application/json"})
          .to_return(body: MOCK_SUCCESS_RESPONSE)

        result = client.get_me

        result.should be_a(Telegram::User)
        result.id.should be_a(Int64)
        result.is_bot.should be_a(Bool)
        result.first_name.should be_a(String)
      end
    end

    it "returns properly typed objects for sendMessage" do
      WebMock.wrap do
        WebMock.stub("POST", "https://api.telegram.org/bottest_token/sendMessage")
          .with(body: "{\"chat_id\":987654321,\"text\":\"Hello\"}", headers: {"Content-Type" => "application/json"})
          .to_return(body: MOCK_MESSAGE_RESPONSE)

        result = client.send_message(chat_id: 987654321, text: "Hello")

        result.should be_a(Telegram::Message)
        result.message_id.should be_a(Int64)
        result.chat.should be_a(Telegram::Chat)
      end
    end
  end

  describe "concurrency" do
    it "supports concurrent requests via the HTTP client pool" do
      WebMock.wrap do
        WebMock.stub("POST", "https://api.telegram.org/bottest_token/sendMessage")
          .to_return(body: MOCK_MESSAGE_RESPONSE)

        done = Channel(Nil).new

        5.times do
          spawn do
            client.send_message(chat_id: 987654321, text: "Hello")
            done.send(nil)
          end
        end

        5.times { done.receive }
      end
    end
  end
end

describe Telegram::InputFile do
  it "requires a multipart registry during JSON serialization" do
    input_file = Telegram::InputFile.from_data("bytes", "file.txt")

    expect_raises(ArgumentError, /only be serialized inside multipart/) do
      JSON.build { |json| input_file.to_json(json) }
    end
  end

  it "registers attachments when a registry is active" do
    input_file = Telegram::InputFile.from_data("bytes", "file.txt")
    registry = Telegram::Multipart::AttachmentRegistry.new

    json_output = String.build do |buffer|
      JSON.build(buffer) do |json|
        Telegram::Multipart.with_registry(registry) do
          input_file.to_json(json)
        end
      end
    end

    json_output.should eq("\"attach://file0\"")
    registry.attachments.size.should eq(1)
    attachment = registry.attachments.first
    attachment.name.should eq("file0")
    attachment.file.filename.should eq("file.txt")
  end

  it "copies data and rewinds source IO after write" do
    source = IO::Memory.new("payload")
    input_file = Telegram::InputFile.new(source, "payload.txt")
    destination = IO::Memory.new

    input_file.write_to(destination)

    destination.rewind
    destination.gets_to_end.should eq("payload")

    source.rewind
    source.gets_to_end.should eq("payload")
  end
end

describe Telegram::InputMediaPhoto do
  it "tracks whether it contains file data" do
    media_from_id = Telegram::InputMediaPhoto.new(
      type: "photo",
      media: "FILE_ID"
    )
    media_from_id.contains_file_data?.should be_false

    file = Telegram::InputFile.from_data("bytes", "new.jpg")
    media_from_file = Telegram::InputMediaPhoto.new(
      type: "photo",
      media: file
    )
    media_from_file.contains_file_data?.should be_true
  end
end
