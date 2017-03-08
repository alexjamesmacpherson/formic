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
    if params.has_key?(:search) && !params[:search].strip.blank?
      @users = current_user.school.users.where(activated: true).where('LOWER(name) LIKE LOWER(?) OR LOWER(email) LIKE LOWER(?)', "%#{params[:search]}%", "%#{params[:search]}%").order(:name).paginate(page: params[:page], :per_page => 10)
      @title = "Results For \"#{params[:search]}\""
    else
      @users = current_user.school.users.where(activated: true).order(:name).paginate(page: params[:page], :per_page => 10)
      @title = 'All Users'
    end
  end

  def show
    @user = User.find(params[:id])
    unless @user.activated?
      flash[:danger] = 'User not found.'
      redirect_to users_url
      return
    end
    @relations = @user.parents + @user.children
    @relations.sort! { |a, b| a.name <=> b.name }

    @lessons = []
    @assignments = []
    case @user.group
      when 1
        lessons_assignments_for(@user.studies)
      when 2
        @user.children.each do |child|
          lessons_assignments_for(child.studies)
        end
      when 3
        lessons_assignments_for(@user.teaches)
    end
  end

  def new
    @user = current_user.school.users.new
    @years = current_user.school.year_groups.order(:name)
  end

  def create
    @years = current_user.school.year_groups.order(:name)
    @user = current_user.school.users.build(new_user_params)

    if params[:user][:group] == '1' && params[:user][:year_group_id] == '-1' && params[:user].has_key?(:new_year_group) && !params[:user][:new_year_group].blank?
      @user.year_group = current_user.school.year_groups.create!(name: params[:user][:new_year_group])
    end

    @user.year_group = nil unless @user.group == 1

    # Set random password on user creation
    random_password = User.new_token
    @user.password = random_password
    @user.password_confirmation = random_password

    @user.tutor_id = nil unless @user.group == 1

    if @user.save
      case @user.group
        when 1
          params[:parent_ids].each do |parent|
            @user.parent_relations.create!(parent_id: parent)
          end unless params[:parent_ids].blank?
        when 2
          params[:student_ids].each do |child|
            @user.child_relations.create!(child_id: child)
          end unless params[:student_ids].blank?
        when 3
          params[:student_ids].each do |pupil|
            student = User.find(pupil)
            student.tutor = @user
            student.save!
          end unless params[:student_ids].blank?
      end

      @user.send_activation_email
      flash[:info] = "Account created: #{@user.name} has been sent an email to activate their account."
      redirect_to new_user_url
    else
      @parent_cache = params[:parent_ids]
      @student_cache = params[:student_ids]
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
    params.require(:user).permit(:email, :group, :year_group_id, :name, :tutor_id)
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

  def lessons_assignments_for(subjects)
    subjects.each do |subject|
      @lessons = @lessons + subject.lessons
      @assignments = @assignments + subject.assignments.where('due > ?', DateTime.now)
    end
    @assignments.sort!{ |a, b| a.due <=> b.due }
    if @assignments.length > 10
      @assignments = @assignments[0..9]
    end
  end
end
