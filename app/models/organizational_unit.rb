# Attributes
# - ou: must
# - description: may

include PosAdmin::Connection

module OrganizationalUnit
  extend Treequel::Model::ObjectClass

  model_class Treequel::Model
  model_bases self.base_dn
  model_objectclasses :organizationalUnit

  def self.all
    Treequel::Model.directory.filter(:objectClass => self.model_objectclasses)
  end
  
  def after_create( mods )
    self.object_class << "top"
    self.save
  end

end
