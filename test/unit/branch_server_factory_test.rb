require 'test_helper'

class BranchServerFactoryTest < ActiveSupport::TestCase

  setup do
  	build_location_params
  end
  
  teardown do
   destroy_location
   sc_location_updated = ScLocation.find("cn=testeandolo,ou=santiago,o=cruzverde,c=cl")
   sc_location_updated.delete_with_childrens! unless sc_location_updated.nil?
  end


  test "Se debe crear un nuevo location" do
    branch_server_factory = BranchServerFactory.new(@params)
    assert(branch_server_factory.save, "Failure message.")
  end

  test "Se debe actualizar con cambios solo de atributos" do
    branch_server_factory = BranchServerFactory.new(@params)
    location_old = branch_server_factory.save
    branch_server_factory = BranchServerFactory.new(new_params)
    location_new = branch_server_factory.update
    assert_not_equal(location_old.dn, location_new.dn)
    #assert_not_equal(location_old.network_card_dn, location_new.network_card_dn)
    #assert_not_equal(location_old.services[:dhcp], location_new.services[:dhcp])
  end

  private
  def new_params
    enabled_services = {
      :dchp => false,
      :dns => false,
      :tftp => true
    }
    network_card = {
      :ipHostNumber => "192.168.1.3",
      :scDevice => "eth1"
    }
    sc_location = {
      :parent => "ou=santiago,o=cruzverde,c=cl",
      :cn => "testeandolo",
      :ipNetworkNumber => "192.168.1.0",
      :ipNetmaskNumber => "255.255.255.0",
      :scDefaultGw => "192.168.1.2",
      :scDhcpRange_start => "192.168.1.100",
      :scDhcpRange_end => "192.168.110",
      :scDhcpFixedRange_start => "192.168.200",
      :scDhcpFixedRange_end => "192.168.210",
      :scDynamicIp => true,
      :scDhcpExtern => false,
      :userPassword => "suse.10",
      :scEnumerationMask => "00",
      :scWorkstationBaseName => "CR",
      :scNetworkcard => network_card,
      :scService => enabled_services
    }
    params = { :scLocation => sc_location, :id => "cn=testing,ou=santiago,o=cruzverde,c=cl"}
  end


end