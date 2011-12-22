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

  def after_create( mods )
    self.object_class << "top"
    self.save
  end

end
