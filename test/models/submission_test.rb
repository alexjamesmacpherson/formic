require 'test_helper'

class SubmissionTest < ActiveSupport::TestCase
  def setup
    @assignment = assignments(:test_assignment)
    @pupil = users(:test_user)
    @teacher = users(:test_teacher)
    @submission = Submission.new(assignment: @assignment, pupil: @pupil)
  end

  test 'submission is valid and can be saved' do
    assert @submission.valid?
    assert @submission.save
  end

  test 'duplicate submissions cannot exist' do
    @duplicate = @submission.dup
    @submission.save
    assert_not @duplicate.save
    assert_not @duplicate.valid?
  end

  test 'submission must have assignment' do
    @submission.assignment = nil
    assert_not @submission.valid?
  end

  test 'submission cannot have non-existent assignment' do
    assert Assignment.exists?(@submission.assignment_id)
    assert_not Assignment.exists?(10)

    @submission.assignment_id = 10
    assert_not @submission.valid?
  end

  test 'submission must have pupil' do
    @submission.pupil = nil
    assert_not @submission.valid?
  end

  test 'submission cannot have non-existent pupil' do
    assert User.exists?(@submission.pupil_id)
    assert_not User.exists?(10)

    @submission.pupil_id = 10
    assert_not @submission.valid?
  end

  test 'submission pupil must have correct user group' do
    @pupil.update_attribute(:group, 3)
    assert_not @submission.valid?
    assert_not @submission.save
  end
end
