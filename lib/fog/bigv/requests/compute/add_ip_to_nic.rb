module Fog
  module Compute
    class BigV

      # add_ip_to_nic

      # Adds a new IP address to a network interface.

      # params:
      #   nic_id
      #   vm_id
      #   group_id (defaults to the 'default' group)

      # Success returns a 200 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/nics/

      class Real

        def add_ip_to_nic(nic_id, vm_id, group_id='default')
          bigv_api_request(
            :expects  => [200],
            :method   => 'POST',
            :path     => "accounts/#{@bigv_account}/groups/#{group_id}/virtual_machines/#{vm_id}/nics/#{nic_id}/ip_create"
          )
        end

      end

      class Mock

        def add_ip_to_nic(nic_id, vm_id, group_id='default')
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
