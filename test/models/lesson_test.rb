require 'test_helper'

class LessonTest < ActiveSupport::TestCase
  def setup
    @subject = subjects(:test_subject)
    @location = locations(:one)
    @lesson = Lesson.create!(subject: @subject, location: @location, start_time: Time.zone.now, end_time: Time.zone.now + 1.hour)

    @subject_2 = subjects(:test_class)
    @location_2 = locations(:two)
  end

  test 'lesson is valid and can be saved' do
    assert @lesson.valid?
    assert @lesson.save
  end

  test 'lesson must belong to subject' do
    @lesson.subject = nil
    assert_not @lesson.valid?
  end

  test 'lesson cannot belong to non-existent subject' do
    assert Subject.exists?(@lesson.subject_id)
    assert_not Subject.exists?(10)

    @lesson.subject_id = 10
    assert_not @lesson.valid?
  end

  test 'lesson must belong to location' do
    @lesson.location = nil
    assert_not @lesson.valid?
  end

  test 'lesson cannot belong to non-existent location' do
    assert Location.exists?(@lesson.location_id)
    assert_not Location.exists?(10)

    @lesson.location_id = 10
    assert_not @lesson.valid?
  end

  test 'duplicate lessons cannot exist' do
    @duplicate = @lesson.dup
    @lesson.save
    #assert_not @duplicate.save
    assert_not @duplicate.valid?
  end
=begin
  test 'lessons of same subject cannot have same period' do
    @duplicate = @lesson.dup
    @lesson.save

    @duplicate.location = @location_2

    assert_not @duplicate.save
    assert_not @duplicate.valid?
  end

  test 'lessons of same subject can have different periods' do
    @duplicate = @lesson.dup
    @lesson.save

    @duplicate.location = @location_2
    @duplicate.period = @period_2

    assert @duplicate.save
    assert @duplicate.valid?
  end

  test 'lessons with same location cannot have same period' do
    @duplicate = @lesson.dup
    @lesson.save

    @duplicate.subject = @subject_2

    assert_not @duplicate.save
    assert_not @duplicate.valid?
  end

  test 'lessons with same location can have different periods' do
    @duplicate = @lesson.dup
    @lesson.save

    @duplicate.subject = @subject_2
    @duplicate.period = @period_2

    assert @duplicate.save
    assert @duplicate.valid?
  end
=end
end
