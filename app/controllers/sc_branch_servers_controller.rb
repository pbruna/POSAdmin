class ScBranchServersController < ApplicationController

  def index
    @branch_servers = ScBranchServer.all
  end

  def show
    @branch_server = ScLocation.create(params[:id])
    logger.debug(@branch_server)
  end

  def new
    @scLocation = Class.new
    @organizational_unit_collection = OrganizationalUnit.for_select
  end

  def edit
    @scLocation = ScLocation.create(params[:id])
    @organizational_unit_collection = OrganizationalUnit.for_select
  end

  def create
    network_card = params[:scLocation].delete("scNetworkcard")
    @scLocation = ScLocation.create_new(params)
    @scNetworkCard = ScNetworkCard.create_new(network_card,@scLocation)
    if @scLocation.save && @scNetworkCard.save && ScService.create_and_save(params[:scService],@scLocation)
      flash[:notice] = "Branch Server created!"
      redirect_to scbranchserver_path(@scLocation.dn)
    else
      format.html { render :action => "new"}
    end
  end
  
  def destroy
    @scLocation = ScLocation.create(params[:id])
    if @scLocation.delete_with_childrens!
      flash[:notice] = "Branch Server and all POS Devices Deleted!"
      redirect_to organizational_unit_path(@scLocation.parent)
    else
      flash[:error] = "An Error ocurred while trying to delete Branch Server"
      redirect_to scbranchserver_path(@scLocation.dn)
    end
  end

end
