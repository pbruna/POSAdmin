require 'test_helper'

class ScNetworkCardTest < ActiveSupport::TestCase

  setup do
    @dn = "cn=local58,ou=santiago,o=cruzverde,c=cl"
    @sc_location = create_location
    @params = {
      :ipHostNumber => "192.168.1.2",
      :scDevice => "test"
    }
  end

  teardown do
    network_card = ScNetworkCard.filter(:scDevice => "test").first
    network_card.destroy unless network_card.nil?
    updated_network_card = ScNetworkCard.filter(:scDevice => "test2").first
    updated_network_card.destroy unless updated_network_card.nil?
    sc_location = ScLocation.filter(:cn => "local58").first
    sc_location.delete_with_childrens! unless sc_location.nil?
  end

  test "Se debe crear nueva tarjeta de red" do
    network_card = ScNetworkCard.create_from_form(@params,@sc_location)
    assert(network_card.save, "Failure message.")
  end

  test "Se debe actualizar ipHostNumber" do
    network_card = ScNetworkCard.create_from_form(@params,@sc_location)
    network_card.save
    params = {:ipHostNumber => "192.168.1.3", :scDevice => "test"}
    updated_network_card = network_card.update!(params)
    assert_not_equal(network_card.ipHostNumber, updated_network_card.ipHostNumber)
  end

  test "Se debe mover la tarjeta si cambia el nombre del dispositivo" do
    network_card = ScNetworkCard.create_from_form(@params,@sc_location)
    network_card.save
    params = {:ipHostNumber => "192.168.1.3", :scDevice => "test2"}
    updated_network_card = network_card.update!(params)
    assert_not_equal(network_card.dn, updated_network_card.dn)
  end

  private
  def create_location
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
    sc_location
  end
end
