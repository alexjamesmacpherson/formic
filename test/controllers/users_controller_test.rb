require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user)
  end

  test 'should get index' do
    get users_path
    assert_response :success
  end

  test 'should get show' do
    get user_path(@user)
    assert_response :success
  end

  test 'should get new' do
    get new_user_path
    assert_response :success
  end

  test 'should get edit' do
    get edit_user_path(@user)
    assert_response :success
  end

  test 'should be unable to show, edit, update or destroy non-existent users' do
    get user_path(10)
    follow_and_assert(true, 'users/index', 'User not found.')

    get edit_user_path(10)
    follow_and_assert(true, 'users/index', 'User not found.')

    patch user_path(10)
    follow_and_assert(true, 'users/index', 'User not found.')

    delete user_path(10)
    follow_and_assert(true, 'users/index', 'User not found.')
  end
end
