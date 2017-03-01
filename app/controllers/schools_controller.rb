class SchoolsController < ApplicationController
  # Catch school record not found exception
  rescue_from ActiveRecord::RecordNotFound, :with => :school_not_found
  def school_not_found
    flash[:danger] = 'School not found.'
    redirect_to root_url
  end

  # Schools can only be edited by admin staff
  before_action :require_admin_staff, only: [:edit, :update]
  # Pages can only be accessed by users from the same school
  before_action :require_same_school

  def show
    @school = School.find(params[:id])
  end

  def edit
    @school = School.find(params[:id])
  end

  def update
    @school = School.find(params[:id])
    if @school.update_attributes(school_params)
      flash[:success] = "Information for #{@school.name} has been updated successfully!"
      redirect_to @school
    else
      render 'edit'
    end
  end

private

  def school_params
    params.require(:school).permit(:name, :address, :phone, :motto)
  end

  # Redirect to show user's school if trying to access another school
  def require_same_school
    @school = School.find(params[:id])
    redirect_to school_url(current_user.school_id) unless current_user.school_id == @school.id
  end
end
