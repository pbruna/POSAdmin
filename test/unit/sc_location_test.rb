require 'test_helper'

class ScLocationTest < ActiveSupport::TestCase

  setup do
    @cn = "local58"
    @parent = "ou=santiago,o=cruzverde,c=cl"
    @dn = "cn=local58,ou=santiago,o=cruzverde,c=cl"
  end

  teardown do
    sc_location = ScLocation.filter(:cn => "local58").first
    sc_location_to_update = ScLocation.filter(:cn => "local59").first
    sc_location.delete_with_childrens! unless sc_location.nil?
    sc_location_to_update.delete_with_childrens! unless sc_location_to_update.nil?
  end

  test "Se debe agregar el objectClass 'top' despues de crear una scLocation" do
    sc_location = ScLocation.create(@dn,
                           :ipNetworkNumber => "192.168.0.0",
                           :ipNetmaskNumber => "255.255.255.0",
                           :scDhcpRange => "192.168.0.100,192.168.0.200",
                           :scDhcpFixedRange => "192.168.0.201,192.168.0.250",
                           :scDefaultGw => "192.168.0.1",
                           :scDynamicIp => true,
                           :scWorkstationBaseName => "POS",
                           :scEnumerationMask => "00",
                           :scDhcpExtern => false,
                           :userPassword => "suse.10"
                           )
    sc_location.save
    assert(sc_location.object_class.include?("top"), "No se agrego la objectClass top")
  end
  
  test "ScLocations#branch_server debe devolver solo un branch" do
    location = ScLocation.all.first
    branch_server = location.branch_server
    assert(!branch_server.kind_of?(Array), "branch_servers no debe ser un Array")
  end

  test "Se debe guardar con los datos enviados del formulario web" do
    location = new_location_from_params
    assert(location.save, "No se pudo guardar")
  end

  test "Se debe actualizar los atributos con los datos enviados del formulario" do
    location = new_location_from_params
    location.save
    location_to_update = ScLocation.find(location.dn)
    params = build_location_update_params[:scLocation]
    params[:cn] = @cn
    params[:parent] = @parent
    location_to_update.update_from_form(params)
    assert_equal(location.dn, location_to_update.dn)
    assert_not_equal(location.ipNetworkNumber, location_to_update.ipNetworkNumber)
  end

  test "Se debe mover de posicion cuando se cambia el main_attribute" do
    location = new_location_from_params
    location.save
    location_to_update = ScLocation.find(location.dn)
    params = build_location_update_params[:scLocation]
    params[:cn] = "local59"
    params[:parent] = @parent
    new_location = location_to_update.update_from_form(params)
    assert_not_equal(location.dn, new_location.dn)
    assert_not_equal(location.ipNetworkNumber, location_to_update.ipNetworkNumber)
  end

  test "scDhcpExtern debe ser false" do
    location = new_location_from_params
    old_dn = location.dn
    fresh_location = ScLocation.find(old_dn)
    assert_equal(false, location.scDhcpExtern)
  end


  test "Despues de crear el Container se debe crear el Branch" do
    location = new_location_from_params
    location.save
    branch = ScBranchServer.find("cn=branch_server,cn=server,#{location.dn}")
    assert_not_nil(branch)
  end

private
def new_location_from_params
  params = build_location_params[:scLocation]
  params[:cn] = @cn
  params[:parent] = @parent
  location = ScLocation.create_from_form(params)
end

end
