module Fog
  module Compute
    class BigV

      # update_ip

      # Updates an existing IP address.

      # params:
      #   ip_address
      #   options - a hash containing:
      #     - rdns

      # Success returns a 200 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/ips/

      class Real

        def update_ip(ip_address, options = {})
          bigv_api_request(
            :expects  => [200],
            :method   => 'PUT',
            :path     => "ips/#{ip_address}",
            :body     => Fog::JSON.encode(options)
          )
        end

      end

      class Mock

        def update_ip(ip_address, options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
