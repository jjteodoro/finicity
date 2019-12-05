module Finicity::V1
  module Request
    class GetAllInstitutions
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient

      include_http_client do |client|
        client.cookie_manager = nil
      end

      attr_accessor :token

      def initialize(token)
        @token = token
      end

      def get_all_institutions
        http_client.get(url, nil, headers)
      end

      def headers
        {
          'Finicity-App-Key' => ::Finicity.config.app_key,
          'Finicity-App-Token' => token,
          'Accept' => 'application/json'
        }
      end

      def url
        ::URI.join(
          ::Finicity.config.base_url,
          'aggregation/',
          'v1/',
          'institutions'
        )
      end
    end
  end
end
