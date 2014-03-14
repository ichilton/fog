module Fog
  module Compute
    class BigV

    # get_privilege

    # Get a specific privilege by it's id.

    # more information, see: http://bigv-api-docs.ichilton.co.uk/api/privileges/

      class Real
        def get_privilege(privilege_id)
          bigv_api_request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "privileges/#{privilege_id}"
          )
        end
      end

      class Mock
        def get_privilege(privilege_id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
