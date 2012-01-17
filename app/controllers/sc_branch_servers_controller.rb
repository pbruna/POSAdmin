class ScBranchServersController < ApplicationController
  before_filter :initialize_branchserver_factory, :only => [:create, :update]

  def index
    @branch_servers = ScBranchServer.all
  end

  def show
    @branch_server = ScLocation.create(params[:id])
    logger.debug(@branch_server)
  end

  def new
    @scLocation = Class.new do
      def self.method_missing(method,value)
        nil
      end
    end
    @organizational_unit_collection = OrganizationalUnit.for_select
  end

  def edit
    @scLocation = ScLocation.create(params[:id])
    @organizational_unit_collection = OrganizationalUnit.for_select
  end

  def create    
    if @branch_server_factory.save
      flash[:notice] = "Branch Server created!"
      redirect_to scbranchserver_path(@branch_server_factory.location_dn)
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

  def update
    if @branch_server_factory.update
      flash[:notice] = "Branch Server updated correctly"
      redirect_to scbranchserver_path(@branch_server_factory.sc_location.dn)
    else
      flash[:error] = "Error while updating Branch Server"
      redirect_to organizational_units_path
    end
  end

  private
  def initialize_branchserver_factory
    @branch_server_factory = BranchServerFactory.new(params)
  end

end
