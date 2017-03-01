require 'test_helper'

class DepartmentTest < ActiveSupport::TestCase
  def setup
    @school = schools(:test_college)
    @head = users(:test_teacher)
    @dept = @school.departments.build(name: 'Science Department')
  end

  test 'department is valid' do
    assert @dept.valid?
  end

  test 'department must belong to school' do
    @dept.school = nil
    assert_not @dept.valid?
  end

  test 'department cannot belong to non-existent school' do
    assert School.exists?(@dept.school_id)
    assert_not School.exists?(10)

    @dept.school_id = 10
    assert_not @dept.valid?
  end

  test 'department is valid when head is set' do
    @dept.head = @head
    assert @dept.valid?
  end

  test 'department cannot have non-existent head' do
    assert_not User.exists?(10)

    @dept.head_id = 10
    assert_not @dept.valid?
  end

  test 'department head must be a teacher' do
    (0..5).each do |n|
      @head.group = n
      @head.save

      @head.reload
      assert @head.valid?
      assert @head.is?(:group, n)

      @dept.head = @head

      if n == 3
        assert @dept.valid?, "#{n.inspect} should be a valid user group for department head"
      else
        assert_not @dept.valid?, "#{n.inspect} should not be a valid user group for department head"
      end
    end
  end

  test 'department has name of valid length' do
    invalid_names = ['', 'a' * 256]
    invalid_names.each do |invalid|
      @dept.name = invalid
      assert_not @dept.valid?, "#{invalid.inspect} should not be a valid name"
    end
  end
end
