require 'test_helper'

class SchoolTest < ActiveSupport::TestCase
  def setup
    @school = School.new(name: 'Test School', address: '41 Test Close, UK', phone_number: '+44 1928 110011')
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

  test 'phone number must exist' do
    @school.phone_number = ''
    assert_not @school.valid?
  end

  test 'phone number must be valid' do
    @school.phone_number = '+441928110011'
    assert @school.valid?

    @school.phone_number = '+44 01928 110011'
    assert @school.valid?

    @school.phone_number = '01928 110011'
    assert @school.valid?

    @school.phone_number = '+44 1928 110'
    assert_not @school.valid?

    @school.phone_number = '1928 110011'
    assert_not @school.valid?

    @school.phone_number = '44 01928 110011'
    assert_not @school.valid?
  end

  test 'school motto cannot exceed 255 chars' do
    @school.motto = 'a' * 256
    assert_not @school.valid?
  end
end
