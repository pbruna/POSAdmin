include PosAdmin::Connection

module ScBranchServer
  extend Treequel::Model::ObjectClass

  model_class Treequel::Model
  model_bases self.base_dn
  model_objectclasses :scBranchServer

  def after_create( mods )
    self.object_class << "top"
    self.save
  end

end
