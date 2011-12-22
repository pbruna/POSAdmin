# Este modulo lee las credenciales de acceso para LDAP desde un archivo de configuracion
module PosAdmin
  module Config

    APP_CONFIG = YAML.load_file("#{Rails.root}/config/POSAdmin.yml")[Rails.env]

    def username
      APP_CONFIG['username']
    end

    def password
      APP_CONFIG['password']
    end

    def server
      APP_CONFIG['server']
    end

    def base_dn
      APP_CONFIG['base_dn']
    end

  end
end
