module Fog
  module Compute
    class BigV

      # update_account

      # Updates an existing account.

      # params:
      #   account_id
      #   options - a hash containing the attributes to update:
      #     - name

      # Success returns a 200 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/accounts/

      class Real

        def update_account(account_id, options = {})
          bigv_api_request(
            :expects  => [200],
            :method   => 'PUT',
            :path     => "accounts/#{account_id}",
            :body     => Fog::JSON.encode(options)
          )
        end

      end

      class Mock

        def update_account(account_id, options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
