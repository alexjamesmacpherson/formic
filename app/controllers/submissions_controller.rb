class SubmissionsController < ApplicationController
  include ApplicationHelper

  def create
    @submission = current_user.submissions.build(submit_params)
    @assignment = Assignment.find(params[:submission][:assignment_id])
    @teachers = @assignment.subject.teachers

    if @submission.save
      @teachers.each do |teacher|
        notify(teacher, 'New homework submission', "Click here to view #{current_user.name}'s submission.", assignment_path(@assignment))
      end
      flash[:info] = "Your homework has been submitted - you'll get a notification when it's marked."
      redirect_to @assignment
    else
      flash[:danger] = 'Something went wrong, please try submitting your homework again.'
      redirect_to @assignment
    end
  end

  def edit
    @submission = Submission.find(params[:submission][:id])

    if @submission.update_attributes(submit_params)
      flash[:info] = "Your homework has been resubmitted - you'll get a notification when it's marked."
      redirect_to @submission.assignment
    else
      flash[:danger] = 'Something went wrong, please try submitting your homework again.'
      redirect_to @submission.assignment
    end
  end

  def mark
    @submission = Submission.find(params[:submission][:id])
    @pupil = @submission.pupil

    if @submission.update_attributes(mark_params)
      if @submission.marked
        notify(@pupil, 'Your homework has been remarked', 'Click here to view your amended submission.', assignment_path(@submission.assignment))
        @pupil.parents.each do |parent|
          notify(parent, "Your child's homework has been remarked", 'Click here to view the amended submission.', assignment_path(@submission.assignment))
        end
      else
        notify(@pupil, 'Your homework has been marked', 'Click here to view your marked submission.', assignment_path(@submission.assignment))
        @pupil.parents.each do |parent|
          notify(parent, "Your child's homework has been marked", 'Click here to view the marked submission.', assignment_path(@submission.assignment))
        end
      end

      @submission.marked = true
      @submission.marker = current_user
      @submission.marked_at = Time.zone.now
      @submission.save
    end
  end

private

  def submit_params
    params.require(:submission).permit(:assignment_id, :file)
  end

  def mark_params
    params.require(:submission).permit(:feedback, :grade)
  end
end
