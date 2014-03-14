module Fog
  module Compute
    class BigV

      # create_user_privilege

      # Creates a new privilege for a user.

      #   user_id
      #   options - a hash containing the attributes to update:
      #     - username
      #     - level (account_admin, group_admin, vm_admin etc)
      #     - creating_username
      #     - yubikey_required
      #     - yubikey_otp_max_age
      #     - ip_restrictions
      #     - one of:
      #       - virtual_machine_id
      #       - group_id
      #       - account_id

      # Success returns a 200 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/privileges/

      class Real
        def create_user_privilege(user_id, options = {})
          bigv_api_request(
            :expects  => [200],
            :method   => 'POST',
            :path     => "users/#{user_id}/privileges",
            :body     => Fog::JSON.encode(options)
          )
        end
      end

      class Mock
        def create_user_privilege(user_id, options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
