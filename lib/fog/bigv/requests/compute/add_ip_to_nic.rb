module Fog
  module Compute
    class BigV

      # add_ip_to_nic

      # Adds a new IP address to a network interface.

      # params:
      #   nic_id
      #   vm_id
      #   group_id (defaults to the 'default' group)
      #   options - a hash containing:
      #     - addresses - how many addresses are being requested
      #     - contiguous - is a block needed or is non-contiguous allocation ok? (not currently implemented)
      #     - family - ipv4 or ipv6?
      #     - reason - description of why the user requires this allocation

      # Success returns a 200 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/nics/

      class Real

        def add_ip_to_nic(nic_id, vm_id, group_id='default', options)
          bigv_api_request(
            :expects  => [200],
            :method   => 'POST',
            :path     => "accounts/#{@bigv_account}/groups/#{group_id}/virtual_machines/#{vm_id}/nics/#{nic_id}/ip_create",
            :body     => Fog::JSON.encode(options)
          )
        end

      end

      class Mock

        def add_ip_to_nic(nic_id, vm_id, group_id='default', options)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
