require 'fog/core/collection'
require 'fog/bigv/models/compute/group'

module Fog
  module Compute
    class BigV

      # Groups Collection

      # Collection of BigV groups
      # http://bigv-api-docs.ichilton.co.uk/api/groups/

      class Groups < Fog::Collection

        model Fog::Compute::BigV::Group


        def all()
          load(service.get_groups.body)
        end


        def get(id)
          all.find { |g| g.id == id || g.name == id }

          rescue Fog::Errors::NotFound
            nil
        end

      end

    end
  end
end
