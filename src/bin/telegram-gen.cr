#!/usr/bin/env crystal

require "option_parser"
require "../telegram/generator"
require "../telegram/type_generator"
require "../telegram/client_generator"
require "../telegram/main_module_generator"

# Parse command line arguments
output_dir = "./src/telegram/generated"
api_spec_url = Telegram::Generator::API_SPEC_URL

OptionParser.parse(ARGV) do |parser|
  parser.banner = "Usage: telegram-gen [options]"
  parser.on("-o DIR", "--output=DIR", "Output directory (default: ./src/telegram/generated)") { |dir| output_dir = dir }
  parser.on("-u URL", "--url=URL", "API specification URL") { |url| api_spec_url = url }
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end
  parser.on("-v", "--version", "Show version") do
    puts "Telegram Generator 0.1.0"
    exit
  end
end

puts "🤖 Telegram Bot API Client Generator"
puts "=================================="
puts "Output directory: #{output_dir}"
puts "API spec URL: #{api_spec_url}"
puts

begin
  puts "📥 Creating generator..."
  generator = Telegram::Generator.new(output_dir)
  puts "📄 Generating Telegram Bot API client..."
  generator.generate
  puts "✅ Generation complete!"
  puts
  puts "Generated files:"
  puts "  - #{File.join(output_dir, "telegram.cr")}"
  puts "  - #{File.join(output_dir, "client.cr")}"
  puts
  puts "You can now use the generated client:"
  puts
  puts "```crystal"
  puts "require \"#{output_dir}/telegram\""
  puts ""
  puts "# Create a client with your bot token"
  puts "client = Telegram::APIClient.new(\"YOUR_BOT_TOKEN\")"
  puts ""
  puts "# Get updates"
  puts "updates = client.get_updates"
  puts ""
  puts "# Send a message"
  puts "client.send_message(chat_id: 123456, text: \"Hello, World!\")"
  puts "```"
rescue ex : Exception
  puts "❌ Error: #{ex.class}: #{ex.message}"
  puts "Backtrace: #{ex.backtrace?.try(&.join("\n"))}"
  exit 1
end
