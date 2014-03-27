module Fog
  module Compute
    class BigV

      # create_user

      # Creates a new user.

      #   options - a hash containing the attributes:
      #     - username
      #     - email
      #     - authorized_keys
      #     - password

      # Success returns a 200 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/users/

      class Real
        def create_user(options)
          bigv_api_request(
            :expects  => [200],
            :method   => 'POST',
            :path     => "users",
            :body     => Fog::JSON.encode(options)
          )
        end
      end

      class Mock
        def create_user(options)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
