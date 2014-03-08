require 'fog/core/model'

module Fog
  module Compute
    class BigV

      # Nic Model

      # Models a BigV nic (network interface)
      # http://bigv-api-docs.ichilton.co.uk/api/nics/

      class Nic < Fog::Model

        identity :id

        attribute :server_id, :aliases => 'virtual_machine_id'
        attribute :group_id

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


        def save
          if persisted?
            response = _update
          else
            response = _create
          end

          merge_attributes(response.body)
          collection.reload
        end


        def destroy
          requires :id, :server_id, :group_id
          service.delete_nic(id, server_id, group_id)
          collection.reload
          true
        end


        def add_new_ip_address
          requires :id, :server_id, :group_id
          service.add_ip_to_nic(id, server_id, group_id)
          collection.reload
          true
        end

        private

        def _create
          requires :server_id, :group_id
          service.create_nic(server_id, group_id, attributes)
        end

        def _update
          requires :id, :server_id, :group_id
          service.update_nic(id, server_id, group_id, attributes)
        end

        def _match_ips(regex)
          ips.select { |ip| ip =~ regex }
        end

      end

    end
  end
end
