require 'test_helper'

class TeachTest < ActiveSupport::TestCase
  def setup
    @teacher = users(:test_teacher)
    @class = subjects(:test_subject)
    @relation = Teach.new(subject: @class, teacher: @teacher)
  end

  test 'relation is valid and can be saved' do
    assert @relation.valid?
    assert @relation.save
  end

  test 'relation must have class' do
    @relation.subject = nil
    assert_not @relation.valid?
  end

  test 'relation must have teacher' do
    @relation.teacher = nil
    assert_not @relation.valid?
  end

  test 'relation cannot be empty' do
    @relation.subject = nil
    @relation.teacher = nil
    assert_not @relation.valid?
  end

  test 'duplicate relations cannot exist' do
    @duplicate = @relation.dup
    @relation.save
    assert_not @duplicate.save
    assert_not @duplicate.valid?
  end

  test 'relation teacher must have correct user group' do
    @teacher.update_attribute(:group, 1)
    assert_not @relation.valid?
    assert_not @relation.save
  end

  test 'relation cannot have non-existent subject' do
    assert Subject.exists?(@relation.subject_id)
    assert_not Subject.exists?(10)

    @relation.subject_id = 10
    assert_not @relation.valid?
  end

  test 'relation cannot have non-existent pupil' do
    assert User.exists?(@relation.teacher_id)
    assert_not User.exists?(10)

    @relation.teacher_id = 10
    assert_not @relation.valid?
  end
end
