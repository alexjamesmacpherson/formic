class SubjectsController < ApplicationController
  def show
    @subject = Subject.find(params[:id])
    case current_user.group
      when 1
      when 2
      else
        @relations = @subject.pupils
        @relation_name = 'Students'
    end
  end
end
