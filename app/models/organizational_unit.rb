# Attributes
# - ou: must
# - description: may

# include PosAdmin::Connection
include Global::Instance

module OrganizationalUnit
  extend Treequel::Model::ObjectClass
  extend Global::Class

  model_class Treequel::Model
  model_bases self.base_dn
  model_objectclasses :organizationalUnit
  main_attribute "ou"


  def remove_only_if_empty
    begin
      self.destroy
    rescue Exception
      false
    end
  end

  def locations
    @locations = []
    filter(:objectclass => "scLocation").all.each do |object|
      @locations << ScLocation.create(object.dn)
    end
    @locations
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
    organizational_unit = self.create("ou=#{params['short_name']},#{self.base_dn}")
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
