module Fog
  module Compute
    class BigV

      # get_virtual_machines

      # Get all virtual machines in a group

      # params:
      #   group_id (defaults to the 'default' group)

      # Success returns a 200 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/virtual_machines/

      class Real
        def get_virtual_machines(group_id='default')
          bigv_api_request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "accounts/#{@bigv_account}/groups/#{group_id}/virtual_machines"
          )
        end
      end

      class Mock
        def get_virtual_machines(group_id='default')
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
