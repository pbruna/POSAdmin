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
  
  test "OrganizationalUnit#locations debe devolver un array con los locales" do
    ou = OrganizationalUnit.all.first
    locations = ou.locations
    assert(locations.kind_of?(Array), "locations debe ser un Array")
  end
  
  test "La descripcion debe ser la misma que la que se ingreso" do
    ou = OrganizationalUnit.create(@dn)
    description = "Description 1"
    ou.description = description
    ou.save
    assert_equal(description, ou.description.first)
  end
  
  # test "El metodo update debe actualizar los atributos" do
  #   @ou = OrganizationalUnit.create(@dn)
  #   @ou.save
  #   attributes = {:description => "juanito", :dn => "ou=quillota,o=cruzverde,c=cl"}
  #   @ou.update(attributes)
  #   assert_equal("jaunito", @ou.description)
  #   assert_equal("ou=quillota,o=cruzverde,c=cl", @ou.dn)
  # end


end
