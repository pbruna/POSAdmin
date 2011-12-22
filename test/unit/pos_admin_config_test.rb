require 'test_helper'

class PosAdminConfigTest < ActiveSupport::TestCase

  setup do
    @config_file = "#{Rails.root}/config/POSAdmin.yml"

    class LoginClass
      include PosAdmin::Config
    end
    @login_class = LoginClass.new
    
  end

  test "El archivo de configuracion debe existir" do
    assert(File.exist?(@config_file), "El archivo no existe")
  end

  test "Login.username debe retornar el usuario" do
    username = "cn=admin,o=cruzverde,c=cl"
    config_username = @login_class.username
    assert_equal(username, config_username)
  end

  test "Login.password debe retornar la constrasena del usuario" do
    password = "suse.10"
    config_password = @login_class.password
    assert_equal(password, config_password)
  end
  
  test "Login.server debe retornar la direccion del servidor" do
    server = "10.211.55.5"
    config_server = @login_class.server
    assert_equal(server, config_server)
  end
  
  test "Login.base_dn debe retornar la base de busqueda LDAP" do
    base = "o=cruzverde,c=cl"
    config_base = @login_class.base_dn
    assert_equal(base, config_base)
  end


end
