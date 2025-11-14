require "json"
require "http"
require "file_utils"

module Telegram
  # Error raised when API specification cannot be fetched or parsed
  class GeneratorError < Exception
  end

  # Represents a field in an API method or type
  struct Field
    include JSON::Serializable

    property name : String
    property types : Array(String)
    property required : Bool
    property description : String

    @[JSON::Field(key: "type")]
    property type_field : String?

    def self.from_json(json : String)
      parser = JSON::PullParser.new(json)
      from_json(parser)
    end

    def initialize(@name : String, @types : Array(String), @required : Bool = false, @description : String = "")
    end
  end

  # Represents an API method
  struct APIMethod
    include JSON::Serializable

    property name : String
    property href : String
    property description : Array(String)
    property returns : Array(String)
    property fields : Array(Field)?

    def initialize(@name : String, @href : String, @description : Array(String), @returns : Array(String), @fields : Array(Field)? = nil)
    end
  end

  # Represents an API type/object
  struct APIType
    include JSON::Serializable

    property name : String
    property href : String?
    property description : Array(String)?
    property fields : Array(Field)?
    property extends : Array(String)?

    def initialize(@name : String, @fields : Array(Field)? = nil, @href : String? = nil, @description : Array(String)? = nil, @extends : Array(String)? = nil)
    end
  end

  # The complete API specification
  struct APISpec
    include JSON::Serializable

    property version : String
    property release_date : String
    property changelog : String
    property methods : Hash(String, APIMethod)
    property types : Hash(String, APIType)?

    def initialize(@version : String, @release_date : String, @changelog : String, @methods : Hash(String, APIMethod), @types : Hash(String, APIType)? = nil)
    end
  end

  # Main generator class
  class Generator
    API_SPEC_URL = "https://raw.githubusercontent.com/PaulSonOfLars/telegram-bot-api-spec/master/api.min.json"

    property spec : APISpec?
    property output_dir : String

    def initialize(@output_dir : String = "./src/telegram/generated")
    end

    # Download and parse the API specification
    def load_spec(url : String = API_SPEC_URL) : APISpec
      response = HTTP::Client.get(url)

      unless response.success?
        raise GeneratorError.new("Failed to fetch API spec: #{response.status_code}")
      end

      @spec = APISpec.from_json(response.body)
    end

    # Generate all files
    def generate
      spec = @spec || load_spec

      # Ensure output directory exists
      FileUtils.mkdir_p(output_dir)

      # Generate types first (get content as string)
      types_content = generate_types(spec)

      # Generate client
      generate_client(spec)

      # Generate main module file with types included
      generate_main_module(spec, types_content)
    end

    # Generate Crystal types for all API objects
    private def generate_types(spec : APISpec) : String
      type_generator = TypeGenerator.new(output_dir)
      type_generator.generate(spec)
      type_generator.types_content
    end

    # Generate HTTP client methods
    private def generate_client(spec : APISpec)
      client_generator = ClientGenerator.new(output_dir)
      client_generator.generate(spec)
    end

    # Generate the main module file that ties everything together
    private def generate_main_module(spec : APISpec, types_content : String)
      main_generator = MainModuleGenerator.new(output_dir)
      main_generator.generate(spec, types_content)
    end
  end
end