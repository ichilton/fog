module Fog
  module Compute
    class BigV

    # get_users

    # Get all users.

    # more information, see: http://bigv-api-docs.ichilton.co.uk/api/users/

      class Real

        def get_users
          bigv_api_request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "users"
          )
        end

      end

      class Mock

        def get_users
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
