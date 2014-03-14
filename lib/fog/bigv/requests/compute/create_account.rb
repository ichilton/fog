module Fog
  module Compute
    class BigV

      # create_account

      # Creates a new account.

      #   options - a hash containing the attributes:
      #     - name

      # Success returns a 200 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/accounts/

      class Real
        def create_account(options = {})
          bigv_api_request(
            :expects  => [200],
            :method   => 'POST',
            :path     => "accounts",
            :body     => Fog::JSON.encode(options)
          )
        end
      end

      class Mock
        def create_account(options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
