module Fog
  module Compute
    class BigV

      # delete_account

      # Delete's a account.

      # params:
      #   account_id

      # Success returns a 204 response

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/accounts/

      class Real

        def delete_account(account_id)
          bigv_api_request(
            :expects  => [204],
            :method   => 'DELETE',
            :path     => "accounts/#{account_id}",
          )
        end

      end

      class Mock

        def delete_account(account_id)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
