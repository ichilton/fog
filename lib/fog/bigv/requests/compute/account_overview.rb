module Fog
  module Compute
    class BigV 
      class Real

        def account_overview(options = {})
          bigv_api_request(
            :expects  => [200],
            :method   => 'GET', 
            :path     => "accounts/#{@bigv_account}",
            :query    => {:view => 'overview'}
          )
        end

      end

      class Mock

        def account_overview
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
