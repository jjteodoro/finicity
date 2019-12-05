module Finicity::V1
  module Request
    class GetAccount
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.cookie_manager = nil
      end

      ##
      # Attributes
      #
      attr_accessor :customer_id, :account_id, :token

      ##
      # Instance Methods
      #
      def initialize(token, customer_id, account_id)
        @account_id = account_id
        @customer_id = customer_id
        @token = token
      end

      def get_account
        http_client.get(url, nil, headers)
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
          'accounts/',
          "#{account_id}"
        )
      end
    end
  end
end
