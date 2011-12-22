require 'test_helper'

class OrganizationalUnitTest < ActiveSupport::TestCase

  setup do
    @dn = "ou=lacalera,o=cruzverde,c=cl"
  end
  
  teardown do
    ou = OrganizationalUnit.filter(:ou => "lacalera").first
    ou.destroy unless ou.nil?
  end

  test "Se debe agregar el objectClass 'top' despues de crear una OU" do
    ou = OrganizationalUnit.create(@dn)
    ou.save
    assert(ou.object_class.include?("top"), "No se agrego la objectClass top")
  end


end
