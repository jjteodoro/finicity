module Finicity::V1
  module Request
    class InteractiveRefreshAccountWithMfa
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.receive_timeout = 180
        client.cookie_manager = nil
      end

      ##
      # Attributes
      #
      attr_accessor :account_id,
        :customer_id,
        :mfa_credentials,
        :mfa_session_id,
        :token

      ##
      # Instance Methods
      #
      def initialize(token, mfa_session_id, customer_id, account_id, mfa_credentials)
        @account_id = account_id
        @customer_id = customer_id
        @mfa_credentials = mfa_credentials
        @mfa_session_id = mfa_session_id
        @token = token
      end

      def interactive_refresh_account_with_mfa
        http_client.post(url, body, headers)
      end

      def body
        builder = ::Nokogiri::XML::Builder.new do |xml|
          xml.mfaChallenges {
            xml.questions {
              mfa_credentials.each do |mfa_credential|
                xml.question {
                  xml.text_(mfa_credential[:text])
                  xml.answer(mfa_credential[:answer])
                }
              end
            }
          }
        end

        builder.to_xml
      end

      def headers
        {
          'Finicity-App-Key' => ::Finicity.config.app_key,
          'Finicity-App-Token' => token,
          'MFA-Session' => mfa_session_id,
          'Content-Type' => 'application/xml'
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
          'mfa'
        )
      end

    end
  end
end
