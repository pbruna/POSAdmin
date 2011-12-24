class ScBranchServersController < ApplicationController
  
  def show
    @branch_server = ScBranchServer.create(params[:id])
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
    @scLocation = ScLocation.create_new(params[:scLocation])
    if @scLocation.save
      server_container = ScServerContainer.create_default(@scLocation.dn)
      ScBranchServer.create_default(server_container.dn)
      redirect_to controlcenter_path
    else
      format.html { render :action => "new"}
    end
  end
  
end
