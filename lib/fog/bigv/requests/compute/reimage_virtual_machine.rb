module Fog
  module Compute
    class BigV

      # reimage_virtual_machine

      # Re-image's an existing virtual machine
      # (all data will be lost and the VM will be restored with a clean image)

      # params:
      #   vm_id - the id of the virtual machine
      #   group_id - defaults to the 'default' group.

      #   options - a hash containing:
      #     - distribution - the image to use - from the definitions call (eg: precise)
      #     - root_password - the root password to set after re-imaging.

      # Success returns a 200 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/virtual_machines/
      # and: http://bigv-api-docs.ichilton.co.uk/api/definitions/

      class Real
        def reimage_virtual_machine(vm_id, group_id='default', options = {})
          bigv_api_request(
            :expects  => [200],
            :method   => 'POST',
            :path     => "accounts/#{@bigv_account}/groups/#{group_id}/virtual_machines/#{vm_id}/reimage",
            :body     => Fog::JSON.encode(options)
          )
        end
      end

      class Mock
        def reimage_virtual_machine(vm_id, group_id='default', options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
