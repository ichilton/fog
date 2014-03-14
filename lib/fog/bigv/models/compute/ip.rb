require 'fog/core/model'

module Fog
  module Compute
    class BigV

      # Ip Model

      # Models a BigV IP Address
      # http://bigv-api-docs.ichilton.co.uk/api/ips/

      class Ip < Fog::Model

        identity :address

        attribute :rdns

        def save
          if persisted?
            response = service.update_ip(address, attributes)
            merge_attributes(response.body)
          end
        end

      end

    end
  end
end
