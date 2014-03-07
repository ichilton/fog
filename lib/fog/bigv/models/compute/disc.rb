require 'fog/core/model'

module Fog
  module Compute
    class BigV

      # Disc Model

      # Models a BigV disc
      # http://bigv-api-docs.ichilton.co.uk/api/discs/

      class Disc < Fog::Model

        identity :id

        attribute :server_id, :aliases => 'virtual_machine_id'
        attribute :group_id

        attribute :label
        attribute :size
        attribute :storage_pool
        attribute :storage_grade


        def save
          if persisted?
            response = _update
          else
            response = _create
          end

          merge_attributes(response.body)
        end


        def destroy
          requires :id
          service.delete_disc(id, server_id, group_id)
          true
        end


        private

        def _create
          requires :server_id, :group_id
          service.create_disc(server_id, group_id, attributes)
        end

        def _update
          requires :id, :server_id, :group_id
          response = service.update_disc(id, server_id, group_id, attributes)
        end
      end

    end
  end
end
