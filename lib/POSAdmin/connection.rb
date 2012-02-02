include PosAdmin::Config
module PosAdmin
  module Connection

    Treequel::Model::DEFAULT_SAVE_OPTIONS = {}
    
    Treequel::Model.directory = Treequel.directory(
      :host => self.server,
      :base_dn => self.base_dn,
      :bind_dn => self.username,
      :pass => self.password,
      :connect_type => :plain
    )
    
    def directory
      Treequel.directory(
        :host => self.server,
        :base_dn => self.base_dn,
        :bind_dn => self.username,
        :pass => self.password,
        :connect_type => :plain
      )
    end
    
  end
end
