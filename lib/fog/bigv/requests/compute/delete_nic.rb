module Fog
  module Compute
    class BigV

      # delete_nic

      # Delete's a network interface from a virtual machine.

      # NOTE: This is currently disabled on the API, but here for future compatibility.

      # params:
      #   nic_id
      #   vm_id
      #   group_id - defaults to the 'default' group.

      # Success returns a 204 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/nics/

      class Real
        def delete_nic(nic_id, vm_id, group_id='default')
          bigv_api_request(
            :expects  => [204],
            :method   => 'DELETE',
            :path     => "/accounts/#{@bigv_account}/groups/#{group_id}/virtual_machines/#{vm_id}/nics/#{nic_id}",
          )
        end
      end

      class Mock
        def delete_nic(nic_id, vm_id, group_id='default')
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
