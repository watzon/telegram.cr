# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Crystal Telegram Bot API client generator that creates a type-safe client from Telegram's official API specification. The project generates Crystal bindings for the Telegram Bot API v9.2, including all API methods and types.

## Architecture

### Code Generation System
The codebase is organized around a multi-stage generation pipeline:

1. **API Specification Fetcher** (`src/telegram/generator.cr`):
   - Downloads the Telegram Bot API specification from `https://raw.githubusercontent.com/PaulSonOfLars/telegram-bot-api-spec/master/api.min.json`
   - Parses the JSON specification into structured objects (`APISpec`, `APIMethod`, `APIType`)

2. **Type Generator** (`src/telegram/type_generator.cr`):
   - Converts Telegram API types to Crystal type definitions
   - Handles union types, array types, and field mappings
   - Uses flexible integer types (Int32 | Int64) for compatibility
   - Generates both classes (for complex types) and records (for simple types)

3. **Client Generator** (`src/telegram/client_generator.cr`):
   - Generates HTTP client methods for all API endpoints
   - Handles both JSON requests and multipart file uploads
   - Includes runtime file detection to choose appropriate request format
   - Integrates with the enhanced HTTP client wrapper

4. **Main Module Generator** (`src/telegram/main_module_generator.cr`):
   - Creates the main module file that ties everything together
   - Includes all generated types and client functionality

### Enhanced HTTP Client
The project includes a production-ready HTTP client wrapper (`src/telegram/http_client_wrapper.cr`) with:
- Connection pooling and persistent connections
- Automatic retry logic with exponential backoff
- Configurable timeouts and SSL settings
- Proxy support (structure in place)
- Comprehensive error handling with custom exception types
- Request/response logging capabilities

### File Upload System
Advanced multipart form handling (`src/telegram/input_file.cr`):
- Thread-local attachment registry for file uploads
- Support for `InputFile`, `File`, and `IO` objects
- Automatic boundary generation and multipart encoding
- Runtime detection of file data in API calls

## Common Commands

### Generation
```bash
# Generate the Telegram client (default output: ./src/telegram/generated)
crystal run ./src/telegram/generator.cr

# Or use the convenience script
./generate.sh

# Generate with custom output directory
crystal run ./src/telegram/generator.cr -- ./src/custom/output

# Use the binary target
crystal build src/bin/telegram-gen.cr
./telegram-gen -o ./src/telegram/generated
```

### Testing
```bash
# Run all tests
crystal spec

# Run specific test file
crystal spec spec/telegram_client_spec.cr

# Run with verbose output
crystal spec --verbose

# Run specific test example
crystal spec spec/telegram_client_spec.cr:37
```

### Development
```bash
# Install dependencies
shards install

# Build the project
crystal build src/telegram/generator.cr

# Format code
crystal tool format

# Lint code (if using ameba)
ameba
```

## Key Design Patterns

### Type Safety
- All API methods return properly typed Crystal objects
- Union types for fields that can accept multiple types
- Compile-time type checking for all parameters

### File Handling
- Runtime file detection determines whether to use JSON or multipart requests
- Thread-safe file upload registry using fiber-local storage
- Support for various input types (File paths, IO objects, raw data)

### Error Handling
- Custom exception hierarchy (`APIError`, `NetworkError`, `TimeoutError`)
- Automatic retry with configurable backoff for transient failures
- Detailed error information including error codes and response bodies

### Configuration
- Flexible HTTP client configuration with presets for production/development
- Environment-specific settings (timeouts, retries, logging)
- Proxy and SSL configuration options

## Testing Infrastructure

The test suite uses WebMock for HTTP request mocking and includes:
- Unit tests for HTTP client functionality
- Integration tests for file upload scenarios
- Type safety verification tests
- Concurrency tests for thread safety
- Error handling validation

Tests are organized in `spec/` with comprehensive coverage of the client's functionality, including edge cases for file uploads and network failures.

## Generated Output

The generator creates two main files in `src/telegram/generated/`:
- `telegram.cr` - Main module with all API types and the primary client interface
- `client.cr` - HTTP client implementation with all API methods

These files are meant to be consumed as a library and should not be manually edited, as they will be overwritten on regeneration.