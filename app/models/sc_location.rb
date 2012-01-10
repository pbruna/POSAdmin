# Attributes
# - cn: must
# - ipNetworkNumber: must
# - ipNetmaskNumber: must
# - scDhcpRange: must (x.x.x.x,x.x.x.y)
# - scDhcpFixedRange: must (x.x.x.x,x.x.x.y)
# - scDchpExtern: must ('TRUE', 'FALSE')
# - scDynamicIp: must ('TRUE', 'FALSE') Enable POS registration when scDchpExtern is FALSE
# - scWorkstationBaseName: must
# - scEnumerationMask: must
# - associatedDomain: may
# - userPassword: must
include Global::Instance

module ScLocation
  extend Treequel::Model::ObjectClass
  extend Global::Class

  model_class Treequel::Model
  model_bases self.base_dn
  model_objectclasses :scLocation
  main_attribute "cn"

  def delete_with_childrens!
    if delete_childrens!
      self.destroy
    else
      false
    end
  end
  
  def scDhcpRange_start
    scDhcpRange.split(/,/).first
  end
  
  def scDhcpRange_end
    scDhcpRange.split(/,/).last
  end
  
  def scDhcpFixedRange_start
    scDhcpFixedRange.split(/,/).first
  end
  
  def scDhcpFixedRange_end
    scDhcpFixedRange.split(/,/).last
  end
  
  def scDefaultGw_address
    scDefaultGw.first
  end
  
  def branch_server_ip_address
    branch_server.network_card_ip_address
  end
  
  def branch_server_network_card
    branch_server.network_card_device
  end
  
  def services
    branch_server.services
  end
  
  def branch_server
     array = []
      ScBranchServer.filter(:objectclass => "scBranchServer").all.each do |object|
        array << object if object.parent.dn == "cn=server,#{self.dn}"
      end
      array.first
  end
  
  def pos_devices_qty
    "TO BE DONE"
  end
  
  def server_ip_address
    branch_server.network_card_ip_address
  end
  
  def self.create_new(params)
    scLocation = params[:scLocation]
    sc_location = create("cn=#{scLocation[:cn]},#{scLocation[:parent]}")
    sc_location.scDhcpExtern = "FALSE"
    sc_location.scEnumerationMask = scLocation[:scEnumerationMask]
    sc_location.scDhcpRange = "#{scLocation[:scDhcpRange_start]},#{scLocation[:scDhcpRange_end]}"
    sc_location.scDefaultGw = scLocation[:scDefaultGw]
    sc_location.scWorkstationBaseName = scLocation[:scWorkstationBaseName]
    sc_location.ipNetmaskNumber = scLocation[:ipNetmaskNumber]
    sc_location.scDynamicIp = true
    sc_location.ipNetworkNumber = scLocation[:ipNetworkNumber]
    sc_location.scDhcpFixedRange = "#{scLocation[:scDhcpFixedRange_start]},#{scLocation[:scDhcpFixedRange_end]}"
    sc_location.userPassword = scLocation[:userPassword]
    sc_location
  end
  
  def after_create( mods )
    self.object_class << "top"
    self.save
    server_container = ScServerContainer.create_default(self.dn)
    branch_server = ScBranchServer.create_default(server_container.dn)
    server_container.save && branch_server.save
  end
  
end