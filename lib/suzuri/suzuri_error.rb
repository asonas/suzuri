require 'json'
module Suzuri
  class SuzuriError < StandardError

    def self.from_response(status, body)
      hash =
        begin
          JSON.load(body)
        rescue JSON::ParserError => e
          return Suzuri::APIConnectionError.new("Response JSON is broken. #{e.message}: #{body}", e)
        end
      unless hash['errors']
        return APIConnectionError.new("Invalid response #{body}")
      end

      APIError.new(status, hash["errors"])
    end

    attr_reader :status
    attr_reader :error_response

    def initialize(message, status = nil, error_response = nil)
      @status, @error_response = status, error_response
      super(message)
    end
  end

  class APIConnectionError < SuzuriError
    def self.faraday_error(e)
      new("Connection with Suzuri API server failed. #{e.message}", e)
    end

    attr_reader :original_error

    def initialize(message, original_error)
      @original_error = original_error
      super(message)
    end
  end

  class APIError < SuzuriError
    attr_reader :errors

    def initilize(message, error_response)
      @errors = error_response["errors"]
      super(error_response["message"], status, error_response)
    end
  end
end
