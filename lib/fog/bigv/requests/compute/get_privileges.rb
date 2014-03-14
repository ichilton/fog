module Fog
  module Compute
    class BigV

    # get_privileges

    # Get all privileges.

    # more information, see: http://bigv-api-docs.ichilton.co.uk/api/privileges/

      class Real
        def get_privileges
          bigv_api_request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "privileges"
          )
        end
      end

      class Mock
        def get_privileges
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
