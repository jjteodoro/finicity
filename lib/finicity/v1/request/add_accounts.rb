module Finicity::V1
  module Request
    class AddAccounts
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.cookie_manager = nil
      end

      ##
      # Attributes
      #
      attr_accessor :login_credentials,
        :customer_id,
        :institution_id,
        :token

      ##
      # Instance Methods
      #
      def initialize(token, customer_id, institution_id, login_credentials)
        @customer_id = customer_id
        @institution_id = institution_id
        @login_credentials = login_credentials
        @token = token
      end

      # The accounts parameter is the finicity representation of accounts
      def add_accounts
        http_client.post(url, body, headers)
      end

      # The accounts parameter is the finicity representation of accounts
      def body
        { 'credentials' => login_credentials }.to_json
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
          'institutions/',
          "#{institution_id}/",
          'accounts/',
          'addall'
        )
      end
    end
  end
end
