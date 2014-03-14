require 'fog/core/collection'
require 'fog/bigv/models/compute/ip'

module Fog
  module Compute
    class BigV

      # Ips Collection

      # Collection of BigV IP Addresses
      # http://bigv-api-docs.ichilton.co.uk/api/ips/

      class Ips < Fog::Collection

        model Fog::Compute::BigV::Ip

        def get(ip_address)
          new(service.get_ip(ip_address).body)

          rescue Fog::Errors::NotFound
            nil
        end

      end

    end
  end
end
