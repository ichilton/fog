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

        attr_accessor :group


        def all(filters = {})
          load(_servers)

          # TODO - implement filters!
        end


        def deleted(filters = {})
          load(_deleted_servers)

          # TODO - implement filters!
        end


        def get(id)
          server = _servers(true).find { |vm| vm['id'] == id || vm['name'] == id }
          new(server) if server

          rescue Fog::Errors::NotFound
            nil
        end


        def new(attributes={})
          unless attributes.is_a?(::Hash)
            raise(ArgumentError.new("Initialization parameters must be an attributes hash, got #{attributes.class} #{attributes.inspect}"))
          end

          attributes[:group_id] = group.id if in_group? && attributes[:group_id].nil?
          super(attributes)
        end


        def in_group?
          !! (group && group.id)
        end


        def purge_all
          deleted.each do |server|
            server.purge
          end
          true
        end


        private

        def _servers(include_deleted=false)
          # Use account overview request as it gives all groups and embeds discs & nics:
          account_overview = service.get_account_overview(include_deleted).body

          # Only servers in group:
          if group && group.id
            group_overview = account_overview['groups'].find { |g| g['id'] == group.id }
            group_overview['virtual_machines']

          # All servers:
          else
            account_overview['groups'].map { |g| g['virtual_machines'] }.flatten(1)
          end
        end


        def _deleted_servers
          _servers(true).select { |vm| vm['deleted'] == true }
        end

      end

    end
  end
end
