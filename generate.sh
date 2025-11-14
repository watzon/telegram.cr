#!/bin/bash

# Telegram Bot API Client Generator
# This script runs the Crystal-based generator to create a type-safe Telegram Bot API client

set -e

echo "🤖 Telegram Bot API Client Generator"
echo "===================================="
echo

# Check if Crystal is installed
if ! command -v crystal &> /dev/null; then
    echo "❌ Error: Crystal is not installed or not in PATH"
    echo "   Please install Crystal: https://crystal-lang.org/install/"
    exit 1
fi

# Check if generator source exists
if [ ! -f "./src/telegram/generator.cr" ]; then
    echo "❌ Error: Generator source file not found at ./src/telegram/generator.cr"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p src/telegram/generated

echo "✅ Running generator..."
echo

# Run the generator
crystal run ./src/telegram/generator.cr

echo
echo "🎉 Generator completed successfully!"
echo
echo "📁 Generated files:"
echo "   • src/telegram/generated/telegram.cr    - Main module with types"
echo "   • src/telegram/generated/client.cr      - HTTP client implementation"
echo
echo "🚀 Your Telegram Bot API client is ready to use!"
echo
echo "💡 Usage example:"
echo "   require \"./src/telegram/generated/telegram\""
echo
echo "   client = Telegram::APIClient.new(\"YOUR_BOT_TOKEN\")"
echo "   bot_info = client.getMe"
echo "   puts \"Bot ID: #{bot_info.id}\""
echo "   puts \"Bot Name: #{bot_info.first_name}\""