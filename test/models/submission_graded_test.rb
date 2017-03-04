require 'test_helper'

class SubmissionGradedTest < ActiveSupport::TestCase
  def setup
    @assignment = assignments(:test_assignment)
    @pupil = users(:test_user)
    @teacher = users(:test_teacher)
    @submission = Submission.new(assignment: @assignment, pupil: @pupil, file: File.open(file_fixture('logo-v.jpg')), submitted: true, submitted_at: Time.zone.now, marker: @teacher, marked: true, marked_at: Time.zone.now, feedback: 'This is some test feedback.', grade: 50)
  end

  test 'submission is valid and can be saved' do
    assert @submission.valid?
    assert @submission.save
  end

  test 'marked submission must have marker' do
    @submission.marker = nil
    assert_not @submission.valid?
  end

  test 'marked submission cannot have non-existent marker' do
    assert User.exists?(@submission.marker_id)
    assert_not User.exists?(10)

    @submission.marker_id = 10
    assert_not @submission.valid?
  end

  test 'marker must have correct user group' do
    @teacher.update_attribute(:group, 1)
    assert_not @submission.valid?
    assert_not @submission.save
  end

  test 'marked submission must have marking datetime' do
    @submission.marked_at = nil
    assert_not @submission.valid?
  end

  test 'submission grade must be a number between 0 and 100' do
    valid_grades = [0, 55, 100]
    valid_grades.each do |valid|
      @submission.grade = valid
      assert @submission.valid?, "#{valid.inspect} should be a valid grade"
    end

    invalid_grades = [nil, 101, -1, 1000]
    invalid_grades.each do |invalid|
      @submission.grade = invalid
      assert_not @submission.valid?, "#{invalid.inspect} should not be a valid grade"
    end
  end

  test 'submission feedback valid even if blank' do
    valid_feedback = ['', 'a', 'a' * 255, 'a' * 1000]
    valid_feedback.each do |feedback|
      @submission.feedback = feedback
      assert @submission.valid?, "#{feedback.inspect} should be a valid submission feedback"
    end
  end
end
