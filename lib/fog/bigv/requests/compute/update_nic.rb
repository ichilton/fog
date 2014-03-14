module Fog
  module Compute
    class BigV

      # update_nic

      # Updates an existing network interface on a virtual machine

      # NOTE: This is currently disabled on the API, but here for future compatibility.

      # params:
      #   nic_id
      #   vm_id
      #   group_id (defaults to the 'default' group)
      #
      #   options - a hash containing:
      #     - label

      # Success returns a 200 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/nics/

      class Real
        def update_nic(nic_id, vm_id, group_id='default', options = {})
          bigv_api_request(
            :expects  => [200],
            :method   => 'PUT',
            :path     => "accounts/#{@bigv_account}/groups/#{group_id}/virtual_machines/nics/#{nic_id}",
            :body     => Fog::JSON.encode(options)
          )
        end
      end

      class Mock
        def update_nic(nic_id, vm_id, group_id='default', options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
