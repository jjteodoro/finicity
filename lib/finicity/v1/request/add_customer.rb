module Finicity::V1
  module Request
    class AddCustomer
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.cookie_manager = nil
      end

      ##
      # Attributes
      #
      attr_accessor :token, :username, :firstname, :lastname, :is_test

      ##
      # Instance Methods
      #
      def initialize(token, username, firstname, lastname, is_test)
        @token = token
        @username = username
        @firstname = firstname
        @lastname = lastname
        @is_test = is_test
      end

      def add_customer
        request_url = is_test ? url_for_test : url
        http_client.post(request_url, body, headers)
      end

      def body
        customer = { 'username' => username }
        if (firstname && lastname).present?
          customer['firstName'] = firstname
          customer['lastName'] = lastname
        end
        customer.to_json(:root => 'customer')
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
          'active'
        )
      end

      def url_for_test
        ::URI.join(
          ::Finicity.config.base_url,
          'aggregation/',
          'v1/',
          'customers/',
          'testing'
        )
      end
    end
  end
end
