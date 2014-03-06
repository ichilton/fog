module Fog
  module Compute
    class BigV

      # get_disc

      # Get a specified disc for a virtual machine

      # params:
      #   disc_id
      #   vm_id
      #   group_id - defaults to the 'default' group.

      # Success returns a 200 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/discs/

      class Real

        def get_disc(disc_id, vm_id, group_id='default')
          bigv_api_request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "accounts/#{@bigv_account}/groups/#{group_id}/virtual_machines/#{vm_id}/discs/#{disc_id}"
          )
        end

      end

      class Mock

        def get_disc(nic_id, vm_id, group_id='default')
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
