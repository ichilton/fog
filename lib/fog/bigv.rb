require 'fog/core'

module Fog
  module BigV
    extend Fog::Provider
    service(:compute, 'bigv/compute', 'Compute')
  end
end

