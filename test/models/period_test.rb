require 'test_helper'

class PeriodTest < ActiveSupport::TestCase
  def setup
    @school = schools(:test_college)
    @period = @school.periods.build(name: 'Test Period', starts_at: Time.zone.now, ends_at: Time.zone.now + 1.hour)
  end

  test 'period is valid and can be saved' do
    assert @period.valid?
    assert @period.save
  end

  test 'period must belong to school' do
    @period.school = nil
    assert_not @period.valid?
  end

  test 'period cannot belong to non-existent school' do
    assert School.exists?(@period.school_id)
    assert_not School.exists?(10)

    @period.school_id = 10
    assert_not @period.valid?
  end

  test 'period has name of valid length' do
    invalid_names = ['', 'a' * 256]
    invalid_names.each do |invalid|
      @period.name = invalid
      assert_not @period.valid?, "#{invalid.inspect} should not be a valid period name"
    end

    @period.name = 'a' * 50
    assert @period.valid?
  end

  test 'period must have start time' do
    @period.starts_at = nil
    assert_not @period.valid?
  end

  test 'period must have end time' do
    @period.ends_at = nil
    assert_not @period.valid?
  end

  test 'period must start before it finishes' do
    @period.starts_at = @period.ends_at + 1.hour
    assert_not @period.valid?
  end
end
