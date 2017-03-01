require 'test_helper'

class TutorTest < ActiveSupport::TestCase
  def setup
    @pupil = users(:test_user)
    @tutor = users(:test_teacher)
    @relation = Tutor.new(tutor: @tutor, pupil: @pupil)
  end

  test 'relation is valid and can be saved' do
    assert @relation.valid?
    assert @relation.save
  end

  test 'relation must have tutor' do
    @relation.tutor = nil
    assert_not @relation.valid?
  end

  test 'relation must have pupil' do
    @relation.pupil = nil
    assert_not @relation.valid?
  end

  test 'relation cannot be empty' do
    @relation.tutor = nil
    @relation.pupil = nil
    assert_not @relation.valid?
  end

  test 'duplicate relations cannot exist' do
    @duplicate = @relation.dup
    @relation.save
    assert_not @duplicate.save
    assert_not @duplicate.valid?
  end

  test 'relation tutor must have correct user group' do
    @tutor.update_attribute(:group, 1)
    assert_not @relation.valid?
    assert_not @relation.save
  end

  test 'relation pupil must have correct user group' do
    @pupil.update_attribute(:group, 3)
    assert_not @relation.valid?
    assert_not @relation.save
    end

  test 'relation cannot have non-existent tutor' do
    assert User.exists?(@relation.tutor_id)
    assert_not User.exists?(10)

    @relation.tutor_id = 10
    assert_not @relation.valid?
  end

  test 'relation cannot have non-existent pupil' do
    assert User.exists?(@relation.pupil_id)
    assert_not User.exists?(10)

    @relation.pupil_id = 10
    assert_not @relation.valid?
  end
end
