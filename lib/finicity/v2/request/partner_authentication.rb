module Finicity::V2
  module Request
    class PartnerAuthentication
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.cookie_manager = nil
      end

      ##
      # Instance Methods
      #
      def authenticate
        http_client.post(url, body, headers)
      end

      def body
        {
          'partnerId' => ::Finicity.config.partner_id,
          'partnerSecret' => ::Finicity.config.partner_secret
        }.to_json
      end

      def headers
        {
          'Finicity-App-Key' => ::Finicity.config.app_key,
          'Content-Type' => 'application/json',
          'Accept' => 'application/json'
        }
      end

      def url
        ::URI.join(
          ::Finicity.config.base_url, 
          'aggregation/',
          'v2/partners/authentication'
        )
      end
    end
  end
end
