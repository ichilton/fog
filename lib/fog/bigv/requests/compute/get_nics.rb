module Fog
  module Compute
    class BigV

      # get_nics

      # Get's all nics (network interfaces) for a virtual machine

      # params:
      #   vm_id - the id of the virtual machine
      #   group_id - defaults to the 'default' group.

      # Success returns a 200 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/nics/

      class Real
        def get_nics(vm_id, group_id='default')
          bigv_api_request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "accounts/#{@bigv_account}/groups/#{group_id}/virtual_machines/#{vm_id}/nics"
          )
        end
      end

      class Mock
        def get_nics(vm_id, group_id='default')
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
