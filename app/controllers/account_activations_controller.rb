class AccountActivationsController < ApplicationController
  skip_before_action :require_login

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      login user
      flash[:success] = 'Account activated, welcome to Formic Learning!'
      redirect_to user
    else
      flash[:danger] = 'Invalid activation link.'
      redirect_to root_url
    end
  end
end
