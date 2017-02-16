require 'test_helper'

class UsersDeletionTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user)
    @admin = users(:test_admin)
    @other_admin = users(:example_admin)
  end

  test 'should be unable to destroy non-existent users' do
    log_in_as @admin

    delete user_path(10)
    follow_and_assert(true, 'users/index', 'User not found.')
  end

  test 'should be unable to access destroy for user when not logged in, redirect to login page' do
    delete user_path(@user)
    follow_and_assert(true, 'sessions/new', 'Please login to continue.')
  end

  test 'successfully delete user from school' do
    log_in_as @admin

    assert_difference 'User.count', -1 do
      delete user_path(@user)
    end
  end

  test 'non-admin users unable to delete' do
    log_in_as @user

    delete user_path(@user)
    assert_redirected_to root_url
  end

  test 'unable to delete users from other schools' do
    log_in_as @other_admin

    delete user_path(@user)
    assert_redirected_to users_url
    follow_and_assert(true, 'users/index', 'User not found.')
  end
end
