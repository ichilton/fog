require 'fog/compute/models/server'

module Fog
  module Compute
    class BigV

      # Disc Model

      # Models a BigV disc
      # http://bigv-api-docs.ichilton.co.uk/api/discs/

      class Disc < Fog::Model

        identity :id

        attribute :server_id, :aliases => 'virtual_machine_id'

        attribute :label
        attribute :size
        attribute :storage_pool
        attribute :storage_grade

      end

    end
  end
end
