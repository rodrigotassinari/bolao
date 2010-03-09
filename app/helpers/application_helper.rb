# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def admin_signed_in?
    user_signed_in? && current_user.admin?
  end
  
  def yes_or_no(value)
    value ? 'Sim' : 'Não'
  end
  
end

