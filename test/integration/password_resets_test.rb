require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user)
    ActionMailer::Base.deliveries.clear
  end

  test 'password resets' do
    get new_password_reset_path
    assert_response :success
    assert_template 'password_resets/new'

    # Invalid email
    post password_resets_path, params: { password_reset: {email: ''} }
    follow_and_assert(false, 'password_resets/new', 'Email address not found.')

    # Valid email
    post password_resets_path, params: { password_reset: {email: @user.email} }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    follow_and_assert(true, 'static/home', 'Please check your emails for instructions on how to reset your password.')

    # Wrong email
    get edit_password_reset_path(user.reset_token, email: '')
    assert_redirected_to root_url

    # Inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)

    # Correct email, incorrect token
    get edit_password_reset_path('incorrect token', email: user.email)
    assert_redirected_to root_url

    # Correct email and token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', user.email

    # Empty password & confirmation
    patch password_reset_path(user.reset_token), params: { email: user.email, user: { password: '', password_confirmation: '' } }
    assert_template 'password_resets/edit'
    assert_select 'div#error_explanation'

    # Invalid password & confirmation
    patch password_reset_path(user.reset_token), params: { email: user.email, user: { password: 'foobar', password_confirmation: 'raboof' } }
    assert_template 'password_resets/edit'
    assert_select 'div#error_explanation'

    # Valid password reset
    patch password_reset_path(user.reset_token), params: { email: user.email, user: { password: 'password', password_confirmation: 'password' } }
    assert is_logged_in?
    follow_and_assert(true, 'users/show', 'Password has been reset.')
  end

  test 'password reset expires after 2 hours' do
    get new_password_reset_path
    assert_response :success
    assert_template 'password_resets/new'

    post password_resets_path, params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    user = assigns(:user)
    follow_and_assert(true, 'static/home', 'Please check your emails for instructions on how to reset your password.')

    user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(user.reset_token), params: { email: user.email, user: { password:'foobar', password_confirmation: 'password' } }
    follow_and_assert(true, 'password_resets/new', 'Password reset has expired.')
  end
end
