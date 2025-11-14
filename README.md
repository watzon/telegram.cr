# Telegram Bot API Client Generator

> A Crystal-based code generator that creates a type-safe, comprehensive Telegram Bot API client from the official API specification

[![Crystal](https://img.shields.io/badge/Crystal-0.35+-lightblue.svg)](https://crystal-lang.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## Table of Contents

- [Install](#install)
- [Usage](#usage)
- [API](#api)
- [Security](#security)
- [Contributing](#contributing)
- [License](#license)

## Install

This project requires Crystal 0.35 or higher.

### Prerequisites

1. **Install Crystal** - Follow the official installation guide: [https://crystal-lang.org/install/](https://crystal-lang.org/install/)

2. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/telegram.git
   cd telegram
   ```

3. **Install dependencies**
   ```bash
   shards install
   ```

### Generate the Telegram Client

Run the included generator script:

```bash
./generate.sh
```

Or manually run the generator:

```bash
crystal run ./src/telegram/generator.cr
```

This will generate:
- `src/telegram/generated/telegram.cr` - Complete type definitions
- `src/telegram/generated/client.cr` - HTTP client implementation

## Usage

### Basic Example

```crystal
require "./src/telegram/generated/telegram"

# Create a client with your bot token
client = Telegram::APIClient.new("YOUR_BOT_TOKEN")

# Get bot information
bot_info = client.get_me
puts "Bot ID: #{bot_info.id}"
puts "Bot Name: #{bot_info.first_name}"
puts "Username: @#{bot_info.username}"

# Send a message
message = client.send_message(
  chat_id: 123456789,
  text: "Hello from Crystal! 🚀"
)
puts "Message sent with ID: #{message.message_id}"
```

### File Uploads

```crystal
# Send a photo
client.send_photo(
  chat_id: 123456789,
  photo: File.open("path/to/photo.jpg"),
  caption: "Check out this photo!"
)

# Send a document from IO
client.send_document(
  chat_id: 123456789,
  document: IO::Memory.new("document content"),
  caption: "Generated document"
)
```

### Advanced Usage

```crystal
# Use optional parameters
client.send_message(
  chat_id: 123456789,
  text: "*Bold text* and _italic text_",
  parse_mode: "Markdown",
  disable_notification: true
)

# Handle updates
updates = client.get_updates(offset: 0, limit: 10)
updates.each do |update|
  puts "Received: #{update.message?.try(&.text)}"
end
```

## API

The generated client provides complete coverage of the Telegram Bot API v9.2 with:

### Features

- **Type Safety**: All methods return proper Crystal types (not `JSON::Any`)
- **Multipart Form Support**: Automatic handling of file uploads with `multipart/form-data`
- **Error Handling**: Proper exception handling for API and HTTP errors
- **Parameter Validation**: Required parameters are enforced, optional parameters have sensible defaults
- **JSON Serialization**: Automatic serialization/deserialization of complex types

### Key Methods

| Method | Description | Return Type |
|--------|-------------|-------------|
| `get_me()` | Get basic bot information | `Telegram::User` |
| `send_message(chat_id, text, ...)` | Send text messages | `Telegram::Message` |
| `send_photo(chat_id, photo, ...)` | Send photos | `Telegram::Message` |
| `send_document(chat_id, document, ...)` | Send documents | `Telegram::Message` |
| `get_updates(offset?, limit?, ...)` | Get incoming updates | `Array(Telegram::Update)` |
| `set_webhook(url?, ...)` | Configure webhook | `Bool` |

### Complete API Coverage

The client supports all 100+ Telegram Bot API methods including:
- Messages (text, photos, documents, audio, video, etc.)
- Inline mode
- Games
- Payments
- Stickers
- Chats management
- Webhooks
- And much more...

### Type Mapping

| Telegram API Type | Crystal Type |
|-------------------|--------------|
| `Integer` | `Int32` |
| `Float` | `Float64` |
| `String` | `String` |
| `Boolean` | `Bool` |
| `Array of Type` | `Array(Type)` |
| `InputFile` | `File | IO` |
| Custom types | `Telegram::TypeName` |

## Security

### Bot Token Security

- **Never commit bot tokens** to version control
- Use environment variables or configuration files
- Consider using `.env` files (add to `.gitignore`)

```crystal
# Recommended: Load from environment
token = ENV["TELEGRAM_BOT_TOKEN"]
client = Telegram::APIClient.new(token)
```

### Webhook Security

When using webhooks:
- Always validate webhook requests
- Use HTTPS for webhook URLs
- Implement proper authentication

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Setup

1. **Fork and clone**
   ```bash
   git clone https://github.com/your-username/telegram.git
   cd telegram
   ```

2. **Install dependencies**
   ```bash
   shards install
   ```

3. **Run tests**
   ```bash
   crystal spec
   ```

4. **Run generator**
   ```bash
   ./generate.sh
   ```

### Running Tests

The project includes comprehensive tests using Crystal's built-in testing framework and WebMock for HTTP request stubbing:

```bash
# Run all tests
crystal spec

# Run with verbose output
crystal spec --verbose

# Run specific test file
crystal spec spec/telegram_client_spec.cr
```

### Test Coverage

The test suite covers:
- HTTP request generation and validation
- JSON request body serialization
- Multipart form data for file uploads
- Error handling (API errors and HTTP errors)
- Type safety and return type validation
- File upload handling (File objects, IO objects)

### Style Guide

- Follow Crystal style guidelines
- Use crystal tool format for code formatting
- Write descriptive commit messages following [Conventional Commits](https://www.conventionalcommits.org/)
- Add tests for new features

### Contact

- **GitHub Issues**: [Create an issue](https://github.com/your-username/telegram/issues)
- **Author**: watzon

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- [Telegram Bot API](https://core.telegram.org/bots/api) - The official API documentation
- [Crystal Programming Language](https://crystal-lang.org/) - Amazing type-safe language
- [WebMock.cr](https://github.com/manastech/webmock.cr) - HTTP request stubbing for testing
- The Crystal community for inspiration and feedback