module Finicity::V1
  module Request
    class GetInstitutionById
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.cookie_manager = nil
      end

      ##
      # Attributes
      #
      attr_accessor :institution_id, :token

      ##
      # Instance Methods
      #
      def initialize(token, institution_id)
        @institution_id = institution_id
        @token = token
      end

      def get_institution_by_id
        query = nil
        http_client.get(url, query, headers)
      end

      def headers
        {
          'Finicity-App-Key' => ::Finicity.config.app_key,
          'Finicity-App-Token' => token,
          'Content-Type' => 'application/json',
          'Accept' => 'application/json'
        }
      end

      def url
        ::URI.join(
          ::Finicity.config.base_url,
          'aggregation/',
          'v1/',
          'institutions/',
          "#{institution_id}/",
          'details'
        )
      end
    end
  end
end
