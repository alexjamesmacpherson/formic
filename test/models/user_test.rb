require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:test_user)
    @school = schools(:test_college)
  end

  test 'user is valid' do
    assert @user.valid?
  end

  test 'user must belong to school' do
    @user.school = nil
    assert_not @user.valid?
  end

  test 'user email exists and is well formed' do
    @user.email = ''
    assert_not @user.valid?

    @user.email = '@test.com'
    assert_not @user.valid?

    @user.email = 'test@.com'
    assert_not @user.valid?

    @user.email = 'test.com'
    assert_not @user.valid?

    @user.email = 'test@test.'
    assert_not @user.valid?

    @user.email = 'test@test'
    assert_not @user.valid?

    @user.email = 'a' * 256
    assert_not @user.valid?
  end

  test 'user has valid group' do
    assert @user.user_group >= 0 && @user.user_group <= 5

    @user.user_group = nil
    assert_not @user.valid?
  end

  test 'user has name of valid length' do
    @user.name = ''
    assert_not @user.valid?

    @user.name = 'a' * 4
    assert_not @user.valid?

    @user.name = 'a' * 256
    assert_not @user.valid?
  end

  test 'user address exists' do
    @user.address = ''
    assert_not @user.valid?
  end
end
