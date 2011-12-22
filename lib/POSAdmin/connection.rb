include PosAdmin::Config

module PosAdmin
  module Connection
    require 'treequel/model'
    require 'treequel/model/objectclass'

    Treequel::Model.directory = Treequel.directory(
      :host => self.server,
      :base_dn => self.base_dn,
      :bind_dn => self.username,
      :pass => self.password,
      :connect_type => :plain
    )
  end
end
