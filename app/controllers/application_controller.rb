class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  # Ensure user is logged in before accessing any pages within the site
  before_action :require_login

  # Redirects to login page if not logged in on page access
  def require_login
    unless logged_in?
      store_location
      flash[:danger] = 'Please login to continue.'
      redirect_to login_url
    end
  end

  # Can only access page if user is admin staff
  def require_admin_staff
    redirect_to root_url unless current_user.is?(:group, 4)
  end
end
