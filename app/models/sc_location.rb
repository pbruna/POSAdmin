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
include PosAdmin::Connection

module ScLocation
  extend Treequel::Model::ObjectClass

  model_class Treequel::Model
  model_bases self.base_dn
  model_objectclasses :scLocation
  
  def name
    cn.first
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
  
  def self.all
    Treequel::Model.directory.filter(:objectClass => self.model_objectclasses)
  end
  
  def self.create_new(params)
    sc_location = create("cn=#{params[:cn]},#{params[:parent]}")
    sc_location.scDhcpExtern = "FALSE"
    sc_location.scEnumerationMask = params[:scEnumerationMask]
    sc_location.scDhcpRange = "#{params[:scDhcpRange_start]},#{params[:scDhcpRange_end]}"
    sc_location.scDefaultGw = params[:scDefaultGw]
    sc_location.scWorkstationBaseName = params[:scWorkstationBaseName]
    sc_location.ipNetmaskNumber = params[:ipNetmaskNumber]
    sc_location.scDynamicIp = true
    sc_location.ipNetworkNumber = params[:ipNetworkNumber]
    sc_location.scDhcpFixedRange = "#{params[:scDhcpFixedRange_start]},#{params[:scDhcpFixedRange_end]}"
    sc_location.userPassword = params[:userPassword]
    sc_location
  end
  
  def after_create( mods )
    self.object_class << "top"
    self.save
  end
  
end