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

  def network_card_dn
    branch_server.network_card_dn
  end

  def scNetworkcard(param)
    hash = {
      :scDevice => self.branch_server_network_card,
      :ipHostNumber => self.branch_server_ip_address
    }
    hash[param.to_sym]
  end

  def scService(param)
    self.services[param]
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

  def server_container
    ScServerContainer.create("cn=server,#{self.dn}")
  end

  def pos_devices_qty
    "TO BE DONE"
  end

  def server_ip_address
    branch_server.network_card_ip_address
  end

  def self.create_new(params)
    dn = "cn=#{params[:cn]},#{params[:parent]}"
    attrs = build_attributes(params)
    sc_location = create(dn, attrs)
  end

  def after_create( mods )
    self.object_class << "top"
    self.save
  end

  def self.build_attributes(params)
    attrs = {
      :cn => params[:cn],
      :scEnumerationMask => params[:scEnumerationMask],
      :scDhcpRange => "#{params[:scDhcpRange_start]},#{params[:scDhcpRange_end]}",
      :scDefaultGw => params[:scDefaultGw],
      :scWorkstationBaseName => params[:scWorkstationBaseName],
      :ipNetmaskNumber => params[:ipNetmaskNumber],
      :scDynamicIp => "TRUE",
      :scDhcpExtern => "FALSE",
      :ipNetworkNumber => params[:ipNetworkNumber],
      :scDhcpFixedRange => "#{params[:scDhcpFixedRange_start]},#{params[:scDhcpFixedRange_end]}",
      :userPassword => params[:userPassword]
    }
    attrs
  end

end
