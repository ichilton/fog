module Fog
  module Compute
    class BigV

      # privilege

      # Creates a new privilege.

      #   options - a hash containing the attributes to update:
      #     - username
      #     - level (account_admin, group_admin, vm_admin etc)
      #     - creating_username
      #     - yubikey_required
      #     - yubikey_otp_max_age
      #     - ip_restrictions

      # Success returns a 200 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/privileges/

      class Real
        def create_privilege(options = {})
          bigv_api_request(
            :expects  => [200],
            :method   => 'POST',
            :path     => "privileges",
            :body     => Fog::JSON.encode(options)
          )
        end
      end

      class Mock
        def create_privilege(options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
