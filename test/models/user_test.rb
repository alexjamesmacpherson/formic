require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @school = schools(:test_college)
    @user = @school.users.build(email: 'james@test.com', name: 'James Tester', password: 'foobar', password_confirmation: 'foobar')
  end

  test 'user is valid' do
    assert @user.valid?
  end

  test 'user must belong to school' do
    @user.school = nil
    assert_not @user.valid?
  end

  test 'users school must exist' do
    assert School.exists?(@user.school_id)
    assert_not School.exists?(10)

    @user.school_id = 10
    assert_not @user.valid?
  end

  test 'user email exists and is well formed' do
    valid_emails = %w[user@test.com user.test@test.ac.uk u@test.co user-test@test.com user_test@test.com user_test-2@test.com user+test@test.com]
    valid_emails.each do |valid|
      @user.email = valid
      assert @user.valid?, "#{valid.inspect} should be a valid email address"
    end

    invalid_emails = %w[@test.com test@.com test.com test@test]
    invalid_emails << 'a' * 256 << ''
    invalid_emails.each do |invalid|
      @user.email = invalid
      assert_not @user.valid?, "#{invalid.inspect} should not be a valid email address"
    end
  end

  test 'email addresses should be unique and case insensitive' do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?, "#{duplicate_user.email.inspect} is not unique so should be invalid"

    duplicate_user.email = @user.email.upcase
    assert_not duplicate_user.valid?, "#{duplicate_user.email.inspect} is not unique (case-insensitive) so should be invalid"
  end

  test 'email addresses are saved in lowercase' do
    mixed_case_email = 'TestUser@test.com'
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test 'user has valid group' do
    (0..5).each do |n|
      @user.group = n
      assert @user.valid?, "#{n.inspect} should be a valid user group"
    end

    invalid_groups = [nil, -1, 6, 1000]
    invalid_groups.each do |invalid|
      @user.group = invalid
      assert_not @user.valid?, "#{invalid.inspect} should not be a valid user group"
    end
  end

  test 'user has name of valid length' do
    invalid_names = ['', 'a' * 256]
    invalid_names.each do |invalid|
      @user.name = invalid
      assert_not @user.valid?, "#{invalid.inspect} should not be a valid name"
    end
  end

  test 'user bio valid even if blank' do
    bios = ['', 'Test, Teston, Test Sussex, T35T', 'a' * 256]
    bios.each do |bio|
      @user.bio = bio
      assert @user.valid?, "#{bio.inspect} should be a valid bio"
    end
  end

  test 'password should be present' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test 'user password of valid length' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

  test 'password and confirmation must match' do
    @user.password = 'password'
    @user.password_confirmation = 'foobar'
    assert_not @user.valid?
  end

  test 'authenticated? should return false for user with nil digest' do
    assert_not @user.authenticated?(:remember, '')
  end
end
