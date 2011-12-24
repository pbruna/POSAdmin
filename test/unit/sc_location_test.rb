require 'test_helper'

class ScLocationTest < ActiveSupport::TestCase

  setup do
    @dn = "cn=local57,ou=santiago,o=cruzverde,c=cl"
  end

  teardown do
    sc_location = ScLocation.filter(:cn => "local57").first
    sc_location.destroy unless sc_location.nil?
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
                           :scDhcpExtern => "FALSE",
                           :userPassword => "suse.10"
                           )
    sc_location.save
    assert(sc_location.object_class.include?("top"), "No se agrego la objectClass top")
  end
  
  test "ScLocations#branch_servers debe devolver un array con los servidores" do
    location = ScLocation.all.first
    branch_servers = location.branch_servers
    assert(branch_servers.kind_of?(Array), "branch_servers debe ser un Array")
  end


end
