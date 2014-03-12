require 'fog/core/model'

module Fog
  module Compute
    class BigV

      # User Model

      # Models a BigV user
      # http://bigv-api-docs.ichilton.co.uk/api/users/

      class User < Fog::Model

        identity :id

        attribute :username
        attribute :email
        attribute :authorized_keys

        attr_accessor :password  # only for create/update

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
          service.delete_user(id)
          true
        end

        def privileges
          @privileges ||= Fog::Compute::BigV::Privileges.new({
                      :service => service,
                      :user => self
                    })
        end


        private

        def _create
          requires :username, :email, :password
          service.create_user(attributes.merge({password: password}))
        end

        def _update
          # username & email can't be updated - only authorized_keys and password.
          requires :id
          service.update_user(id, password.nil? ? attributes : attributes.merge({password: password}))
        end

      end

    end
  end
end
