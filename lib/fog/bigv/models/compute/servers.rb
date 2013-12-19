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
          load(get_all_servers)

          # TODO - implement filters!
        end


        def deleted(filters = {})
          load(get_deleted_servers)

          # TODO - implement filters!
        end


        def get(id)
          server = get_all_servers(true).find { |vm| vm['id'] == id || vm['name'] == id }
          new(server) if server

          rescue Fog::Errors::NotFound
            nil
        end


        private

        def get_all_servers(include_deleted=false)
          account_overview = service.get_account_overview(include_deleted).body
          account_overview['groups'].map { |g| g['virtual_machines'] }.flatten(1)
        end


        def get_deleted_servers
          get_all_servers(true).select { |vm| vm['deleted'] == true }
        end

      end

    end
  end
end
