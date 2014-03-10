require 'fog/core/model'

module Fog
  module Compute
    class BigV

      # Account Model

      # Models a BigV account
      # http://bigv-api-docs.ichilton.co.uk/api/account/

      class Account < Fog::Model

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
          service.delete_account(id)
          true
        end


        private

        def _create
          requires :name
          service.create_account(attributes)
        end

        def _update
          # Currently the name can not be updated, but this is here for future
          # compatibility.
          requires :id
          response = service.update_account(id, attributes)
        end

      end

    end
  end
end
