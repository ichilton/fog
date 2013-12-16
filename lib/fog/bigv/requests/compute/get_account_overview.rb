module Fog
  module Compute
    class BigV

    # get_account_overview

    # Returns the account, but with an overview parameter which causes
    # virtual machine data with nested disc and nic data to be included.
    # more information: http://bigv-api-docs.ichilton.co.uk/api/accounts/

      class Real

        def get_account_overview(include_deleted=false)
          params = { :view => 'overview' }
          params[:include_deleted] = true if include_deleted

          bigv_api_request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "accounts/#{@bigv_account}",
            :query    => params
          )
        end

      end

      class Mock

        def get_account_overview
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
