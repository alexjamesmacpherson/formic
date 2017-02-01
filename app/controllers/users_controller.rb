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
    @users = @school.users.paginate(page: params[:page], :per_page => 20)
  end

  def show
    @user = User.find(params[:id])
    case @user.user_group
      when 1
        @relations = get_parents(@user.id)
        @tutor = get_tutor(@user.id)
      when 2
        @relations = get_children(@user.id)
      when 3
        @relations = get_tutees(@user.id)
    end
  end

  def new
    @school = School.find(current_user.school_id)
    @user = @school.users.build
  end

  def create
    @school = School.find(current_user.school_id)
    @user = @school.users.build(new_user_params)
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
    params.require(:user).permit(:email, :name, :address, :bio, :password, :password_confirmation)
  end

  def new_user_params
    params.require(:user).permit(:email, :user_group, :name, :password, :password_confirmation)
  end

  # Can only edit/update your own records (admin staff can edit anyone's records)
  def require_correct_user
    @user = User.find(params[:id])
    redirect_to root_url unless current_user?(@user) || current_user.user_group == 4
  end

  # Can only view/manipulate users within the same school
  def require_same_school
    @user = User.find(params[:id])
    if @user.school_id != current_user.school_id
      flash[:danger] = 'User not found.'
      redirect_to users_url
    end
  end

  def get_parents(id)
    parents = []
    relations = Parent.where(child_id: id)
    if relations
      relations.each do |parent|
        parents << User.find(parent.parent_id)
      end
    end
    return parents
  end

  def get_children(id)
    children = []
    relations = Parent.where(parent_id: id)
    if relations
      relations.each do |child|
        children << User.find(child.child_id)
      end
    end
    return children
  end

  def get_tutor(id)
    tutor = Tutor.find_by(pupil_id: id)
    if tutor
      User.find_by(id: tutor.tutor_id)
    end
  end

  def get_tutees(id)
    tutees = []
    relations = Tutor.where(tutor_id: id)
    if relations
      relations.each do |pupil|
        tutees << User.find(pupil.pupil_id)
      end
    end
    return tutees
  end
end
