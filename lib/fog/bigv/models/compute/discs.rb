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
          discs = service.get_discs(server.id).body
          load(discs)
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
