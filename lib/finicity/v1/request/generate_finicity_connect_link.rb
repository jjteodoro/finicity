module Finicity::V1
  module Request
    class GenerateFinicityConnectLink
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.cookie_manager = nil
      end

      attr_accessor :customer_id, :token, :redirect_uri

      def initialize(token, customer_id, redirect_uri)
        @customer_id = customer_id
        @token = token
        @redirect_uri = redirect_uri
      end

      def generate_link
        http_client.post(url, body, headers)
      end

      def body
        data = {}
        data['partnerId'] = ::Finicity.config.partner_id
        data['customerId'] = "#{customer_id}"
        data['redirectUri'] = redirect_uri
        data['type'] = 'aggregation'
        data.to_json(:root => 'data')
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
          'connect/v1/generate'
        )
      end
    end
  end
end
