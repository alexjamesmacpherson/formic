class SchoolsController < ApplicationController
  # Catch school record not found exception
  rescue_from ActiveRecord::RecordNotFound, :with => :school_not_found
  def school_not_found
    flash[:danger] = 'School not found.'
    redirect_to schools_url
  end

  def index
    @schools = School.all.paginate(page: params[:page], :per_page => 20)
  end

  def show
    @school = School.find(params[:id])
  end

  def new
    @school = School.new
  end

  def create
    @school = School.new(school_params)
    if @school.save
      flash[:success] = "#{@school.name} has been created successfully!"
      redirect_to @school
    else
      render 'new'
    end
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
    params.require(:school).permit(:name, :address, :phone_number, :motto)
  end
end
