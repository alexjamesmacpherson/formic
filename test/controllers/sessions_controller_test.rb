require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user)
  end

  test 'should get new' do
    get login_path
    assert_response :success
  end

  test 'should redirect to user if logged in' do
    log_in_as @user
    assert is_logged_in?

    get login_path
    assert_response :redirect
    follow_redirect!
    assert_template 'users/show'
  end
end
