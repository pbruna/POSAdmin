class BranchServerFactory

  #attr_accessor :location, :network_card, :enabled_services, :sc_location, :sc_networkcard

  def initialize(params)
    @network_card_params = params[:scLocation].delete(:scNetworkcard)
    @services_params = params[:scLocation].delete(:scService)
    @location_params = params[:scLocation]
    @id = params[:id] unless params[:id].nil?
  end

  def save
    sc_location = ScLocation.create_from_form(@location_params)
    sc_networkcard = ScNetworkCard.create_from_form(@network_card_params, sc_location)
    if sc_location.save && sc_networkcard.save
      services = ScService.create_or_update_from_form(@services_params, sc_location)
      sc_location
    else
      sc_location.delete_with_childrens! unless sc_location.nil?
      false
    end
  end



  def update
    sc_location = ScLocation.find(@id)
    sc_networkcard = sc_location.branch_server.network_card
    services = ScService.create_or_update_from_form(@services_params, sc_location)
    if sc_networkcard.update!(@network_card_params) 
      sc_location = sc_location.update_from_form(@location_params)
    else
      sc_networkcard.save
      false
    end
  end


  def destroy_location_and_branch_server
    sc_location = ScLocation.create(@sc_location.dn)
    server_container = sc_location.server_container
    branch_server = sc_location.branch_server
    branch_server.destroy && server_container.destroy && sc_location.destroy
  end

  def save_location_and_branch_server
    sc_location = new_location(@location)
    if sc_location
      server_container = new_server_container(sc_location.dn)
      if server_container
        branch_server = new_branch_server(server_container.dn)
        @sc_location = sc_location
        return false unless branch_server
      else
        sc_location.destroy
        return false
      end
      true
    else
      raise "Could not build ScLocation"
      return false
    end
  end

  private

    def find_sclocation(params)
      create("cn=#{params[:cn]},#{params[:parent]}")
    end

    def new_location(location)
      sc_location = ScLocation.create_new(location)
      unless sc_location.exists?
        sc_location.save
        sc_location
      else
        false
      end
    end

    def new_server_container(parent)
      server_container = ScServerContainer.create_default(parent)
      if server_container.save
        server_container
      else
        false
      end
    end

    def new_branch_server(parent)
      branch_server = ScBranchServer.create_default(parent)
      if branch_server.save
        branch_server
      else
        fale
      end
    end

end
