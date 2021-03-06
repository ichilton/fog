Shindo.tests('Compute::VcloudDirector | vapp requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new
  @org = VcloudDirector::Compute::Helper.current_org(@service)

  tests('Each vDC') do
    @org[:Link].select do |l|
      l[:type] == 'application/vnd.vmware.vcloud.vdc+xml'
    end.each do |link|
      @vdc = @service.get_vdc(link[:href].split('/').last).body
      if @vdc[:ResourceEntities].is_a?(String)
        @vdc[:ResourceEntities] = {:ResourceEntity => []}
      elsif @vdc[:ResourceEntities][:ResourceEntity].is_a?(Hash)
        @vdc[:ResourceEntities][:ResourceEntity] = [@vdc[:ResourceEntities][:ResourceEntity]]
      end
      tests('Each vApp') do
        @vdc[:ResourceEntities][:ResourceEntity].select do |r|
          r[:type] == 'application/vnd.vmware.vcloud.vApp+xml'
        end.each do |v|
          @vapp_id = v[:href].split('/').last

          #tests("#get_vapp(#{@vapp_id})").data_matches_schema(VcloudDirector::Compute::Schema::VAPP_TYPE) do
          tests("#get_vapp(#{@vapp_id})").returns(Hash) do
            pending if Fog.mocking?
            @service.get_vapp(@vapp_id).body.class
          end

          tests("#get_lease_settings_section_vapp(#{@vapp_id})").returns(Hash) do
            pending if Fog.mocking?
            @service.get_lease_settings_section_vapp(@vapp_id).body.class
          end
          tests("#get_network_config_section_vapp(#{@vapp_id})").returns(Hash) do
            pending if Fog.mocking?
            @service.get_network_config_section_vapp(@vapp_id).body.class
          end
          tests("#get_network_section_vapp(#{@vapp_id})").returns(Hash) do
            pending if Fog.mocking?
            @service.get_network_section_vapp(@vapp_id).body.class
          end
          tests("#get_product_sections_vapp(#{@vapp_id})").returns(Hash) do
            pending if Fog.mocking?
            @service.get_product_sections_vapp(@vapp_id).body.class
          end
          tests("#get_startup_section(#{@vapp_id})").returns(Hash) do
            pending if Fog.mocking?
            @service.get_startup_section(@vapp_id).body.class
          end

          tests("#get_vapp_metadata(#{@vapp_id})").data_matches_schema(VcloudDirector::Compute::Schema::METADATA_TYPE) do
            pending if Fog.mocking?
            @service.get_vapp_metadata(@vapp_id).body
          end

          tests("#get_vapp_owner(#{@vapp_id})").data_matches_schema(VcloudDirector::Compute::Schema::OWNER_TYPE) do
            pending if Fog.mocking?
            @service.get_vapp_owner(@vapp_id).body
          end

          tests("#get_control_access_params_vapp(#{@vapp_id})").data_matches_schema(VcloudDirector::Compute::Schema::CONTROL_ACCESS_PARAMS_TYPE) do
            pending if Fog.mocking?
            @service.get_control_access_params_vapp(@vapp_id).body
          end
        end
      end
    end
  end

  tests('#get_vapps_in_lease_from_query').returns(Hash) do
    pending if Fog.mocking?
    @service.get_vapps_in_lease_from_query.body.class
  end

  tests('Retrieve non-existent vApp').raises(Excon::Errors::Forbidden) do
    pending if Fog.mocking?
    @service.get_vapp('00000000-0000-0000-0000-000000000000')
  end

  tests('Retrieve owner of non-existent vApp').raises(Excon::Errors::Forbidden) do
    pending if Fog.mocking?
    @service.get_vapp_owner('00000000-0000-0000-0000-000000000000')
  end

  tests('Delete non-existent vApp').raises(Excon::Errors::Forbidden) do
    pending if Fog.mocking?
    @service.delete_vapp('00000000-0000-0000-0000-000000000000')
  end

end
