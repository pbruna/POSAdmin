# Attributes
# - ou: must
# - description: may

include PosAdmin::Connection

module OrganizationalUnit
  extend Treequel::Model::ObjectClass

  model_class Treequel::Model
  model_bases self.base_dn
  model_objectclasses :organizationalUnit
  
  def name
    ou.first
  end
  
  def locations
    array = []
    ScLocation.filter(:objectclass => "scLocation").all.each do |object|
      array << object if object.parent.dn == self.dn
    end
    array
  end

  def self.all
    Treequel::Model.directory.filter(:objectClass => self.model_objectclasses)
  end
  
  def self.for_select
    all.map {|o| [o.ou.first, o.dn]}
  end
  
  def after_create( mods )
    self.object_class << "top"
    self.save
  end

end
