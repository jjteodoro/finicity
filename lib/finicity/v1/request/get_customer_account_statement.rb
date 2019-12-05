module Finicity::V1
  module Request
    class GetCustomerAccountStatement
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.cookie_manager = nil
      end

      ##
      # Attributes
      #
      attr_accessor :token, :customer_id, :account_id

      ##
      # Instance Methods
      #
      def initialize(token, customer_id, account_id)
        @token = token
        @customer_id = customer_id
        @account_id = account_id
      end

      def get_customer_account_statement
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
          'customers/',
          "#{customer_id}/",
          'accounts/',
          "#{account_id}/",
          'statement'
        )
      end
    end
  end
end
