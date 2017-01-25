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
