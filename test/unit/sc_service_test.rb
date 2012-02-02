require 'test_helper'

class ScServiceTest < ActiveSupport::TestCase

  setup do
    @dn = "cn=local58,ou=santiago,o=cruzverde,c=cl"
    @sc_location = create_location
    @params = {
      :dchp => true,
      :dns => true
    }
  end

  teardown do
    sc_location = ScLocation.find("cn=local58,ou=santiago,o=cruzverde,c=cl")
    sc_location.delete_with_childrens! unless sc_location.nil?
  end

  test "Se deben crear los 3 servicios por defecto como false" do
    services = ScService.create_or_update_from_form({}, @sc_location)
    assert_equal(3, services.size)
  end

  test "Se deben crear los servicios con los valores de params" do
    services = ScService.create_or_update_from_form(@params, @sc_location)
    assert(services[:dns].scServiceStatus, "Failure message.")
  end

  test "Se debe actualizar el servicio" do
    services = ScService.create_or_update_from_form(@params, @sc_location)
    status_tftp_old = services[:tftp].scServiceStatus
    services = ScService.create_or_update_from_form({:tftp => true}, @sc_location)
    status_tftp_new = services[:tftp].scServiceStatus
    assert_not_equal(status_tftp_new, status_tftp_old)
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
