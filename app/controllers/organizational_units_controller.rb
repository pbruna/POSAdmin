class OrganizationalUnitsController < ApplicationController
  def index
    @organizational_units = OrganizationalUnit.all
  end
  
  def show
    @organizational_unit = OrganizationalUnit.create(params[:id])
  end
  
  def edit
    @organizational_unit = OrganizationalUnit.find(params[:id])
  end
  
  def create
    @organizational_unit = OrganizationalUnit.create_new(params[:organizational_unit])
    if @organizational_unit.save
      redirect_to organizational_unit_path(@organizational_unit.dn)
    else
      render :action => "new"
    end
  end
  
  def update
     @organizational_unit = OrganizationalUnit.create_new(params[:organizational_unit])
      if @organizational_unit.save
        flash[:notice] = "Changes Saved!"
        redirect_to organizational_unit_path(@organizational_unit.dn)
      else
        render :action => "new"
      end
  end
  
  def new
    @organizational_unit = Class.new
  end
  
end
