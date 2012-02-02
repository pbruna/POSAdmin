class OrganizationalUnitsController < ApplicationController
  
  def index
    @organizational_units = OrganizationalUnit.all
  end
  
  def show
    @organizational_unit = OrganizationalUnit.find(params[:id])
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
     @organizational_unit = OrganizationalUnit.find(params[:id])
      if @organizational_unit.update_attributes(params[:organizational_unit])
        flash[:notice] = "Changes Saved!"
        redirect_to organizational_unit_path(@organizational_unit.dn)
      else
        render :action => "edit"
      end
  end
  
  def new
    @organizational_unit = Class.new
  end
  
  def destroy
    @organizational_unit = OrganizationalUnit.find(params[:id])
    if @organizational_unit.remove_only_if_empty
      flash[:notice] = "Organizational Unit Deleted!"
      redirect_to organizational_units_path
    else
      flash[:alert] = "Organizational Unit is not Empty!"
      redirect_to organizational_unit_path(@organizational_unit)
    end
  end
  
end
