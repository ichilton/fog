module Fog
  module Compute
    class BigV

      # get_groups

      # Get's all groups in the account

      # Success returns a 200 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/groups/

      class Real

        def get_groups
          bigv_api_request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "/accounts/#{@bigv_account}/groups"
          )
        end

      end

      class Mock

        def get_groups
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
