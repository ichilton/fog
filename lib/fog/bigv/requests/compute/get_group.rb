module Fog
  module Compute
    class BigV

      # get_group

      # Get a specific group by it's ID

      # params:
      #   - group_id

      # Success returns a 200 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/groups/

      class Real

        def get_group(group_id)
          bigv_api_request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "accounts/#{@bigv_account}/groups/#{group_id}"
          )
        end

      end

      class Mock

        def get_group(group_id)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
