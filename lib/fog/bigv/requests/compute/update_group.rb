module Fog
  module Compute
    class BigV

      # update_group

      # Updates an existing group.

      # params:
      #   group_id
      #   options - a hash containing the attributes to update:
      #     - name

      # Success returns a 200 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/groups/

      class Real

        def update_group(group_id, options = {})
          bigv_api_request(
            :expects  => [200],
            :method   => 'PUT',
            :path     => "accounts/#{@bigv_account}/groups/#{group_id}",
            :body     => Fog::JSON.encode(options)
          )
        end

      end

      class Mock

        def update_group(group_id, options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
