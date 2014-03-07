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
          discs.each { |disc| disc[:group_id] = server.group_id }
          load(discs)
        end


        def get(id)
          all.find { |d| d.id == id || d.label == id }

          rescue Fog::Errors::NotFound
            nil
        end


        def new(attributes={})
          unless attributes.is_a?(::Hash)
            raise(ArgumentError.new("Initialization parameters must be an attributes hash, got #{attributes.class} #{attributes.inspect}"))
          end

          attributes[:server_id] = server.id
          attributes[:group_id] = server.group_id
          super(attributes)
        end

      end

    end
  end
end
