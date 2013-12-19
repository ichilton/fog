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

      end

    end
  end
end
