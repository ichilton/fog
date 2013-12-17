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

      end

    end
  end
end
