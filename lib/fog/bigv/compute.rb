require 'fog/bigv'
require 'fog/compute'

# Fog provider for Bytemark's BigV service.
# http://www.bigv.io

# Developed/maintained on behalf of Bytemark by:
#   Ian Chilton
#   Email:   ian@ichilton.co.uk
#   Web:     http://www.ichilton.co.uk
#   Github:  http://github.com/ichilton
#   Twitter: @ichilton

# API: http://bigv-api-docs.ichilton.co.uk

module Fog
  module Compute
    class BigV < Fog::Service

      requires     :bigv_account
      requires     :bigv_username
      requires     :bigv_password

      recognizes   :bigv_yubikey
      recognizes   :bigv_api_url

      model_path   'fog/bigv/models/compute'
      model        :disc
      collection   :discs
      model        :group
      collection   :groups
      model        :nic
      collection   :nics
      model        :server
      collection   :servers

      request_path 'fog/bigv/requests/compute'
      request      :get_account_overview

      request      :get_definitions

      request      :get_discs

      request      :get_groups
      request      :get_group
      request      :create_group
      request      :update_group
      request      :delete_group

      request      :get_nics
      request      :get_nic
      request      :create_nic
      request      :update_nic
      request      :delete_nic

      request      :get_users
      request      :get_user
      request      :create_user
      request      :update_user
      request      :delete_user

      request      :get_virtual_machines
      request      :get_virtual_machine
      request      :create_virtual_machine
      request      :update_virtual_machine
      request      :delete_virtual_machine
      request      :create_server
      request      :reimage_virtual_machine


      IPV4_ADDRESS = /(?:\d{1,3}\.){3}\d{1,3}/
      IPV6_ADDRESS = /^[a-z0-9\:]+$/


      class Real

        def initialize(options={})
          @bigv_account  = options[:bigv_account]
          @bigv_username = options[:bigv_username]
          @bigv_password = options[:bigv_password]

          @bigv_yubikey = options[:bigv_yubikey] if options[:bigv_yubikey]
          @bigv_api_url = options[:bigv_api_url] || 'https://uk0.bigv.io'

          @connection = Fog::Connection.new( @bigv_api_url, false, {:ssl_verify_peer => false} )
        end

        def reload
          @connection.reset
        end

        def bigv_api_request(params)
          auth_string = Base64.encode64("#{@bigv_username}:#{@bigv_password}").strip

          params[:headers] ||= {}
          params[:headers].merge!('Content-Type' => 'application/json')
          params[:headers].merge!('Authorization' => "Basic #{auth_string}")
          params[:headers].merge!('X-Yubikey-Otp' => @bigv_yubikey) if @bigv_yubikey

          _parse_response_body @connection.request(params)
        end


        private

        def _parse_response_body(response)
          return response if response.body.empty?
          response.body = Fog::JSON.decode(response.body)
          response
        end

      end


      class Mock
        # TODO
      end

    end
  end
end
