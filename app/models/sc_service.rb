include PosAdmin::Connection

module ScService
  extend Treequel::Model::ObjectClass

  model_class Treequel::Model
  model_bases self.base_dn
  model_objectclasses :scService
  
  def after_create( mods )
    self.object_class << "top"
    self.save
  end
  
end