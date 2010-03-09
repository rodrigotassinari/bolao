# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation

  protected
  
    # before_filter
    def require_admin!
      unless current_user.admin?
        flash[:notice] = "Acesso não permitido"
        redirect_to root_path
      end
    end

end

