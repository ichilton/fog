require 'fog/core/collection'
require 'fog/bigv/models/compute/privilege'

module Fog
  module Compute
    class BigV

      # Privileges Collection

      # Collection of BigV privileges
      # http://bigv-api-docs.ichilton.co.uk/api/privileges/

      class Privileges < Fog::Collection

        model Fog::Compute::BigV::Privilege

        attr_accessor :user

        def all()
          if user && user.id
            load(service.get_user_privileges(user.id).body)
          else
            load(service.get_privileges.body)
          end
        end

        def get(id)
          new(service.get_privilege(id).body)

          rescue Fog::Errors::NotFound
            nil
        end

        def new(attributes={})
          unless attributes.is_a?(::Hash)
            raise(ArgumentError.new("Initialization parameters must be an attributes hash, got #{attributes.class} #{attributes.inspect}"))
          end

          attributes[:user_id] = user.id if user && user.id
          super(attributes)
        end

      end

    end
  end
end
