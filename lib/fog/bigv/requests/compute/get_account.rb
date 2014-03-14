module Fog
  module Compute
    class BigV

    # get_account

    # Get a specific account by it's id.

    # more information, see: http://bigv-api-docs.ichilton.co.uk/api/accounts/

      class Real
        def get_account(account_id)
          bigv_api_request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "accounts/#{account_id}"
          )
        end
      end

      class Mock
        def get_account(account_id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
