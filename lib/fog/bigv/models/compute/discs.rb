require 'fog/core/collection'
require 'fog/bigv/models/compute/disc'

module Fog
  module Compute
    class BigV

      # Discs Collection

      # Collection of BigV discs
      # http://bigv-api-docs.ichilton.co.uk/api/discs/

      class Discs < Fog::Collection

        model Fog::Compute::BigV::Disc

        attr_accessor :server

        def all()
          discs = service.get_discs(server.id, server.group_id).body
          #load(discs)

          # Bit of a hack as we want to merge in the group_id, which we need
          # to know for api calls. Need to refactor this but it works for now.
          clear
          for disc in discs
            disc.merge!({ :group_id => server.group_id })
            self << new(disc)
          end
          self
        end


        def get(id)
          all.find { |d| d.id == id || d.label == id }

          rescue Fog::Errors::NotFound
            nil
        end

      end

    end
  end
end
