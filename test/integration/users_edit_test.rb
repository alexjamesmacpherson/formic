require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user)
    @wrong_user = users(:test_parent)
    @admin = users(:test_admin)
    @other_admin = users(:example_admin)
  end

  test 'should be unable to edit non-existent users' do
    log_in_as @user

    get edit_user_path(10)
    follow_and_assert(true, 'users/index', 'User not found.')
  end

  test 'should be unable to update non-existent users' do
    log_in_as @user

    patch user_path(10)
    follow_and_assert(true, 'users/index', 'User not found.')
  end

  test 'should be unable to access edit for user when not logged in, redirect to login page' do
    get edit_user_path(@user)
    follow_and_assert(true, 'sessions/new', 'Please login to continue.')
  end

  test 'should be unable to access update for user when not logged in, redirect to login page' do
    patch user_path(@user)
    follow_and_assert(true, 'sessions/new', 'Please login to continue.')
  end

  test 'successful user edit, follow redirect to user profile' do
    log_in_as @user

    get edit_user_path(@user)
    assert_response :success

    email = 'john@test.com'
    name = 'John Tester'
    patch user_path(@user), params: { user: { email: email, name: name, password: '', password_confirmation: '' } }
    assert_redirected_to @user
    follow_and_assert(true, 'users/show', "John Tester's profile has been updated successfully!")

    @user.reload
    assert_equal email, @user.email
    assert_equal name, @user.name
  end

  test 'invalid user information on update, assert re-render new user page' do
    log_in_as @user

    get edit_user_path(@user)
    assert_response :success

    patch user_path(@user), params: { user: { email: '', name: '', password: '', password_confirmation: '' } }
    follow_and_assert(false, 'users/edit', 'The form contains 2 errors.')
  end

  test 'redirect edit when logged in as wrong user' do
    log_in_as @wrong_user

    get edit_user_path(@user)
    assert_redirected_to root_url
  end

  test 'redirect update when logged in as wrong user' do
    log_in_as @wrong_user

    patch user_path(@user)
    assert_redirected_to root_url
  end

  test 'successful edit of user by admin with friendly forwarding' do
    get edit_user_path(@user)
    log_in_as @admin
    assert_redirected_to edit_user_url(@user)

    email = 'john@test.com'
    name = 'John Tester'
    patch user_path(@user), params: { user: { email: email, name: name, password: '', password_confirmation: '' } }
    assert_redirected_to @user
    follow_and_assert(true, 'users/show', "John Tester's profile has been updated successfully!")

    @user.reload
    assert_equal email, @user.email
    assert_equal name, @user.name
  end

  test 'cannot edit user from different school, redirected to users index' do
    log_in_as @other_admin

    get edit_user_path(@user)
    assert_redirected_to users_url
    follow_and_assert(true, 'users/index', 'User not found.')
  end

  test 'cannot update user from different school, redirected to users index' do
    log_in_as @other_admin

    patch user_path(@user)
    assert_redirected_to users_url
    follow_and_assert(true, 'users/index', 'User not found.')
  end
end
