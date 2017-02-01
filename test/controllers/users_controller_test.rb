require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user)
    @admin = users(:test_admin)
  end

  test 'should get index' do
    log_in_as @user

    get users_path
    assert_response :success
  end

  test 'should get show' do
    log_in_as @user

    get user_path(@user)
    assert_response :success
  end

  test 'should get new' do
    log_in_as @admin

    get new_user_path
    assert_response :success
  end

  test 'should get edit' do
    log_in_as @user

    get edit_user_path(@user)
    assert_response :success
  end
end
