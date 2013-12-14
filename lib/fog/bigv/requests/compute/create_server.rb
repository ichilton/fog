module Fog
  module Compute
    class BigV

      # create_server

      # Creates a new virtual machine, with discs and an operating system in a
      # single call.

      # (see the create_virtual_machine request to just create a bare virtual machine)

      # params:
      #   options - a hash containing:
      #     - group_id (defaults to the 'default' group)
      #     - name
      #     - root_password
      #     - cores
      #     - memory - in megabytes
      #     - cdrom_url
      #     - autoreboot_on
      #     - power_on
      #     - hardware_profile

      #     - distribution - see: http://bigv-api-docs.ichilton.co.uk/api/definitions/

      #     - discs - an array containing an hashes with the following:
      #       - label - defaults to sequential label of: vda, vdb, vdc etc...
      #       - storage-grade - sata/sas/ssd/archive - defaults to: sata
      #       - size - in megabytes - defualts to 20GB
      #       (see: http://bigv-api-docs.ichilton.co.uk/api/discs/)

      # Success returns a 202 response, but the machine is created in the background.

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/virtual_machines/

      # Currently, options can be empty and sane default will be used, but i'll
      # probably move the default into the model to keep things DRY.

      class Real

        def create_server(group_id='default', options = {})
          bigv_api_request(
            :expects  => [202],
            :method   => 'POST',
            :path     => "/accounts/#{@bigv_account}/groups/#{group_id}/vm_create",
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
