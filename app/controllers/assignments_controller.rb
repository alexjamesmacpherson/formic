class AssignmentsController < ApplicationController
  def show
    @assignment = Assignment.find(params[:id])
  end

  def index
    @assignments = []
    current_user.studies.each do |subject|
      @assignments = @assignments + subject.assignments.where('due > ?', DateTime.now)
    end
    @assignments.sort!{ |a, b| a.due <=> b.due }
  end
end
