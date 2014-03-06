module Fog
  module Compute
    class BigV

      # delete_disc

      # Delete's a disc from a virtual machine.

      # params:
      #   disc_id
      #   vm_id
      #   group_id - defaults to the 'default' group.

      # Success returns a 204 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/discs/

      class Real

        def delete_disc(disc_id, vm_id, group_id='default')
          bigv_api_request(
            :expects  => [204],
            :method   => 'DELETE',
            :path     => "/accounts/#{@bigv_account}/groups/#{group_id}/virtual_machines/#{vm_id}/discs/#{disc_id}",
            :query    => { :purge => true }
          )
        end

      end

      class Mock

        def delete_disc(disc_id, vm_id, group_id='default')
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
