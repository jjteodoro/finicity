module Finicity::V1
  module Request
    class GetAccounts
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.cookie_manager = nil
      end

      ##
      # Attributes
      #
      attr_accessor :customer_id, :institution_id, :token

      ##
      # Instance Methods
      #
      def initialize(token, customer_id, institution_id)
        @customer_id = customer_id
        @institution_id = institution_id
        @token = token
      end

      def get_accounts
        request_url = institution_id ? url_by_institution : url
        http_client.get(request_url, nil, headers)
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
          'customers/',
          "#{customer_id}/",
          'accounts'
        )
      end

      def url_by_institution
        ::URI.join(
          ::Finicity.config.base_url,
          'aggregation/',
          'v1/',
          'customers/',
          "#{customer_id}/",
          'institutions/',
          "#{institution_id}/",
          'accounts'
        )
      end
    end
  end
end
