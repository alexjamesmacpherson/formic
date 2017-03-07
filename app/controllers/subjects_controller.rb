class SubjectsController < ApplicationController
  def show
    @subject = Subject.find(params[:id])
    case current_user.group
      when 1
        @relations = @subject.assignments
        @relation_name = 'Assignments'
      when 2
        @relations = @subject.assignments
        @relation_name = "Child's Assignments"
      else
        @relations = @subject.pupils
        @relation_name = 'Students'
    end
  end
end
