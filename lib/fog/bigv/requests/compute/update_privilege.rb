module Fog
  module Compute
    class BigV

      # update_privilege

      # Updates an existing privilege.

      # params:
      #   privilege_id
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

        def update_privilege(privilege_id, options = {})
          bigv_api_request(
            :expects  => [200],
            :method   => 'PUT',
            :path     => "privileges/#{privilege_id}",
            :body     => Fog::JSON.encode(options)
          )
        end

      end

      class Mock

        def update_privilege(privilege_id, options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
