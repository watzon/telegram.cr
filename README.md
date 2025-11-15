# Telegram

> A dead simple Telegram Bot API client for Crystal

This library generates a type-safe Telegram Bot API client from the official API specification, providing full Crystal bindings for all Telegram Bot API methods and types.

## Table of Contents

- [Background](#background)
- [Install](#install)
- [Usage](#usage)
- [API](#api)
- [Examples](#examples)
- [Generating the Client](#generating-the-client)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)

## Background

The Telegram Bot API provides a simple way to create bots that can interact with Telegram users. This Crystal library generates a complete, type-safe client that handles:

- All Telegram Bot API methods with proper typing
- Automatic file upload detection (JSON vs multipart)
- Thread-safe multipart form handling
- Production-ready HTTP client with retries and connection pooling
- Full support for all API types and union types

## Install

Add this to your application's `shard.yml`:

```yaml
dependencies:
  telegram:
    github: your-username/telegram
```

## Usage

### Basic Bot

```crystal
require "telegram/generated/telegram"

# Initialize the client
client = Telegram::APIClient.new("YOUR_BOT_TOKEN")

# Send a message
client.send_message(
  chat_id: 123456789,
  text: "Hello, World!"
)

# Send a photo
client.send_photo(
  chat_id: 123456789,
  photo: Telegram::InputFile.from_path("photo.jpg"),
  caption: "Here's a photo"
)
```

### Long-polling Bot

```crystal
client = Telegram::APIClient.new("YOUR_BOT_TOKEN")
last_update_id = 0

loop do
  updates = client.get_updates(offset: last_update_id, timeout: 20)

  updates.each do |update|
    last_update_id = update.update_id + 1

    if message = update.message
      if text = message.text
        case text
        when "/start"
          client.send_message(
            chat_id: message.chat.id,
            text: "Welcome to my bot!"
          )
        else
          client.send_message(
            chat_id: message.chat.id,
            text: "You said: #{text}"
          )
        end
      end
    end
  end
rescue ex
  puts "Error: #{ex.message}"
  sleep 1.second
  retry
end
```

### File Uploads

The library automatically detects when you're uploading files and switches to multipart form data:

```crystal
# Upload from file path
client.send_document(
  chat_id: 123456789,
  document: Telegram::InputFile.from_path("document.pdf")
)

# Upload from IO object
file_io = File.open("photo.jpg")
client.send_photo(
  chat_id: 123456789,
  photo: Telegram::InputFile.new(file_io, "photo.jpg", "image/jpeg")
)

# Upload raw bytes
bytes = File.read("data.bin")
client.send_document(
  chat_id: 123456789,
  document: Telegram::InputFile.new(IO::Memory.new(bytes), "data.bin", "application/octet-stream")
)
```

## API

The generated client provides methods for all Telegram Bot API endpoints. Each method:

- Returns properly typed Crystal objects
- Handles both JSON and multipart requests automatically
- Includes all optional parameters from the official API
- Supports union types for flexible input

### HTTP Client Configuration

Configure the underlying HTTP client for production use:

```crystal
client.configure_http do |config|
  config.timeout = 30.seconds
  config.retry_attempts = 3
  config.retry_delay = 1.second
  config.log_requests = true
  config.log_responses = false
end
```

### Error Handling

The library provides specific exception types:

```crystal
begin
  client.send_message(chat_id: 123456789, text: "Hello")
rescue Telegram::APIError ex
  puts "API Error: #{ex.message} (code: #{ex.error_code})"
rescue Telegram::NetworkError ex
  puts "Network Error: #{ex.message}"
rescue Telegram::TimeoutError ex
  puts "Request timed out"
end
```

## Examples

See the `examples/` directory for complete working examples:

- `test_bot.cr` - Full-featured bot with long-polling, file uploads, and inline keyboards
- More examples coming soon

Run the example:

```bash
# Set your bot token
export TELEGRAM_TEST_TOKEN="your_bot_token_here"
export TELEGRAM_TEST_CHAT_ID="your_chat_id_here"

# Run the test bot
crystal run examples/test_bot.cr
```

## Generating the Client

The client is generated from the official Telegram Bot API specification. To regenerate:

```bash
# Generate to default location (src/telegram/generated)
crystal run ./src/telegram/generator.cr

# Or use the convenience script
./generate.sh

# Generate with custom output directory
crystal run ./src/telegram/generator.cr -- ./src/custom/output

# Build the generator binary
crystal build src/bin/telegram-gen.cr
./telegram-gen -o ./src/telegram/generated
```

The generated files are:
- `telegram.cr` - Main module with all API types and the client interface
- `client.cr` - HTTP client implementation with all API methods

These files should not be manually edited as they will be overwritten on regeneration.

## Development

### Setup

```bash
# Install dependencies
shards install

# Generate the client
./generate.sh

# Run tests
crystal spec

# Run tests with verbose output
crystal spec --verbose
```

### Project Structure

- `src/telegram/generator.cr` - Main code generator
- `src/telegram/type_generator.cr` - Type definition generator
- `src/telegram/client_generator.cr` - API method generator
- `src/telegram/http_client_wrapper.cr` - Production HTTP client
- `src/telegram/input_file.cr` - File upload handling
- `src/telegram/generated/` - Generated client code (don't edit)

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Based on the [official Telegram Bot API specification](https://core.telegram.org/bots/api)
- Generated from [PaulSonOfLars/telegram-bot-api-spec](https://github.com/PaulSonOfLars/telegram-bot-api-spec)