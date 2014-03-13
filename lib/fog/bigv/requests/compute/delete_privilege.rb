module Fog
  module Compute
    class BigV

      # delete_privilege

      # Delete's a privilege.

      # params:
      #   privilege_id

      # Success returns a 204 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/privileges/

      class Real

        def delete_privilege(privilege_id)
          bigv_api_request(
            :expects  => [200],
            :method   => 'DELETE',
            :path     => "privileges/#{privilege_id}",
          )
        end

      end

      class Mock

        def delete_privilege(privilege_id)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
