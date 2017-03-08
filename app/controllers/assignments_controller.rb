class AssignmentsController < ApplicationController
  def show
    @assignment = Assignment.find(params[:id])
  end

  def index
    @pending = []
    @past = []

    current_user.studies.each do |subject|
      @pending = @pending + subject.assignments.where('due > ?', DateTime.now)
    end

    current_user.studies.each do |subject|
      @past = @past + subject.assignments.where('due <= ?', DateTime.now)
    end

    @pending.sort!{ |a, b| a.due <=> b.due }
    @past.sort!{ |a, b| b.due <=> a.due }
  end
end
