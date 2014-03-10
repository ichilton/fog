require 'fog/core/collection'
require 'fog/bigv/models/compute/account'

module Fog
  module Compute
    class BigV

      # Accounts Collection

      # Collection of BigV accounts
      # http://bigv-api-docs.ichilton.co.uk/api/accounts/

      class Accounts < Fog::Collection

        model Fog::Compute::BigV::Account


        def all()
          load(service.get_accounts.body)
        end


        def get(id)
          new(service.get_account(id).body)

          rescue Fog::Errors::NotFound
            nil
        end

      end

    end
  end
end
