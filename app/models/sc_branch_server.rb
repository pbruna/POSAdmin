include Global::Instance

module ScBranchServer
  extend Treequel::Model::ObjectClass
  extend Global::Class

  model_class Treequel::Model
  model_bases self.base_dn
  model_objectclasses :scBranchServer
  main_attribute "cn"

  def name
    cn.first
  end
  
  def services
    array = Array.new
    ScService.all.each do |object|
      array << object if object.parent.dn == "#{self.dn}"
    end
    array
  end

  def sc_location_dn
    parent.parent.dn
  end
  
  def sc_location_name
    sc_location = ScLocation.create(sc_location_dn)
    sc_location.short_name
  end

  def network_card
    array = []
    ScNetworkCard.filter(:objectclass => "scNetworkcard").all.each do |object|
      array << object if object.parent.dn == "#{self.dn}"
    end
    array.first
  end

  def network_card_ip_address
    network_card.ip_address unless network_card.nil?
  end

  def network_card_device
    network_card.device unless network_card.nil?
  end

  def fqdn
    fqdn = []
    array = dn.split(/,/)
    array.delete_at(1) # Delete element (cn=server) because is not part of FQDN
    array.each do |a|
      fqdn << a.split(/\=/)[1]
    end
    fqdn.join(".")
  end

  def posdevices_qty
    "TO BE DONE"
  end

  def self.create_default(parent)
    branch_server = create("cn=branch_server,#{parent}")
    branch_server.save
    branch_server
  end

  def self.all
    Treequel::Model.directory.filter(:objectClass => self.model_objectclasses)
  end

  def after_create( mods )
    self.object_class << "top"
    self.save
  end

end
