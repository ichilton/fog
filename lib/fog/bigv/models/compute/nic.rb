require 'fog/compute/models/server'

module Fog
  module Compute
    class BigV

      # Nic Model

      # Models a BigV nic (network interface)
      # http://bigv-api-docs.ichilton.co.uk/api/nics/

      class Nic < Fog::Model

        identity :id

        attribute :server_id, :aliases => 'virtual_machine_id'

        attribute :label
        attribute :ips
        attribute :vlan_num
        attribute :mac
        attribute :extra_ips


        def ip_addresses
          ips
        end

        def ipv4_addresses
          _match_ips(IPV4_ADDRESS)
        end

        def ipv6_addresses
          _match_ips(IPV6_ADDRESS)
        end


        private

        def _match_ips(regex)
          ips.select { |ip| ip =~ regex }
        end

      end

    end
  end
end
