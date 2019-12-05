module Finicity::V2
  module Request
    class ActivateAccounts
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.cookie_manager = nil
      end

      ##
      # Attributes
      #
      attr_accessor :accounts,
        :customer_id,
        :institution_id,
        :token

      ##
      # Instance Methods
      #
      def initialize(token, customer_id, institution_id, accounts=[])
        @accounts = accounts
        @customer_id = customer_id
        @institution_id = institution_id
        @token = token
      end

      def activate_accounts
        http_client.put(url, body, headers)
      end

      # The accounts parameter is the finicity representation of accounts
      def body
        { 'accounts' => accounts }.to_json
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
          'v2/',
          'customers/',
          "#{customer_id}/",
          'institutions/',
          "#{institution_id}/",
          'accounts',
        )
      end

    end
  end
end
