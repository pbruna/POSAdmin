class BranchServerFactory

  attr_accessor :location, :network_card, :enabled_services, :sc_location

  def initialize(params)
    @network_card = params[:scLocation].delete("scNetworkcard")
    @enabled_services = params[:scLocation].delete("scService")
    @location = params[:scLocation]
    @sc_location = ScLocation.create(params[:id]) if params[:id]
    @attributes = ScLocation.build_attributes(@location)
  end

  def location_dn
    @sc_location.dn
  end


  def update
    @sc_networkcard = ScNetworkCard.create(@sc_location.network_card_dn)
    @sc_networkcard.update!(@network_card)
    @sc_location.update!(@attributes)
    ScService.create_and_save(@enabled_services,@sc_location)
  end


  def save
    if self.save_location_and_branch_server
      network_card = ScNetworkCard.create_new(@network_card,@sc_location)
      if network_card.save
        if ScService.create_and_save(@enabled_services,@sc_location)
          return true
        else
          network_card.destroy
          self.destroy_location_and_branch_server
          return false
        end
      else
        self.destroy_location_and_branch_server
        return false
      end
    else
      return false
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
        fale
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
