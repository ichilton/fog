module Fog
  module Compute
    class BigV

      # create_disc

      # Creates a new disc.

      # params:
      #   vm_id
      #   group_id (defaults to the 'default' group)
      #
      #   options - a hash containing:
      #     - label
      #     - size (in bytes)
      #     - storage_grade (sata, sas, ssd or archive)

      # Success returns a 200 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/discs/

      class Real
        def create_disc(vm_id, group_id='default', options = {})
          bigv_api_request(
            :expects  => [200],
            :method   => 'POST',
            :path     => "accounts/#{@bigv_account}/groups/#{group_id}/virtual_machines/#{vm_id}/discs",
            :body     => Fog::JSON.encode(options)
          )
        end 
      end

      class Mock
        def create_disc(vm_id, group_id='default', options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
