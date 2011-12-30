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

  def description_text
    description.join("\n")
  end

  def name=(name)
    ou=name
  end

  def locations
    array = []
    ScLocation.filter(:objectclass => "scLocation").all.each do |object|
      array << object if object.parent.dn == self.dn
    end
    array
  end

  def branchs
    locations
  end

  def brachservers_qty
    locations.size
  end

  def posdevices_qty
    "To Be Done"
  end

  def self.all
    Treequel::Model.directory.filter(:objectClass => self.model_objectclasses)
  end
  
  def self.find(params)
    array = params.split(/,/)
    hash = {}
    array.each do |e|
      k, v = e.split(/\=/)
      hash[k] = v
    end
    filter(:ou => hash["ou"]).first
  end

  def self.for_select
    all.map {|o| [o.ou.first, o.dn]}
  end

  def self.create_new(params)
    params["description"] ||= ""
    organizational_unit = self.create("ou=#{params['name']},#{self.base_dn}")
    organizational_unit.description = params["description"]
    organizational_unit
  end

  def after_create( mods )
    self.object_class << "top"
    self.save
  end
  
  def after_save (mods)
    # To not have 2 description attributes    
    if self.description.size > 1
      text = self.description.last
      self.delete(:description)
      self.description = text
      self.save
    end
  end
  
  def before_update( mods )
    self.delete("description")
  end

end
