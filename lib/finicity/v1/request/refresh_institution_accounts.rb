module Finicity::V1
  module Request
    class RefreshInstitutionAccounts
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.receive_timeout = 180
        client.cookie_manager = nil
      end

      ##
      # Attributes
      #
      attr_accessor :customer_id, :institution_login_id, :token

      ##
      # Instance Methods
      #
      def initialize(token, customer_id, institution_login_id)
        @customer_id = customer_id
        @institution_login_id = institution_login_id
        @token = token
      end

      # The accounts parameter is the finicity representation of accounts
      def refresh_institution_accounts
        body = {}
        http_client.post(url, body, headers)
      end

      def headers
        {
          'Finicity-App-Key' => ::Finicity.config.app_key,
          'Finicity-App-Token' => token,
          'Content-Length' => 0,
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
          'institutionLogins/',
          "#{institution_login_id}/",
          'accounts'
        )
      end
    end
  end
end
