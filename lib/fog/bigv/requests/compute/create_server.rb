module Fog
  module Compute
    class BigV

      # create_server

      # Creates a new virtual machine, with discs and an operating system in a
      # single call.

      # (see the create_virtual_machine request to just create a bare virtual machine)

      # params:
      #   options - a hash containing:
      #     - group_id (defaults to the 'default' group)
      #     - name
      #     - root_password
      #     - cores
      #     - memory - in megabytes
      #     - cdrom_url
      #     - autoreboot_on
      #     - power_on
      #     - hardware_profile

      #     - distribution - see: http://bigv-api-docs.ichilton.co.uk/api/definitions/

      #     - discs - an array containing an hashes with the following:
      #       - label - defaults to sequential label of: vda, vdb, vdc etc...
      #       - storage-grade - sata/sas/ssd/archive - defaults to: sata
      #       - size - in megabytes - defualts to 20GB
      #       (see: http://bigv-api-docs.ichilton.co.uk/api/discs/)

      # Success returns a 202 response, but the machine is created in the background.

      # For more information, see: http://bigv-api-docs.ichilton.co.uk/api/virtual_machines/

      # Currently, options can be empty and sane default will be used, but i'll
      # probably move the default into the model to keep things DRY.

      class Real

        def create_server(options = {})
          group_id = options[:group_id] || 'default'

          virtual_machine_opts = {
            :name              =>  options[:name],
            :cores             =>  options[:cores]             ||  1,
            :memory            =>  options[:memory]            ||  1024,
            :cdrom_url         =>  options[:cdrom_url]         ||  nil,
            :autoreboot_on     =>  options[:auto_reboot]       ||  true,
            :power_on          =>  options[:power_on]          ||  true,
            :hardware_profile  =>  options[:hardware_profile]  ||  nil
          }

          discs_opts = []

          options[:discs].each do |disc|
            discs_opts << {
              :label          =>  disc[:label]          ||  "vd" + (discs_opts.count + 97).chr,
              :storage_grade  =>  disc[:storage_grade]  ||  'sata',
              :size           =>  (disc[:size] || 20) * 1024
            }
          end if options[:discs] && options[:discs].kind_of?(Array)

          discs_opts << { :label => 'vda', :storage_grade => 'sata', :size => 20480 } if discs_opts.empty?


          reimage_opts = {
            :distribution   =>  options[:distribution]  ||  'precise',
            :root_password  =>  options[:root_password]
          }


          bigv_api_request(
            :expects  => [202],
            :method   => 'POST',
            :path     => "/accounts/#{@bigv_account}/groups/#{group_id}/vm_create",
            :body     => Fog::JSON.encode( { :virtual_machine => virtual_machine_opts,
                                             :discs => discs_opts,
                                             :reimage => reimage_opts } )
          )

        end

      end

      class Mock

        def create_server(options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
