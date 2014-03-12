require 'fog/core/model'

module Fog
  module Compute
    class BigV

      # Privilege Model

      # Models a BigV privilege
      # http://bigv-api-docs.ichilton.co.uk/api/privilege/

      class Privilege < Fog::Model

        identity :id

        attribute :virtual_machine_id
        attribute :group_id
        attribute :account_id

        attribute :username
        attribute :level
        attribute :creating_username
        attribute :yubikey_required
        attribute :yubikey_otp_max_age
        attribute :ip_restrictions

        attr_accessor :user_id

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
          service.delete_privilege(id)
          true
        end

        private

        def _create
          requires :user_id
          service.create_user_privilege(user_id, attributes)
        end

        def _update
          requires :id
          service.update_privilege(id, attributes)
        end

      end

    end
  end
end
