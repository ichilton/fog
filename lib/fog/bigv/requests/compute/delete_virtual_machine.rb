module Fog
  module Compute
    class BigV

      # delete_virtual_machine

      # Delete's a virtual machine.

      # params:
      #   vm_id - the id of the virtual machine
      #   group_id - defaults to the 'default' group.

      # Success returns a 204 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/virtual_machines/

      class Real

        def delete_virtual_machine(vm_id, group_id='default')
          bigv_api_request(
            :expects  => [204],
            :method   => 'DELETE',
            :path     => "/accounts/#{@bigv_account}/groups/#{group_id}/virtual_machines/#{vm_id}",
          )
        end

      end

      class Mock

        def delete_virtual_machine(vm_id, group_id='default')
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
