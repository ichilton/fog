module Fog
  module Compute
    class BigV

    # get_accounts

    # Get all accounts.

    # more information, see: http://bigv-api-docs.ichilton.co.uk/api/accounts/

      class Real
        def get_accounts
          bigv_api_request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "accounts"
          )
        end
      end

      class Mock
        def get_accounts
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
