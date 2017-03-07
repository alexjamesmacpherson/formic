class TimetableController < ApplicationController
  def index
    @lessons = []
    @assignments = []
    case current_user.group
      when 1
        lessons_assignments_for(current_user.studies)
      when 2
        current_user.children.each do |child|
          lessons_assignments_for(child.studies)
        end
      when 3
        lessons_assignments_for(current_user.teaches)
      else
        redirect_to current_user
    end
  end

  def lessons_assignments_for(subjects)
    subjects.each do |subject|
      @lessons = @lessons + subject.lessons
      @assignments = @assignments + subject.assignments
    end
    @assignments.sort!{ |b, a| a.created_at <=> b.created_at }
  end
end
