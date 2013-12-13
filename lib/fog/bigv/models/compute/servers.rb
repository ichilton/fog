require 'fog/core/collection'
require 'fog/bigv/models/compute/server'

module Fog
  module Compute
    class BigV

      # Servers Collection

      # Collection of BigV virtual machines
      # http://bigv-api-docs.ichilton.co.uk/api/virtual_machines/

      class Servers < Fog::Collection

        model Fog::Compute::BigV::Server


        def all(filters = {})
          load(all_virtual_machines)

          # TODO - implement filters!
        end


        def get(id)
          server = all_virtual_machines.select { |vm| vm['id'] == id}
          new(server.first) if server && server.first

          rescue Fog::Errors::NotFound
            nil
        end


        private

        def all_virtual_machines
          account_overview = service.get_account_overview.body
          account_overview['groups'].map { |g| g['virtual_machines'] }.flatten(1)
        end
      end

    end
  end
end
