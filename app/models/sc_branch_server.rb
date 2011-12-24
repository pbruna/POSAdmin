include PosAdmin::Connection

module ScBranchServer
  extend Treequel::Model::ObjectClass

  model_class Treequel::Model
  model_bases self.base_dn
  model_objectclasses :scBranchServer

  def name
    cn.first
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
  
  def self.create_default(parent)
    branch_server = create("cn=branch_server,#{parent}")
    branch_server.save
    branch_server
  end
  
  def after_create( mods )
    self.object_class << "top"
    self.save
  end

end
