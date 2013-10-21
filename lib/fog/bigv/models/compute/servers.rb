require 'fog/core/collection'
require 'fog/bigv/models/compute/server'

module Fog
  module Compute
    class BigV

      class Servers < Fog::Collection

        model Fog::Compute::BigV::Server

        def all(filters = {})
          load(all_virtual_machines)
        end

        def get(id)

          server = all_virtual_machines.select { |vm| vm['id'] == id}
          new(server.first) if server && server.first

          rescue Fog::Errors::NotFound
            nil
        end


        private

        def all_virtual_machines
          account_overview = service.account_overview.body
          account_overview['groups'].map { |g| g['virtual_machines'] }.flatten(1)
        end
      end

    end
  end
end
