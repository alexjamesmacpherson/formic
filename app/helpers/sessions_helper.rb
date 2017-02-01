module SessionsHelper
  def login(user)
    session[:user_id] = user.id
  end

  def logout
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Returns true if user logged in
  def logged_in?
    !current_user.nil?
  end

  # Returns current logged-in user or nil
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        login user
        @current_user = user
      end
    end
  end

  # Remember user in persistent session using cookies
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Delete persistent session cookies to forget user
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
end
