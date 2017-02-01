require 'test_helper'

class UsersIndexAndShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user)
    @admin = users(:test_admin)
    @other_admin = users(:example_admin)
  end

  test 'should be unable to show non-existent users' do
    log_in_as @user

    get user_path(10)
    follow_and_assert(true, 'users/index', 'User not found.')
  end

  test 'should be unable to access users index when not logged in, redirect to login page' do
    get users_path
    follow_and_assert(true, 'sessions/new', 'Please login to continue.')
  end

  test 'should be unable to access show for user when not logged in, redirect to login page' do
    get user_path(@user)
    follow_and_assert(true, 'sessions/new', 'Please login to continue.')
  end

  test 'unable to show users from other schools' do
    log_in_as @other_admin

    get user_path(@user)
    assert_redirected_to users_url
    follow_and_assert(true, 'users/index', 'User not found.')
  end
end
