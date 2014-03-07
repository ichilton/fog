require 'fog/core/collection'
require 'fog/bigv/models/compute/nic'

module Fog
  module Compute
    class BigV

      # Nics Collection

      # Collection of BigV nics
      # http://bigv-api-docs.ichilton.co.uk/api/nics/

      class Nics < Fog::Collection

        model Fog::Compute::BigV::Nic

        attr_accessor :server

        def all()
          nics = service.get_nics(server.id, server.group_id).body
          nics.each { |nic| nic[:group_id] = server.group_id }
          load(nics)
        end


        def get(id)
          all.find { |d| d.id == id || d.label == id }

          rescue Fog::Errors::NotFound
            nil
        end


        def primary
          @primary_nic ||= all.first
        end

      end

    end
  end
end
