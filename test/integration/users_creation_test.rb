require 'test_helper'

class UsersCreationTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:test_admin)
    @user = users(:test_user)
    ActionMailer::Base.deliveries.clear
  end

  test 'successful user creation, follow redirect to new user page' do
    log_in_as @admin

    get new_user_path
    assert_response :success
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { email: 'john@test.com', name: 'John Tester', password: 'foobar', password_confirmation: 'foobar' } }
    end
    new_user = assigns(:user)
    follow_and_assert(true, 'users/new', 'Account created: John Tester has been sent an email to activate their account.')

    # Email has been sent to new user
    assert_equal 1, ActionMailer::Base.deliveries.size

    # New user is added to same school as creator (admin)
    assert_equal 'John Tester', new_user.name
    assert_equal @admin.school_id, new_user.school_id

    # Cannot access inactive user page
    get user_path(new_user)
    follow_and_assert(true, 'users/index', 'User not found.')

    # New user is inactive and cannot login after logging admin out
    delete logout_path
    assert_not is_logged_in?
    assert_not new_user.activated?
    log_in_as(new_user)
    assert_not is_logged_in?

    # Invalid token/email does not activate account
    get edit_account_activation_path('invalid token', email: new_user.email)
    assert_not is_logged_in?
    get edit_account_activation_path(new_user.activation_token, email: 'invalid email')
    assert_not is_logged_in?
    follow_and_assert(true, 'static/home', 'Invalid activation link.')

    # Valid activation
    get edit_account_activation_path(new_user.activation_token, email: new_user.email)
    assert new_user.reload.activated?
    follow_and_assert(true, 'users/show', 'Account activated, welcome to Formic Learning!')
    assert is_logged_in?
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
