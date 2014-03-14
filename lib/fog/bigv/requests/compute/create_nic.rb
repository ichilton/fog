module Fog
  module Compute
    class BigV

      # create_nic

      # Creates a network interface.

      # NOTE: This is currently disabled on the API, but here for future compatibility.

      # params:
      #   vm_id
      #   group_id (defaults to the 'default' group)
      #
      #   options - a hash containing:
      #     - label

      # Success returns a 200 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/nics/

      class Real
        def create_nic(vm_id, group_id='default', options = {})
          bigv_api_request(
            :expects  => [200],
            :method   => 'POST',
            :path     => "accounts/#{@bigv_account}/groups/#{group_id}/virtual_machines/#{vm_id}/nics",
            :body     => Fog::JSON.encode(options)
          )
        end
      end

      class Mock
        def create_nic(vm_id, group_id='default', options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
