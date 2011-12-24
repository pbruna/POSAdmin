class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :render_sidebar
  
  private
  def render_sidebar
    @ous = OrganizationalUnit.all
  end
  
end
