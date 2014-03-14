module Fog
  module Compute
    class BigV

    # get_user_privileges

    # Get all privileges for a specific user.

    # more information, see: http://bigv-api-docs.ichilton.co.uk/api/privileges/

      class Real
        def get_user_privileges(user_id)
          bigv_api_request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "users/#{user_id}/privileges"
          )
        end
      end

      class Mock
        def get_user_privileges(user_id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
