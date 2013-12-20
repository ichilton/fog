require 'fog/core/model'

module Fog
  module Compute
    class BigV

      # Group Model

      # Models a BigV group
      # http://bigv-api-docs.ichilton.co.uk/api/groups/

      class Group < Fog::Model

        identity :id
        attribute :name


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
          service.delete_group(id)
          true
        end


        def servers
          Fog::Compute::BigV::Servers.new({
            :service => service,
            :group => self
          })
        end


        private

        def _create
          requires :name
          service.create_group(attributes)
        end

        def _update
          requires :id, :name
          response = service.update_group(id, attributes)
        end

      end

    end
  end
end
