include Global::Instance

module ScService
  extend Treequel::Model::ObjectClass
  extend Global::Class

  model_class Treequel::Model
  model_bases self.base_dn
  model_objectclasses :scService
  main_attribute "cn"

  SERVICES = %w(dhcp dns tftp)

  def self.create_or_update_from_form(params,sc_location)
    services = {}
    params = params.nil? ? Hash.new : params
    SERVICES.each do |service_name|
      begin
        status = params[service_name.to_sym].nil? ? false : true
        service = create_service(service_name,sc_location,status)
        services[service_name.to_sym] = service if service.save
      rescue Exception => e
        raise e.message
      end
    end
    services
  end

  def after_create( mods )
    self.object_class << "top"
    self.save
  end

  private
    def self.create_service(service_name,sc_location,status)
      service = create("cn=#{service_name},cn=branch_server,cn=server,#{sc_location.dn}")
      service.scServiceName = service_name
      service.scServiceStatus = status
      service.scDnsName = service_name
      service.scServiceStartScript = case service_name
          when "dns"
            "named"
          when "dhcp"
            "dhcpd"
          when "tftp"
            "tftpd"
          end
      service.ipHostNumber = sc_location.branch_server_ip_address
      service
    end

end
