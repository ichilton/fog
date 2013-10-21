require 'fog/bigv'
require 'fog/compute'

module Fog
  module Compute
    class BigV < Fog::Service

      requires     :bigv_account
      requires     :bigv_username
      requires     :bigv_password

      recognizes   :bigv_yubikey
      recognizes   :bigv_api_url

      model_path   'fog/bigv/models/compute'
      model        :server
      collection   :servers
      
      request_path 'fog/bigv/requests/compute'
      request      :account_overview

      class Mock

      end


      class Real

        def initialize(options={})
          @bigv_account = options[:bigv_account]
          @bigv_username = options[:bigv_username]
          @bigv_password = options[:bigv_password]

          @bigv_yubikey = options[:bigv_yubikey] if options[:bigv_yubikey]
          @bigv_api_url = options[:bigv_api_url] || 'https://uk0.bigv.io'

          Excon.defaults[:ssl_verify_peer] = false
          @connection = Fog::Connection.new(@bigv_api_url, false, {:ssl_verify_peer => false})
        end

        def reload
          @connection.reset
        end

        def bigv_api_request(params)
          auth_string = Base64.encode64("#{@bigv_username}:#{@bigv_password}").strip

          params[:headers] ||= {}
          params[:headers].merge!('Authorization' => "Basic #{auth_string}")
          params[:headers].merge!('X-Yubikey-Otp' => @bigv_yubikey) if @bigv_yubikey

          parse_response_body @connection.request(params)
        end


        private

        def parse_response_body(response)
          return response if response.body.empty?
          response.body = Fog::JSON.decode(response.body)
          response
        end

      end
    end
  end
end
