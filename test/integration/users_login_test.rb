require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user)
  end

  test 'attempt login with invalid information' do
    get login_path
    assert_template 'sessions/new'

    post login_path, params: { session: { email: '', password: '' } }
    follow_and_assert(false, 'sessions/new', 'Invalid email/password.')
    assert_not flash.empty?

    get root_path
    assert flash.empty?
    assert_not is_logged_in?
  end

  test 'login with valid information then logout' do
    get login_path
    assert_template 'sessions/new'

    post login_path, params: { session: { email: @user.email, password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_and_assert(true, 'users/show', "Hi #{@user.name.split.first}, welcome back to Formic Learning!")

    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url

    # Attempt logout again - if not logged in, should go straight to root
    delete logout_path
    follow_redirect!
    assert_not is_logged_in?
    assert_template 'static/home'
  end

  test 'login and remember user' do
    log_in_as @user
    assert_not_empty cookies['remember_token']
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test 'login without remembering user' do
    # Login with remember to create cookie
    log_in_as @user
    # Login again to without remembering to delete cookie
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end

  test 'login as inactive user' do
    @user.activated = false
    @user.save

    get login_path
    assert_template 'sessions/new'

    post login_path, params: { session: { email: @user.email, password: 'password' } }
    follow_and_assert(true, 'static/home', 'Account not activated, please check your emails for the activation link.')
  end
end
