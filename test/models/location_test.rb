require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  def setup
    @school = schools(:test_college)
    @location = @school.locations.build(name: 'Test Room')
  end

  test 'location is valid and can be saved' do
    assert @location.valid?
    assert @location.save
  end

  test 'location must belong to school' do
    @location.school = nil
    assert_not @location.valid?
  end

  test 'location cannot belong to non-existent school' do
    assert School.exists?(@location.school_id)
    assert_not School.exists?(10)

    @location.school_id = 10
    assert_not @location.valid?
  end

  test 'location has name of valid length' do
    invalid_names = ['', 'a' * 256]
    invalid_names.each do |invalid|
      @location.name = invalid
      assert_not @location.valid?, "#{invalid.inspect} should not be a valid location name"
    end

    @location.name = 'a' * 50
    assert @location.valid?
  end
end
