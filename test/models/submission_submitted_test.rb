require 'test_helper'

class SubmissionSubmittedTest < ActiveSupport::TestCase
  def setup
    @assignment = assignments(:test_assignment)
    @pupil = users(:test_user)
    @submission = Submission.new(assignment: @assignment, pupil: @pupil, file: User.new_token, submitted: true, submitted_at: Time.zone.now)
  end

  test 'submission is valid and can be saved' do
    assert @submission.valid?
    assert @submission.save
  end

  test 'submitted file cannot be nil and cannot exceed 255 chars (token length)' do
    invalid_names = [nil, '', 'a' * 256]
    invalid_names.each do |invalid|
      @submission.file = invalid
      assert_not @submission.valid?, "#{invalid.inspect} should not be a valid file token"
    end
  end

  test 'submission must have submission datetime' do
    @submission.submitted_at = nil
    assert_not @submission.valid?
  end
end
