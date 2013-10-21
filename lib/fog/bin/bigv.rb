class BigV < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :compute
        Fog::Compute::BigV
      else
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :compute
          Fog::Logger.warning("BigV[:compute] is not recommended, use Compute[:bigv] for portability")
          Fog::Compute.new(:provider => 'BigV')
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::BigV.services
    end

  end
end
