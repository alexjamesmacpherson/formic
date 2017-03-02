require 'test_helper'

class YearGroupTest < ActiveSupport::TestCase
  def setup
    @school = schools(:test_college)
    @year = @school.year_groups.build(name: 'Year X')
  end

  test 'year group is valid and can be saved' do
    assert @year.valid?
    assert @year.save
  end

  test 'year group must belong to school' do
    @year.school = nil
    assert_not @year.valid?
  end

  test 'year group cannot belong to non-existent school' do
    assert School.exists?(@year.school_id)
    assert_not School.exists?(10)

    @year.school_id = 10
    assert_not @year.valid?
  end

  test 'year group has name of valid length' do
    invalid_names = ['', 'a' * 256]
    invalid_names.each do |invalid|
      @year.name = invalid
      assert_not @year.valid?, "#{invalid.inspect} should not be a valid name"
    end

    @year.name = 'a' * 50
    assert @year.valid?
  end
end
