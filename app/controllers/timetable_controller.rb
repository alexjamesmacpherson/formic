class TimetableController < ApplicationController
  def index
    @lessons = []
    case current_user.group
      when 1
        current_user.studies.each do |subject|
          @lessons = @lessons + subject.lessons
        end
      when 2
        current_user.children.each do |child|
          child.studies.each do |subject|
            @lessons = @lessons + subject.lessons
          end
        end
      when 3
        current_user.teaches.each do |subject|
          @lessons = @lessons + subject.lessons
        end
      else
        redirect_to current_user
    end
  end
end
