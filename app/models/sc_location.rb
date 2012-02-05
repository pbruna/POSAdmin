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
include Validations

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

  def scNetworkcard=(hash = {})
    network_card = ScNetworkCard.create_from_form(hash,self)
    network_card.save
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

  def scService(param)
    self.services[param]
  end

  def services
    branch_server.services
  end

  def branch_server
    ScBranchServer.model_bases self.dn
    ScBranchServer.all.first
  end

  def server_container
    ScServerContainer.find("cn=server,#{self.dn}")
  end

  def pos_devices_qty
    "TO BE DONE"
  end

  def server_ip_address
    branch_server.network_card_ip_address
  end

  def self.create_from_form(params)
    dn = "cn=#{params[:cn]},#{params[:parent]}"
    attrs = build_attributes(params)
    sc_location = create(dn, attrs)
  end

  def update_from_form(params)
    attrs = ScLocation.build_attributes(params)
    update!(attrs)
  end

  def after_create( mods )
    self.object_class << "top"
    self.save
    create_container_and_branch(self.dn)
  end

  def validate(options = {})
    validates_ip_format_of :ipNetworkNumber, :ipNetmaskNumber, :scDhcpRange_start, :scDhcpRange_end
    validates_ip_format_of :scDefaultGw, :scDhcpFixedRange_start, :scDhcpFixedRange_end
    super
  end

  


  def self.build_attributes(params)
    attrs = {
      :cn => params[:cn],
      :scEnumerationMask => params[:scEnumerationMask],
      :scDhcpRange => "#{params[:scDhcpRange_start]},#{params[:scDhcpRange_end]}",
      :scDefaultGw => params[:scDefaultGw],
      :scWorkstationBaseName => params[:scWorkstationBaseName],
      :ipNetmaskNumber => params[:ipNetmaskNumber],
      :scDynamicIp => true,
      :scDhcpExtern => false,
      :ipNetworkNumber => params[:ipNetworkNumber],
      :scDhcpFixedRange => "#{params[:scDhcpFixedRange_start]},#{params[:scDhcpFixedRange_end]}",
      :userPassword => params[:userPassword]
    }
    attrs
  end

  private
  def create_container_and_branch(parent_dn)
    container = ScServerContainer.create_default(parent_dn)
    branch_server = ScBranchServer.create_default(container.dn)
  end
end
