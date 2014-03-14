module Fog
  module Compute
    class BigV

      # get_ip

      # Get a specified IP address.

      # params:
      #   ip_address

      # Success returns a 200 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/ips/

      class Real
        def get_ip(ip_address)
          bigv_api_request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "ips/#{ip_address}"
          )
        end
      end

      class Mock
        def get_ip(ip_address)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
