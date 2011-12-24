include PosAdmin::Connection

module ScServerContainer
  extend Treequel::Model::ObjectClass

  model_class Treequel::Model
  model_bases self.base_dn
  model_objectclasses :scServerContainer
  
  def self.create_default(parent)
    server_container = create("cn=server,#{parent}")
    server_container.save
    server_container
  end
  
  def after_create( mods )
    self.object_class << "top"
    self.save
  end
  
end