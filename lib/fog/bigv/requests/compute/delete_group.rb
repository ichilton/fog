module Fog
  module Compute
    class BigV

      # delete_group

      # Delete's a group.

      # params:
      #   group_id

      # Success returns a 204 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/groups/

      class Real
        def delete_group(group_id)
          bigv_api_request(
            :expects  => [204],
            :method   => 'DELETE',
            :path     => "accounts/#{@bigv_account}/groups/#{group_id}",
          )
        end
      end

      class Mock
        def delete_group(group_id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
