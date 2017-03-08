require 'test_helper'

class StudyTest < ActiveSupport::TestCase
  def setup
    @pupil = users(:test_user)
    @class = subjects(:test_subject)
    @relation = Study.new(subject: @class, pupil: @pupil, challenge_grade: 'A')
  end

  test 'relation is valid and can be saved' do
    assert @relation.valid?
    assert @relation.save
  end

  test 'relation must have class' do
    @relation.subject = nil
    assert_not @relation.valid?
  end

  test 'relation must have pupil' do
    @relation.pupil = nil
    assert_not @relation.valid?
  end

  test 'relation cannot be empty' do
    @relation.subject = nil
    @relation.pupil = nil
    assert_not @relation.valid?
  end

  test 'duplicate relations cannot exist' do
    @duplicate = @relation.dup
    @relation.save
    assert_not @duplicate.save
    assert_not @duplicate.valid?
  end

  test 'relation pupil must have correct user group' do
    @pupil.update_attribute(:group, 3)
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
    assert User.exists?(@relation.pupil_id)
    assert_not User.exists?(10)

    @relation.pupil_id = 10
    assert_not @relation.valid?
  end

  test 'challenge grade must be a grade between A and F' do
    valid_grades = ('A'..'F').to_a
    valid_grades.each do |valid|
      @relation.challenge_grade = valid
      assert @relation.valid?, "#{valid.inspect} should be a valid expected grade"
    end

    invalid_grades = [nil, 'AA', 'Z', 'invalid']
    invalid_grades.each do |invalid|
      @relation.challenge_grade = invalid
      assert_not @relation.valid?, "#{invalid.inspect} should not be a valid expected grade"
    end
  end

  test 'pupil can fetch grades directly from self with has_many relation' do
    @relation.challenge_grade = 'A'
    @relation.save

    @pupil.grades.each do |grade|
      assert_equal 'A', grade.challenge_grade
    end
  end
end
