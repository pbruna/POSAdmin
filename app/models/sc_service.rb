include Global::Instance

module ScService
  extend Treequel::Model::ObjectClass
  extend Global::Class

  model_class Treequel::Model
  model_bases self.base_dn
  model_objectclasses :scService

  SERVICES = %w(dhcp dns tftp)

  def self.create_and_save(params,grand_grand_parent)
    params = params.nil? ? Hash.new : params
    parent_dn = "cn=branch_server,cn=server,#{grand_grand_parent.dn}"
    SERVICES.each do |service_name|
      begin
        status = params[service_name.to_sym].nil? ? false : true
        s = create_service(service_name,parent_dn,grand_grand_parent.server_ip_address,status)
        s.save
        s.modify(:scServiceStatus => "FALSE") unless status
      rescue Exception => e
        puts e.message
        puts e.backtrace.inspect
        false
      end
    end
    
  end

  def after_create( mods )
    self.object_class << "top"
    self.save
  end

  private
    def self.create_service(service_name,parent_dn,branch_ip_address,status)
      s = create("cn=#{service_name},#{parent_dn}")
      s.scServiceName = service_name
      s.scServiceStatus = "TRUE"
      s.scDnsName = service_name
      s.scServiceStartScript = case service_name
          when "dns"
            "named"
          when "dhcp"
            "dhcpd"
          when "tftp"
            "tftpd"
          end
      s.ipHostNumber = branch_ip_address
      s
    end

end
