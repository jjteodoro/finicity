module Finicity::V1
  module Request
    class RefreshInstitutionAccountsWithMfa
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.receive_timeout = 180
        client.cookie_manager = nil
      end

      ##
      # Attributes
      #
      attr_accessor :customer_id,
        :institution_login_id,
        :mfa_credentials,
        :mfa_session_id,
        :token

      ##
      # Instance Methods
      #
      def initialize(token, mfa_session_id, customer_id, institution_login_id, mfa_credentials)
        @customer_id = customer_id
        @institution_login_id = institution_login_id
        @mfa_credentials = mfa_credentials
        @mfa_session_id = mfa_session_id
        @token = token
      end

      # The accounts parameter is the finicity representation of accounts
      def refresh_institution_accounts_with_mfa
        http_client.post(url, body, headers)
      end

      def body
        { 'questions' => mfa_credentials }.to_json
      end

      def headers
        {
          'Finicity-App-Key' => ::Finicity.config.app_key,
          'Finicity-App-Token' => token,
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          'MFA-Session' => mfa_session_id
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
          'accounts/',
          'mfa'
        )
      end
    end
  end
end
