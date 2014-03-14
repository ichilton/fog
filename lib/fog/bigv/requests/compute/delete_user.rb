module Fog
  module Compute
    class BigV

      # delete_user

      # Delete's a user.

      # params:
      #   user_id

      # Success returns a 204 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/users/

      class Real
        def delete_user(user_id)
          bigv_api_request(
            :expects  => [204],
            :method   => 'DELETE',
            :path     => "users/#{user_id}",
          )
        end
      end

      class Mock
        def delete_user(user_id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
