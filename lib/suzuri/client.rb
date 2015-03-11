require 'faraday'
require 'json'

module Suzuri
  class Client
    def initialize(api_key, api_base, api_version)
      default_header = {
        'Authorization' => "Bearer #{api_key}",
        'User-Agent' => "Suzuri#{api_version} RubyBinding/#{Suzuri::VERSION}"
      }

      @conn = Faraday.new("#{api_base}", headers: default_header) do |builder|
        builder.request :url_encoded
        builder.adapter Faraday.default_adapter
      end
      @api_version = api_version
    end

    def handle_response(response)
      case response.status
      when 204
        Suzuri::SuzuriError.from_response(response.status, response.body)
      when 200..299
        begin
          JSON.parse(response.body)
        rescue JSON::ParserError => e
          raise Suzuri::APIConnectionError.new("Response JSON is broken. #{e.message}: #{response.body}")
        end
      else
        Suzuri::SuzuriError.from_response(response.status, response.body)
      end
    end

    Faraday::Connection::METHODS.each do |method|
      define_method(method) do |url, *args|
        begin
          binding.pry
          response = @conn.__send__(method, @api_version + url, *args)
        rescue Faraday::Error::ClientError => e
          raise Suzuri::APIConnectionError.faraday_error(e)
        end
        handle_response(response)
      end
    end
  end
end
