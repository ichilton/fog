module Fog
  module Compute
    class BigV

      # update_user

      # Updates an existing user.

      # params:
      #   user_id
      #   options - a hash containing the attributes to update:
      #     - username
      #     - email
      #     - authorized_keys
      #     - password

      # Success returns a 200 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/users/

      class Real

        def update_user(user_id, options = {})
          bigv_api_request(
            :expects  => [200],
            :method   => 'PUT',
            :path     => "users/#{user_id}",
            :body     => Fog::JSON.encode(options)
          )
        end

      end

      class Mock

        def update_user(user_id, options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
