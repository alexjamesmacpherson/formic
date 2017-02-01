require 'test_helper'

class UsersCreationTest < ActionDispatch::IntegrationTest
  test 'successful user creation, follow redirect to user profile' do
    get new_user_path
    assert_response :success
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { email: 'john@test.com', name: 'John Tester', password: 'foobar', password_confirmation: 'foobar' } }
    end
    follow_and_assert(true, 'users/show', 'John Tester\'s account has been created successfully!')
  end

  test 'invalid user information on creation, assert re-render new user page' do
    get new_user_path
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: { email: 'test@test.com', name: '', password: 'foo', password_confirmation: 'bar' } }
    end
    follow_and_assert(false, 'users/new', 'The form contains 4 errors.')
  end
end
