class UsersController < ApplicationController
  # Catch user record not found exception
  rescue_from ActiveRecord::RecordNotFound, :with => :user_not_found
  def user_not_found
    flash[:danger] = 'User not found.'
    redirect_to users_url
  end

  def index
    @school = School.first # WILL BE SET TO CURRENT SCHOOL ONCE LOGIN IS COMPLETE
    @users = @school.users.paginate(page: params[:page], :per_page => 20)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @school = School.first # WILL BE SET TO CURRENT SCHOOL ONCE LOGIN IS COMPLETE
    @user = @school.users.build
  end

  def create
    @school = School.first # WILL BE SET TO CURRENT SCHOOL ONCE LOGIN IS COMPLETE
    @user = @school.users.build(user_params)
    if @user.save
      flash[:success] = "#{@user.name}'s account has been created successfully!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "#{@user.name}'s profile has been updated successfully!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:info] = "#{@user.name}'s account and all their associated records have been removed."
    redirect_to users_url
  end

private

  def user_params
    params.require(:user).permit(:email, :user_group, :name, :address, :bio)
  end
end
