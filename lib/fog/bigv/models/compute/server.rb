require 'fog/compute/models/server'

module Fog
  module Compute
    class BigV

      # A BigV Virtual Machine

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


        def ready?
          power_on == true
        end


        def public_ip_address
          "1.2.3.4"
        end


        def start
          requires :id
        end


        def stop
          requires :id
        end


        def reboot
          requires :id
        end


        def save

        end


        def update

        end

        def destroy
          requires :id
        end

      end

    end
  end
end
