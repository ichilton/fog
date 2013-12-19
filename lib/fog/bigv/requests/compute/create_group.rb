module Fog
  module Compute
    class BigV

      # create_group

      # Create a new Group

      # params:
      #   options - a hash containing:
      #     - name

      # Success returns a 200 response.

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/groups/

      class Real

        def create_group(options={})
          bigv_api_request(
            :expects  => [200],
            :method   => 'POST',
            :path     => "accounts/#{@bigv_account}/groups",
            :body     => Fog::JSON.encode(options)
          )
        end

      end

      class Mock

        def create_group(options={})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
