require 'fog/core/collection'
require 'fog/bigv/models/compute/user'

module Fog
  module Compute
    class BigV

      # Users Collection

      # Collection of BigV users
      # http://bigv-api-docs.ichilton.co.uk/api/users/

      class Users < Fog::Collection

        model Fog::Compute::BigV::User


        def all()
          load(service.get_users.body)
        end


        def get(id)
          new(service.get_user(id).body)

          rescue Fog::Errors::NotFound
            nil
        end

      end

    end
  end
end
