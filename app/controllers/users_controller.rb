class UsersController < ApplicationController
  # Catch user record not found exception
  rescue_from ActiveRecord::RecordNotFound, :with => :user_not_found
  def user_not_found
    flash[:danger] = 'User not found.'
    redirect_to users_url
  end

  # Ensure user is correct user before editing/updating any accounts
  before_action :require_correct_user,  only: [:edit, :update]
  # Users can only be added/removed by admin staff
  before_action :require_admin_staff,   only: [:new, :create, :destroy]
  # Users can only view and interact with other users from their school
  before_action :require_same_school,   only: [:show, :edit, :update, :destroy]

  def index
    @school = School.find(current_user.school_id)
    @users = @school.users.where(activated: true).paginate(page: params[:page], :per_page => 20)
  end

  def show
    @user = User.find(params[:id])
    unless @user.activated?
      flash[:danger] = 'User not found.'
      redirect_to users_url
    end
    @relations = @user.parents + @user.children + @user.tutees
  end

  def new
    @school = School.find(current_user.school_id)
    @user = @school.users.build
  end

  def create
    @school = School.find(current_user.school_id)
    @user = @school.users.build(new_user_params)

    # Set random password on user creation
    random_password = User.new_token
    @user.password = random_password
    @user.password_confirmation = random_password

    if @user.save
      @user.send_activation_email
      flash[:info] = "Account created: #{@user.name} has been sent an email to activate their account."
      redirect_to new_user_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(edit_user_params)
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

  def edit_user_params
    params.require(:user).permit(:email, :name, :bio, :password, :password_confirmation, :avatar, :avatar_cache, :remove_avatar)
  end

  def new_user_params
    params.require(:user).permit(:email, :group_id, :year_group_id, :name)
  end

  # Can only edit/update your own records (admin staff can edit anyone's records)
  def require_correct_user
    @user = User.find(params[:id])
    redirect_to root_url unless current_user?(@user) || current_user.is?(:group, 4)
  end

  # Can only view/manipulate users within the same school
  def require_same_school
    @user = User.find(params[:id])
    unless @user.is?(:school_id, current_user.school_id)
      flash[:danger] = 'User not found.'
      redirect_to users_url
    end
  end
end
