module Fog
  module Compute
    class VcloudDirector
      class Real
        # Set the value for the specified metadata key to the value provided,
        # overwriting any existing value.
        #
        # @param [String] id Object identifier of the disk.
        # @param [String] key Key of the metadata item.
        # @param [Boolean,DateTime,Fixnum,String] value Value of the metadata
        #   item.
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/PUT-DiskMetadataItem-metadata.html
        #   vCloud API Documentation
        # @since vCloud API version 5.1
        def put_disk_metadata_item_metadata(id, key, value)
          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            }
            MetadataValue(attrs) {
              type = case value
                     when TrueClass, FalseClass then 'MetadataBooleanValue';
                     when DateTime then 'MetadataDateTimeValue';
                     when Fixnum then 'MetadataNumberValue';
                     else 'MetadataStringValue'
                     end
              TypedValue('xsi:type' => type) { Value value }
            }
          end.to_xml

          request(
            :body    => body,
            :expects => 202,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.metadata.value+xml'},
            :method  => 'PUT',
            :parser  => Fog::ToHashDocument.new,
            :path    => "disk/#{id}/metadata/#{URI.escape(key)}"
          )
        end
      end
    end
  end
end
