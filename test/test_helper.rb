ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  #fixtures :all

  # Add more helper methods to be used by all tests here...

   def build_location_params
  	@branch_server_dn="cn=branch_server,cn=server,cn=testing,ou=santiago,o=cruzverde,c=cl"
  	enabled_services = {
  		:dchp => true,
  		:dns => false,
  		:tftp => true
  	}
  	network_card = {
  		:ipHostNumber => "192.168.1.2",
  		:scDevice => "eth0"
  	}
  	sc_location = {
  		:parent => "ou=santiago,o=cruzverde,c=cl",
  		:cn => "testing",
  		:ipNetworkNumber => "192.168.1.0",
  		:ipNetmaskNumber => "255.255.255.0",
      :scDefaultGw => "192.168.1.1",
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
    @params = { :scLocation => sc_location}
  end

  def build_location_update_params
    sc_location = {
      :parent => "ou=santiago,o=cruzverde,c=cl",
      :cn => "testing",
      :ipNetworkNumber => "192.168.2.0",
      :ipNetmaskNumber => "255.255.255.0",
      :scDefaultGw => "192.168.2.1",
      :scDhcpRange_start => "192.168.2.100",
      :scDhcpRange_end => "192.168.2.110",
      :scDhcpFixedRange_start => "192.168.2.200",
      :scDhcpFixedRange_end => "192.168.2.210",
      :scDynamicIp => false,
      :scDhcpExtern => true,
      :userPassword => "suse.11",
      :scEnumerationMask => "01",
      :scWorkstationBaseName => "CK",
    }
    params = { :scLocation => sc_location}
  end

  def destroy_location
    sclocation = ScLocation.find("cn=testing,ou=santiago,o=cruzverde,c=cl")
    sclocation.delete_with_childrens! unless sclocation.nil?
  end

end
