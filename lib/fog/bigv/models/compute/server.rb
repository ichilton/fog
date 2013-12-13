require 'fog/compute/models/server'

module Fog
  module Compute
    class BigV

      # Server Model

      # Models a BigV virtual machine
      # http://bigv-api-docs.ichilton.co.uk/api/virtual_machines/

      class Server < Fog::Compute::Server

        identity  :id

        attribute :group_id

        attribute :name
        attribute :hostname

        attribute :cores
        attribute :memory

        attribute :autoreboot_on
        attribute :power_on

        attribute :management_address
        attribute :cdrom_url

        attribute :head
        attribute :hardware_profile
        attribute :hardware_profile_locked


        # Control:
        def start
          requires :id

        end

        def stop
          requires :id
        end

        def reboot
          requires :id
        end


        # Status:
        def ready?
          power_on == true
        end


        # IP's:
        def ipv4_address
          _match_ip_address(_primary_ip_addresses, /(?:\d{1,3}\.){3}\d{1,3}/)
        end

        def ipv6_address
          _match_ip_address(_primary_ip_addresses, /^[a-z0-9\:]+$/)
        end

        def public_ip_address
          ipv4_address
        end

        def ip_addresses
          attributes['network_interfaces'].map{ |n| n['ips'] }.flatten
        end


        # CRUD:
        def save

        end

        def update

        end

        def destroy
          requires :id, :group_id
          service.delete_virtual_machine(id, group_id)
        end


        private

          def _primary_ip_addresses
            if attributes['network_interfaces'] && attributes['network_interfaces'].count > 0
              attributes['network_interfaces'].first['ips']
            end
          end

          def _match_ip_address(ip_addresses, regex)
            matching_ips = ip_addresses.select { |ip| ip =~ regex }
            matching_ips.first if matching_ips.count > 0
          end

      end

    end
  end
end
