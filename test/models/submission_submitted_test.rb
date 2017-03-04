require 'test_helper'

class SubmissionSubmittedTest < ActiveSupport::TestCase
  def setup
    @assignment = assignments(:test_assignment)
    @pupil = users(:test_user)

    @submission = Submission.new(assignment: @assignment, pupil: @pupil, file: File.open(file_fixture('logo-v.jpg')), submitted: true, submitted_at: Time.zone.now)
  end

  test 'submission is valid and can be saved' do
    assert @submission.valid?
    assert @submission.save
  end

  test 'submitted file cannot be nil' do
    @submission.file = nil
    assert_not @submission.valid?
    assert_not @submission.save
  end

  test 'uploaded file is correct file' do
    assert_equal 'logo-v.jpg', @submission.file.filename
  end

  test 'submission must have submission datetime' do
    @submission.submitted_at = nil
    assert_not @submission.valid?
  end
end
