class ControlcentersController < ApplicationController

  def show
    @ous = OrganizationalUnit.all
  end

end
