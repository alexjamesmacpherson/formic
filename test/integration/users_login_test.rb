require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user)
  end

  test 'login with invalid information' do
    get login_path
    assert_template 'sessions/new'

    post login_path, params: { session: { email: '', password: '' } }
    follow_and_assert(false, 'sessions/new', 'Invalid email/password.')
    assert_not flash.empty?

    get root_path
    assert flash.empty?
    assert_not is_logged_in?
  end

  test 'login with valid information' do
    get login_path
    assert_template 'sessions/new'

    post login_path, params: { session: { email: @user.email, password: 'password' } }
    assert_redirected_to @user
    follow_and_assert(true, 'users/show', "Hi #{@user.name.split.first}, welcome back to Formic Learning!")
    assert is_logged_in?
  end

  test 'logout user' do
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
  end
end
