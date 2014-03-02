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

        attribute :deleted


        # Just used for creation:
        attr_accessor :root_password
        attr_accessor :distribution
        attr_accessor :initial_discs

        VALID_ATTRIBUTES = [
                              :name,
                              :cores,
                              :memory,
                              :cdrom_url,
                              :autoreboot_on,
                              :power_on,
                              :hardware_profile
                            ]

        DEFAULT_DISC = { :label => 'vda', :storage_grade => 'sata', :size => 20480 }

        DEFAULT_DISTRIBUTION = 'precise'


        def initialize(options = {})
          attributes[:group_id] =  options[:group_id] || 'default'
          attributes[:cores]    =  options[:cores]    || 1
          attributes[:memory]   =  options[:memory]   || 1024

          # default to powered on, unless specifically set to false:
          attributes[:autoreboot_on] = options[:autoreboot_on] == false ? false : true
          attributes[:power_on] = options[:power_on] == false ? false : true

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

        # Restart (this will turn off the VM and let the BigV brain turn it back on again):
        def restart  
          requires :id, :group_id
          service.update_virtual_machine(id, group_id, { :autoreboot_on => true, :power_on => false })
          true
        end

        # This will send an ACPI powerdown signal to the machine which should cause
        # it to initiate a clean shutdown - the equivalent of pressing a soft power
        # button on a PC. Note that if the autoreboot_on attribute is set to true,
        # the BigV brain will power the machine on again when it detects it hsa
        # turned off.
        def shutdown
          requires :id, :group_id
          service.signal_virtual_machine(id, group_id, { :signal => 'powerdown' })
          true
        end

        # This will send an ACPI reset signal to the machine which is equivalent to
        # pressing the reset button. The virtual machine will reset, but will
        # continue to use the same process on the host, so things like size changes
        # will not take effect like they will with the above methods.
        def reset
          requires :id, :group_id
          service.signal_virtual_machine(id, group_id, { :signal => 'reset' })
          true
        end

        # Send a key press
        # The data parameter should contain a dash-separated list of keys to press,
        # eg: ‘ctrl-alt-del’
        def sendkey(data)
          requires :id, :group_id
          service.signal_virtual_machine(id, group_id, { :signal => 'sendkey', :data => data })
          true
        end


        # Status:
        def ready?
          power_on == true
        end


        # IP's:
        def ipv4_address
          nics.primary.ipv4_addresses.first
        end

        def ipv6_address
          nics.primary.ipv6_addresses.first
        end

        def public_ip_address
          ipv4_address
        end

        def ip_addresses
          nics.map { |n| n.ips }.flatten
        end

        def ipv4_addresses
          _match_ips(ip_addresses, IPV4_ADDRESS)
        end

        def ipv6_addresses
          _match_ips(ip_addresses, IPV6_ADDRESS)
        end


        # CRUD:
        def save
          if persisted?
            _update_server
          else
            _create_server
          end
        end

        def destroy
          requires :id, :group_id
          service.delete_virtual_machine(id, group_id)
          true
        end

        def undelete
          requires :id, :group_id
          service.update_virtual_machine(id, group_id, { :deleted => false } )
          true
        end

        def purge
          requires :id, :group_id
          service.delete_virtual_machine(id, group_id, 'yes')
          true
        end


        # Re-image:
        def reimage(options = {})
          requires :id, :group_id
          service.reimage_virtual_machine(id, group_id, options)
          true
        end


        # Peripherals:
        def discs
          @discs ||= Fog::Compute::BigV::Discs.new({
                       :service => service,
                       :server => self
                     })
        end

        def discs?
          not discs.empty?
        end


        def nics
          @nics ||= Fog::Compute::BigV::Nics.new({
                      :service => service,
                      :server => self
                    })
        end

        def nics?
          not nics.empty?
        end


        private

          def _match_ips(ips, regex)
            ips.select { |ip| ip =~ regex }
          end

          def _virtual_machine_params
            attributes.select { |a| VALID_ATTRIBUTES.include?(a) && !attributes[a].nil? }
          end

          def _initial_discs
            initial_discs.kind_of?(Array) ? initial_discs : [ DEFAULT_DISC ]
          end

          def _create_server_params
            {
              :virtual_machine  => _virtual_machine_params,
              :discs            => _initial_discs,
              :reimage => {
                :distribution   => distribution || DEFAULT_DISTRIBUTION,
                :root_password  => root_password
              }
            }
          end

          def _create_server
            requires :group_id, :name, :root_password

            response = service.create_server(group_id, _create_server_params)
            merge_attributes(response.body['virtual_machine'])
          end

          def _update_server
            requires :id, :group_id

            response = service.update_virtual_machine(id, group_id, _virtual_machine_params)
            merge_attributes(response.body)
          end

      end

    end
  end
end
