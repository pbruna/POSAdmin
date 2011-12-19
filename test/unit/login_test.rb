require 'test_helper'

class LoginTest < ActiveSupport::TestCase
  
  setup do
    @config_file = "#{Rails.root}/config/POSAdmin.yml"
  end
  
  test "El archivo de configuracion debe existir" do
    assert(File.exist?(@config_file), "El archivo no existe")
  end
  
  test "Login.username debe retornar el usuario" do
    username = test
    config_username = Login::username
    assert_equal(username, config_username)
  end
  
end
