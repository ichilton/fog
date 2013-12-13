module Fog
  module Compute
    class BigV

      # create_virtual_machine

      # Creates a new virtual machine. This only creates the machine itself though,
      # use the create_server request to include a disc and an operating system.

      # params:
      #   options - a hash containing:
      #     - group_id (defaults to the 'default' group)
      #     - name
      #     - cores
      #     - memory (in megabytes)
      #     - cdrom_url
      #     - autoreboot_on
      #     - power_on
      #     - hardware_profile

      # Success returns a 202 response, but the machine is created in the background.

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/virtual_machines/

      # Currently, options can be empty and sane default will be used, but i'll
      # probably move the default into the model to keep things DRY.

      class Real

        def create_virtual_machine(options = {})
          group_id = options[:group_id] || 'default'

          post_data = {
            :name              =>  options[:name],
            :cores             =>  options[:cores]             ||  1,
            :memory            =>  options[:memory]            ||  1024,
            :cdrom_url         =>  options[:cdrom_url]         ||  nil,
            :autoreboot_on     =>  options[:auto_reboot]       ||  false,
            :power_on          =>  options[:power_on]          ||  false,
            :hardware_profile  =>  options[:hardware_profile]  ||  nil
          }

          bigv_api_request(
            :expects  => [202],
            :method   => 'POST',
            :path     => "/accounts/#{@bigv_account}/groups/#{group_id}/virtual_machines",
            :body     => Fog::JSON.encode(post_data)
          )
        end

      end

      class Mock

        def create_virtual_machine(options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
