module Fog
  module Compute
    class BigV

      # update_virtual_machine

      # Updates an existing virtual machine.

      # params:
      #   vm_id - the id of the virtual machine
      #   group_id - defaults to the 'default' group.

      #   options - a hash containing the attributes to update:
      #     - cores
      #     - memory (in megabytes)
      #     - cdrom_url
      #     - autoreboot_on
      #     - power_on
      #     - hardware_profile

      # Success returns a 200 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/virtual_machines/

      class Real

        def update_virtual_machine(vm_id, group_id='default', options = {})
          bigv_api_request(
            :expects  => [200],
            :method   => 'PUT',
            :path     => "accounts/#{@bigv_account}/groups/#{group_id}/virtual_machines/#{vm_id}",
            :body     => Fog::JSON.encode(options)
          )
        end

      end

      class Mock

        def update_virtual_machine(vm_id, group_id='default', options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
