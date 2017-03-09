class AssignmentsController < ApplicationController
  def show
    @assignment = Assignment.find(params[:id])
    case current_user.group
      when 1
        @submission = @assignment.submissions.where(pupil_id: current_user.id).first
      else
        @class = @assignment.subject.pupils.order(:name)
    end
  end

  def index
    @pending = []
    @past = []

    case current_user.group
      when 1
        @title = 'Your Homework'
        current_user.studies.each do |subject|
          @pending = @pending + subject.assignments.where('due > ?', DateTime.now)
        end

        current_user.studies.each do |subject|
          @past = @past + subject.assignments.where('due <= ?', DateTime.now)
        end
      when 2
        @title = "Your Children's Homework"
        current_user.children.each do |child|
          child.studies.each do |subject|
            @pending = @pending + subject.assignments.where('due > ?', DateTime.now)
          end

          child.studies.each do |subject|
            @past = @past + subject.assignments.where('due <= ?', DateTime.now)
          end
        end
      when 3
        @title = 'Homework Set'
        current_user.teaches.each do |subject|
          @pending = @pending + subject.assignments.where('due > ?', DateTime.now)
        end

        current_user.teaches.each do |subject|
          @past = @past + subject.assignments.where('due <= ?', DateTime.now)
        end
    end

    @pending.sort!{ |a, b| a.due <=> b.due }
    @past.sort!{ |a, b| b.due <=> a.due }
  end
end
