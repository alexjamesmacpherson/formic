class SubjectsController < ApplicationController
  def show
    @subject = Subject.find(params[:id])
    case current_user.group
      when 1
        @relations = @subject.assignments.where('due > ?', DateTime.now).order(:due)
        @relation_name = 'Upcoming Homework'
      when 2
        @relations = @subject.assignments.where('due > ?', DateTime.now).order(:due)
        @relation_name = "Child's Homework"
      else
        @relations = @subject.pupils
        @relation_name = 'Students'
    end
  end
end
