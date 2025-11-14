require "spec"
require "json"
require "webmock"
require "../src/telegram/generated/telegram"

# Mock successful Telegram API response
MOCK_SUCCESS_RESPONSE = {
  "ok" => true,
  "result" => {
    "id" => 123456789,
    "is_bot" => true,
    "first_name" => "Test Bot",
    "username" => "testbot"
  }
}.to_json

MOCK_MESSAGE_RESPONSE = {
  "ok" => true,
  "result" => {
    "message_id" => 123,
    "from" => {
      "id" => 123456789,
      "is_bot" => true,
      "first_name" => "Test Bot",
      "username" => "testbot"
    },
    "chat" => {
      "id" => 987654321,
      "first_name" => "Test User",
      "type" => "private"
    },
    "date" => 1640000000,
    "text" => "Hello"
  }
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
  end

  describe "error handling" do
    it "handles API errors correctly" do
      WebMock.wrap do
        error_response = {
          "ok" => false,
          "error_code" => 400,
          "description" => "Bad Request: chat not found"
        }.to_json

        WebMock.stub("POST", "https://api.telegram.org/bottest_token/sendMessage")
          .with(body: "{\"chat_id\":999999,\"text\":\"Hello\"}", headers: {"Content-Type" => "application/json"})
          .to_return(status: 200, body: error_response)

        expect_raises(Exception, /Telegram API error: Bad Request: chat not found/) do
          client.send_message(chat_id: 999999, text: "Hello")
        end
      end
    end

    it "handles HTTP errors correctly" do
      WebMock.wrap do
        WebMock.stub("POST", "https://api.telegram.org/bottest_token/getMe")
          .with(body: "{}", headers: {"Content-Type" => "application/json"})
          .to_return(status: 500, body: "Internal Server Error")

        expect_raises(Exception, /Telegram API error: 500 - Internal Server Error/) do
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
        result.id.should be_a(Int32)
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
        result.message_id.should be_a(Int32)
        result.chat.should be_a(Telegram::Chat)
      end
    end
  end
end