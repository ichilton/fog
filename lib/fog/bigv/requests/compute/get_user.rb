module Fog
  module Compute
    class BigV

    # get_user

    # Get a specific user by it's id.

    # more information, see: http://bigv-api-docs.ichilton.co.uk/api/users/

      class Real
        def get_user(user_id)
          bigv_api_request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "users/#{user_id}"
          )
        end
      end

      class Mock
        def get_user(user_id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
