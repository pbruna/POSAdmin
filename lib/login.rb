class  Login

  APP_CONFIG = YAML.load_file("#{Rails.root}/config/POSAdmin.yml}")[RAILS_ENV]


  def username
    APP_CONFIG['username']
  end

  def password
    APP_CONFIG['password']
  end

end
