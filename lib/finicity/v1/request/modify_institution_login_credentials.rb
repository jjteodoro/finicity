module Finicity::V1
  module Request
    class ModifyInstitutionLoginCredentials
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.cookie_manager = nil
      end

      attr_accessor :customer_id,
        :institution_login_id,
        :login_credentials,
        :token

      def initialize(token, customer_id, institution_login_id, login_credentials)
        @customer_id = customer_id
        @institution_login_id = institution_login_id
        @login_credentials = login_credentials
        @token = token
      end

      def modify_credentials
        http_client.put(url, body, headers)
      end

      def body
        { 'loginForm' => login_credentials }.to_json
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
          'institutionLogins/',
          "#{institution_login_id}"
        )
      end
    end
  end
end
