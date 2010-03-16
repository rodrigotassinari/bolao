# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation
  
  before_filter :adjust_format_for_iphone

  protected
  
    # before_filter
    def require_admin!
      unless current_user.admin?
        flash[:notice] = "Acesso não permitido"
        redirect_to root_path
      end
    end
    
    # before_filter
    # Set iPhone format if request came from iphone subdomain
    def adjust_format_for_iphone
      request.format = :iphone if iphone_request?
      request.format = :iphone_js if request.xhr? && iphone_request?
    end
    
    # Return true for requests to m.bolao.pittlandia.net
    def iphone_request?
      return (request.subdomains.first == "m" || params[:format] == "iphone" || params[:format] == "iphone_js")
    end

end

