module Fog
  module Compute
    class VcloudDirector
      class Real
        # Expose hardware-assisted CPU virtualization to guest OS.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-EnableNestedHv.html
        #   vCloud API Documentation
        # @since vCloud API version 5.1
        def post_enable_nested_hv(id)
          request(
            :expects => 202,
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/action/enableNestedHypervisor"
          )
        end
      end
    end
  end
end
