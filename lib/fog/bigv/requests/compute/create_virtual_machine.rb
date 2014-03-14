module Fog
  module Compute
    class BigV

      # create_virtual_machine

      # Creates a new virtual machine. This only creates the machine itself though,
      # use the create_server request to include a disc and an operating system.

      # params:
      #   group_id (defaults to the 'default' group)
      #
      #   options - a hash containing:
      #     - name
      #     - cores
      #     - memory (in megabytes)
      #     - cdrom_url
      #     - autoreboot_on
      #     - power_on
      #     - hardware_profile

      # Success returns a 202 response, but the machine is created in the background.

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/virtual_machines/

      class Real
        def create_virtual_machine(group_id='default', options = {})
          bigv_api_request(
            :expects  => [202],
            :method   => 'POST',
            :path     => "accounts/#{@bigv_account}/groups/#{group_id}/virtual_machines",
            :body     => Fog::JSON.encode(options)
          )
        end
      end

      class Mock
        def create_virtual_machine(options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
