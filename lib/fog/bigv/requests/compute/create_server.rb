module Fog
  module Compute
    class BigV

      # create_server

      # Creates a new virtual machine, with discs and an operating system in a
      # single call.

      # (see the create_virtual_machine request to just create a bare virtual machine)

      # params:
      #   group_id (defaults to the 'default' group)

      #   options - a hash containing:
      #
      #     - virtual_machine - a hash containing:
      #       - name
      #       - cores
      #       - memory - in megabytes
      #       - cdrom_url
      #       - autoreboot_on
      #       - power_on
      #       - hardware_profile
      #
      #     - discs - an array containing hashes with the following:
      #       - label - defaults to sequential label of: vda, vdb, vdc etc...
      #       - storage-grade - sata/sas/ssd/archive - defaults to: sata
      #       - size - in megabytes - defualts to 20GB
      #       (see: http://bigv-api-docs.ichilton.co.uk/api/discs/)
      #
      #     - reimage - a hash continaing:
      #       - distribution - see: http://bigv-api-docs.ichilton.co.uk/api/definitions/
      #       - root_password - the root password to use for the new machine

      # Success returns a 202 response, but the machine is created in the background.

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/virtual_machines/

      class Real
        def create_server(group_id='default', options = {})
          bigv_api_request(
            :expects  => [202],
            :method   => 'POST',
            :path     => "accounts/#{@bigv_account}/groups/#{group_id}/vm_create",
            :body     => Fog::JSON.encode(options)
          )
        end
      end

      class Mock
        def create_server(options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
