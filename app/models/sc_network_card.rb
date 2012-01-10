# Attributes
# - scDevice: must
# - ipHostNumber: must
# - macAddress: may
# - scModul: may
# - scModulOption: may
# - ipNetmaskNumber: may

include PosAdmin::Connection

module ScNetworkCard
  extend Treequel::Model::ObjectClass

  model_class Treequel::Model
  model_bases self.base_dn
  model_objectclasses :scNetworkcard

  def ip_address
    ipHostnumber.first
  end
  
  def device
    scDevice.first
  end
  
  def self.create_new(params,parent)
    parent_dn = "cn=branch_server,cn=server,#{parent.dn}"
    network_card = create("scDevice=#{params['scDevice']},#{parent_dn}")
    network_card.ipHostNumber = params['ipHostNumber']
    network_card
  end

  def after_create( mods )
    self.object_class << "top"
    self.save
  end

end
