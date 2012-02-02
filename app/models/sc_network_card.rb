# Attributes
# - scDevice: must
# - ipHostNumber: must
# - macAddress: may
# - scModul: may
# - scModulOption: may
# - ipNetmaskNumber: may

include Global::Instance

module ScNetworkCard
  extend Treequel::Model::ObjectClass
  extend Global::Class

  model_class Treequel::Model
  model_bases self.base_dn
  model_objectclasses :scNetworkcard
  main_attribute "scDevice"

  def ip_address
    ipHostnumber.first
  end
  
  def device
    scDevice.first
  end
  
  def self.create_from_form(params,sc_location)
    parent_dn = "cn=branch_server,cn=server,#{sc_location.dn}"
    network_card = create("scDevice=#{params[:scDevice]},#{parent_dn}")
    network_card.ipHostNumber = params[:ipHostNumber]
    network_card
  end

  def after_create( mods )
    self.object_class << "top"
    self.save
  end

end
