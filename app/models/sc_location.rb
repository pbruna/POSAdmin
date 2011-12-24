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
  
  def branch_servers
     array = []
      ScBranchServer.filter(:objectclass => "scBranchServer").all.each do |object|
        array << object if object.parent.dn == "cn=server,#{self.dn}"
      end
      array
  end
  
  def self.all
    Treequel::Model.directory.filter(:objectClass => self.model_objectclasses)
  end
  
  def self.create_new(params)
    ou = create("cn=#{params[:cn]},#{params[:parent]}")
    ou.scDhcpExtern = "FALSE"
    ou.scEnumerationMask = params[:scEnumerationMask]
    ou.scDhcpRange = "#{params[:scDhcpRange_start]},#{params[:scDhcpRange_end]}"
    ou.scDefaultGw = params[:scDefaultGw]
    ou.scWorkstationBaseName = params[:scWorkstationBaseName]
    ou.ipNetmaskNumber = params[:ipNetmaskNumber]
    ou.scDynamicIp = true
    ou.ipNetworkNumber = params[:ipNetworkNumber]
    ou.scDhcpFixedRange = "#{params[:scDhcpFixedRange_start]},#{params[:scDhcpFixedRange_end]}"
    ou.userPassword = params[:userPassword]
    ou
  end
  
  def after_create( mods )
    self.object_class << "top"
    self.save
  end
  
end