module Fog
  module Compute
    class BigV

      # signal_virtual_machine

      # Send a signal to an existing virtual machine

      # params:
      #   vm_id - the id of the virtual machine
      #   group_id - defaults to the 'default' group.

      #   options - a hash containing:
      #     - signal - the signal to send, which can be: powerdown, reset or sendkey
      #     - data - only used if the signal is sendkey.
      #              (A dash-separated list of keys to press, eg: ‘a-b-c-ctrl-alt-del’)

      # Success returns a 200 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/virtual_machines/
      # and: http://bigv-api-docs.ichilton.co.uk/api/definitions/

      class Real
        def signal_virtual_machine(vm_id, group_id='default', options = {})
          bigv_api_request(
            :expects  => [200],
            :method   => 'POST',
            :path     => "accounts/#{@bigv_account}/groups/#{group_id}/virtual_machines/#{vm_id}/signal",
            :body     => Fog::JSON.encode(options)
          )
        end
      end

      class Mock
        def signal_virtual_machine(vm_id, group_id='default', options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
