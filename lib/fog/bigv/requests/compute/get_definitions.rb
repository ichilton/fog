module Fog
  module Compute
    class BigV

    # get_definitions

    # Get misc information about the platform.

    # more information: http://bigv-api-docs.ichilton.co.uk/api/definitions/

      class Real

        def get_definitions
          bigv_api_request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "definitions",
          )
        end

      end

      class Mock

        def get_definitions
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
