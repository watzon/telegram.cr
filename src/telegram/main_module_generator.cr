module Telegram
  # Generates the main module file that ties everything together
  class MainModuleGenerator
    property output_dir : String

    def initialize(@output_dir : String)
    end

    def generate(spec : APISpec, types_content : String)
      content = String.build do |str|
        str << "# Crystal Telegram Bot API Client\n"
        str << "#\n"
        str << "# Generated for Telegram Bot API #{spec.version}\n"
        str << "# Release date: #{spec.release_date}\n"
        str << "#\n"
        str << "# This is an automatically generated client for the Telegram Bot API.\n"
        str << "# It provides typesafe access to all Telegram Bot API methods and types.\n"
        str << "#\n"
        str << "# Example usage:\n"
        str << "# ```crystal\n"
        str << "# require \"telegram\"\n"
        str << "#\n"
        str << "# client = Telegram::APIClient.new(\"YOUR_BOT_TOKEN\")\n"
        str << "# updates = client.get_updates\n"
        str << "# ```\n\n"

        str << "require \"json\"\n"
        str << "require \"./client\"\n\n"

        str << "module Telegram\n"

        # Include all types directly in the module
        str << types_content
        str << "\n"

        str << "  VERSION = \"#{spec.version}\"\n"
        str << "  RELEASE_DATE = \"#{spec.release_date}\"\n\n"

        # Re-export the APIClient from Client module for easier access
        str << "  # Re-export APIClient for convenience\n"
        str << "  APIClient = Client::APIClient\n"
        str << "end\n"
      end

      # Write to file
      filename = File.join(output_dir, "telegram.cr")
      File.write(filename, content)
    end
  end
end