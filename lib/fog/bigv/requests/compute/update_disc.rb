module Fog
  module Compute
    class BigV

      # update_disc

      # Updates an existing disc on a virtual machine.

      # params:
      #   disc_id
      #   vm_id
      #   group_id (defaults to the 'default' group)
      #
      #   options - a hash containing:
      #     - label
      #     - size in bytes
      #     - storage_grade (sata, sas, ssd or archive)

      # Success returns a 200 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/discs/

      class Real

        def update_disc(disc_id, vm_id, group_id='default', options = {})
          bigv_api_request(
            :expects  => [200],
            :method   => 'PUT',
            :path     => "accounts/#{@bigv_account}/groups/#{group_id}/virtual_machines/discs/#{disc_id}",
            :body     => Fog::JSON.encode(options)
          )
        end

      end

      class Mock

        def update_disc(disc_id, vm_id, group_id='default', options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
