require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  def setup
    @class = subjects(:test_subject)
    @assignment = Assignment.new(subject: @class, name: 'Assignment X', information: 'This is a test assignment!', due: Time.zone.now)
  end

  test 'assignment is valid and can be saved' do
    assert @assignment.valid?
    assert @assignment.save
  end

  test 'expected name must exist and cannot be blank or exceed 255 chars' do
    valid_names = ['a', 'a' * 255]
    valid_names.each do |valid|
      @assignment.name = valid
      assert @assignment.valid?, "#{valid.inspect} should be a valid assignment name"
    end

    invalid_names = [nil, '', 'a' * 256]
    invalid_names.each do |invalid|
      @assignment.name = invalid
      assert_not @assignment.valid?, "#{invalid.inspect} should not be a valid assignment name"
    end
  end

  test 'assignment must have subject' do
    @assignment.subject = nil
    assert_not @assignment.valid?
  end

  test 'assignment cannot have non-existent subject' do
    assert Subject.exists?(@assignment.subject_id)
    assert_not Subject.exists?(10)

    @assignment.subject_id = 10
    assert_not @assignment.valid?
  end

  test 'assignment information can be a string of any length, including empty' do
    information = [nil, '', 'a', 'a' * 1000]
    information.each do |valid|
      @assignment.information = valid
      assert @assignment.valid?, "#{valid.inspect} should be a valid assignment information entry"
    end
  end

  test 'assignment due date must exist' do
    @assignment.due = nil
    assert_not @assignment.valid?
  end

  test 'class can fetch assignments directly from self with has_many assignment' do
    @assignment.save
    @class.assignments.each do |assignment|
      assert_equal 'Assignment X', assignment.name
      assert_equal 'This is a test assignment!', assignment.information
    end

    @assignment.name = 'Test Assignment'
    @assignment.information = ''
    @assignment.save

    @class.reload.assignments.each do |assignment|
      assert_equal 'Test Assignment', assignment.name
      assert_nil assignment.information
    end
  end
end
