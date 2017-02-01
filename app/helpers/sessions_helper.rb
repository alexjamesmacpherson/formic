module SessionsHelper
  def login(user)
    session[:user_id] = user.id
  end

  # Returns current logged-in user or nil
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # Returns true if user logged in
  def logged_in?
    !current_user.nil?
  end

  def logout
    session.delete(:user_id)
    @current_user = nil
  end
end
