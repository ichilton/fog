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

        attr_accessor :root_password  # just used for creation


        def initialize(options = {})
          attributes[:group_id] =  options[:group_id] || 'default'
          attributes[:cores]    =  options[:cores]    || 1
          attributes[:memory]   =  options[:memory]   || 1024

          super
        end


        # Turn on:
        def start   
          requires :id, :group_id
          service.update_virtual_machine(id, group_id, { :autoreboot_on => true, :power_on => true })
          true
        end

        # Turn off:
        def stop    
          requires :id, :group_id
          service.update_virtual_machine( id, group_id, { :autoreboot_on => false, :power_on => false })
          true
        end

        # Hard reset:
        def reboot  
          requires :id, :group_id
          service.update_virtual_machine(id, group_id, { :autoreboot_on => true, :power_on => false })
          true
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
          if persisted?
            response = _update_server
          else
            response = _create_server
          end

          merge_attributes(response.body['virtual_machine'])
        end

        def destroy
          requires :id, :group_id
          service.delete_virtual_machine(id, group_id)
        end


        private

          def _create_server
            requires :name, :root_password

            options = attributes.merge( { :root_password => root_password } )
            service.create_server(options)
          end

          def _update_server
            # TODO
          end

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
