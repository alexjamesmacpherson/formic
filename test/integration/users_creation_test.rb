require 'test_helper'

class UsersCreationTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:test_admin)
    @user = users(:test_user)
  end

  test 'successful user creation, follow redirect to user profile' do
    log_in_as @admin

    get new_user_path
    assert_response :success
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { email: 'john@test.com', name: 'John Tester', password: 'foobar', password_confirmation: 'foobar' } }
    end
    follow_and_assert(true, 'users/show', 'John Tester\'s account has been created successfully!')

    # Assert new user is added to same school as creator (admin)
    new_user = User.all.last
    assert_equal 'John Tester', new_user.name
    assert_equal @admin.school_id, new_user.school_id
  end

  test 'invalid user information on creation, assert re-render new user page' do
    log_in_as @admin

    get new_user_path
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { email: 'test@test.com', name: '', password: 'foo', password_confirmation: 'bar' } }
    end
    follow_and_assert(false, 'users/new', 'The form contains 4 errors.')
  end

  test 'should be unable to access new user when not logged in, redirect to login page' do
    get new_user_path
    follow_and_assert(true, 'sessions/new', 'Please login to continue.')
  end

  test 'should be unable to access create user when not logged in, redirect to login page' do
    post users_path
    follow_and_assert(true, 'sessions/new', 'Please login to continue.')
  end

  test 'cannot access new user page unless admin' do
    log_in_as @user

    get new_user_path
    assert_redirected_to root_url
  end

  test 'cannot create new user unless admin' do
    log_in_as @user

    post users_path
    assert_redirected_to root_url
  end
end
