require 'test_helper'

class SubjectTest < ActiveSupport::TestCase
  def setup
    @school = schools(:test_college)
    @dept = @school.departments.build(name: 'Science Department')
    @dept.save

    @subject = @dept.subjects.build(name: 'Science-1')
  end

  test 'subject is valid' do
    assert @subject.valid?
  end

  test 'subject must belong to department' do
    @subject.department = nil
    assert_not @subject.valid?
  end

  test 'subject cannot belong to non-existent department' do
    assert Department.exists?(@subject.department_id)
    assert_not Department.exists?(10)

    @subject.department_id = 10
    assert_not @subject.valid?
  end

  test 'subject has name of valid length' do
    invalid_names = ['', 'a' * 256]
    invalid_names.each do |invalid|
      @subject.name = invalid
      assert_not @subject.valid?, "#{invalid.inspect} should not be a valid name"
    end

    @subject.name = 'a' * 50
    assert @subject.valid?
  end
end
