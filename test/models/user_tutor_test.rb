require 'test_helper'
class UserTutorTest < ActiveSupport::TestCase
  def setup
    @pupil = users(:test_user)
    @tutor = users(:test_teacher)
    @pupil.tutor = @tutor
    @pupil.save
  end

  test 'tutor relation is valid and can be saved' do
    assert @pupil.valid?
    assert @pupil.save
  end

  test 'pupil can get tutor and tutor can get all tutees' do
    assert_equal @tutor, @pupil.tutor
    assert_equal @pupil, @tutor.tutees.last
  end

  test 'pupil does not need to have a tutor' do
    @pupil.tutor = nil
    assert @pupil.valid?
    assert @pupil.save
    assert_not_equal @pupil, @tutor.tutees.last
  end

  test 'pupil.tutor set to nil if tutor deleted' do
    @tutor.destroy
    assert_nil @pupil.reload.tutor
  end

  test 'tutor.tutees does not contain pupil if they are deleted' do
    @pupil.destroy
    assert_nil @tutor.reload.tutees.last
  end

  test 'non-teachers cannot be tutor' do
    (0..5).each do |n|
      @tutor.group = n
      @tutor.save

      @pupil.tutor = @tutor
      if n == 3
        assert @pupil.valid?
      else
        assert_not @pupil.valid?
      end
    end
  end

  test 'non-students cannot have tutor' do
    (0..5).each do |n|
      @pupil.group = n
      @pupil.save

      @pupil.tutor = @tutor
      if n == 1
        assert @pupil.valid?
      else
        assert_not @pupil.valid?
      end
    end
  end

  test 'tutor of pupil must exist' do
    assert User.exists?(@pupil.tutor.id)
    assert_not User.exists?(10)

    @pupil.tutor_id = 10
    assert_not @pupil.valid?
  end
end