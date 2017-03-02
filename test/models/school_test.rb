require 'test_helper'

class SchoolTest < ActiveSupport::TestCase
  def setup
    @school = School.new(name: 'Test School', address: '41 Test Close, UK', phone: '+44 1928 110011')
  end

  test 'school is valid' do
    assert @school.valid?
  end

  test 'school name must exist' do
    @school.name = ''
    assert_not @school.valid?
  end

  test 'school name cannot exceed 255 chars' do
    @school.name = 'a' * 256
    assert_not @school.valid?
  end

  test 'address must exist' do
    @school.address = ''
    assert_not @school.valid?
  end

  test 'address is correctly formatted on save' do
    @school.address = "41 Test Close\r\nUK"
    @school.save
    assert_equal "41 Test Close,\r\nUK", @school.reload.address

    @school.address = "41 Test Close          \r\nUK       "
    @school.save
    assert_equal "41 Test Close,\r\nUK", @school.reload.address

    @school.address = "41 Test Close     ,     \r\nUK"
    @school.save
    assert_equal "41 Test Close,\r\nUK", @school.reload.address
  end

  test 'phone number must exist' do
    @school.phone = ''
    assert_not @school.valid?
  end

  test 'phone number must be valid' do
    valid_numbers = ['+441928110011', '+44 01928 110011', '01928 110011']
    valid_numbers.each do |valid|
      @school.phone = valid
      assert @school.valid?, "#{valid.inspect} should be a valid phone number"
    end

    invalid_numbers = ['+44 1928 110', '1928 110011', '44 01928 110011', '++44 01928 110011', '', 'a']
    invalid_numbers.each do |invalid|
      @school.phone = invalid
      assert_not @school.valid?, "#{invalid.inspect} should not be a valid phone number"
    end
  end

  test 'school motto cannot exceed 255 chars' do
    @school.motto = 'a' * 256
    assert_not @school.valid?
  end
end
