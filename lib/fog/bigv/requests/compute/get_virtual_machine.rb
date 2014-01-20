module Fog
  module Compute
    class BigV

      # get_virtual_machine

      # Get a specified virtual machine

      # params:
      #   vm_id
      #   group_id (defaults to the 'default' group)

      # Success returns a 200 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/virtual_machines/

      class Real

        def get_virtual_machine(vm_id, group_id='default')
          bigv_api_request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "accounts/#{@bigv_account}/groups/#{group_id}/virtual_machines/#{vm_id}"
          )
        end

      end

      class Mock

        def get_virtual_machine(vm_id, group_id='default')
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
