require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @school = schools(:test_college)
    @user = users(:test_user)
  end

  test 'should get index' do
    get users_url
    assert_response :success
  end

  test 'should be unable to show, edit, update or destroy non-existent users' do
    get user_url(10)
    follow_and_assert(true, 'users/index', 'User not found.')

    get edit_user_url(10)
    follow_and_assert(true, 'users/index', 'User not found.')

    patch user_path(10)
    follow_and_assert(true, 'users/index', 'User not found.')

    delete user_path(10)
    follow_and_assert(true, 'users/index', 'User not found.')
  end

  test 'should get show' do
    get user_url(@user)
    assert_response :success
  end

  test 'should get new' do
    get new_user_url
    assert_response :success
  end

  test 'should create new user, should then redirect to user profile' do
    get new_user_url
    assert_response :success
    assert_difference 'User.count', 1 do
      post users_path, params: { user: {school: :school, email: 'terry@test.com', user_group: 1, name: 'Terry Tester', bio: 'testing', address: 'Test, Teston, Test Sussex, T35T'} }
    end
    follow_and_assert(true, 'users/show', 'Terry Tester\'s account has been created successfully!')
  end

  test 'should not create new user due to non-unique email' do
    get new_user_url
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: {school: :school, email: 'test@test.com', user_group: 1, name: 'Terry Tester', bio: 'testing', address: 'Test, Teston, Test Sussex, T35T'} }
    end
    follow_and_assert(false, 'users/new', 'The form contains 1 error.')
  end

  test 'should not create new user due to blank fields' do
    get new_user_url
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: {school: :school, email: '', user_group: 1, name: '', bio: '', address: ''} }
    end
    follow_and_assert(false, 'users/new', 'The form contains 4 errors.')
  end

  test 'should get edit' do
    get edit_user_url(@user)
    assert_response :success
  end

  test 'should update user, should then redirect to user profile' do
    get edit_user_url(@user)
    assert_response :success
    patch user_path(@user), params: { user: {email: 'terry@test.com', name: 'Terry Tester', bio: 'testing 123'} }
    assert_redirected_to @user
    follow_and_assert(true, 'users/show', 'Terry Tester\'s profile has been updated successfully!')
  end

  test 'should not update user due to non-unique email' do
    @user2 = @school.users.build(email: 'terry@test.com', user_group: 1, name: 'Terry Tester', bio: 'I love TDD!', address: 'Test, Teston, Test Sussex, T35T')
    @user2.save

    get edit_user_url(@user2)
    assert_response :success
    patch user_path(@user2), params: { user: {email: 'test@test.com'} } # Note: not all params must be entered on update
    follow_and_assert(false, 'users/edit', 'The form contains 1 error.')
  end

  test 'should not update user due to blank fields' do
    get edit_user_url(@user)
    assert_response :success
    patch user_path(@user), params: { user: {email: '', name: '', bio: '', address: ''} }
    follow_and_assert(false, 'users/edit', 'The form contains 4 errors.')
  end

  test 'should delete user' do
    assert_difference 'User.count', -1 do
      delete user_path(@user)
    end
    follow_and_assert(true, 'users/index', 'Timmy Tester\'s account and all their associated records have been removed.')
  end

end
