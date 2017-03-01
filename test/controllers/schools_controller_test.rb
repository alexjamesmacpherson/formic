require 'test_helper'

class SchoolsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @school = schools(:test_college)
    @other_school = schools(:example_college)
    @admin = users(:test_admin)
    @user = users(:test_user)
  end

  test 'should get show' do
    log_in_as @admin

    get school_path(@school)
    assert_response :success
  end

  test 'should edit school, should then redirect to school profile' do
    log_in_as @admin

    get edit_school_path(@school)
    assert_response :success
    patch school_path(@school), params: { school: {name: 'Test School', address: '41 Test Close, UK', phone: '+44 1928 110011'} }
    assert_redirected_to @school
    follow_and_assert(true, 'schools/show', 'Information for Test School has been updated successfully!')
  end

  test 'should not edit school, should then remain on edit school page' do
    log_in_as @admin

    get edit_school_path(@school)
    assert_response :success
    patch school_path(@school), params: { school: {name: '', address: '', phone: ''} }
    follow_and_assert(false, 'schools/edit', 'The form contains 4 errors.')
  end

  test 'should be unable to find show for non-existent school, redirect to site root' do
    log_in_as @admin

    get school_path(10)
    follow_and_assert(true, 'static/home', 'School not found.')
  end

  test 'should be unable to find edit for non-existent school, redirect to site root' do
    log_in_as @admin

    get edit_school_path(10)
    follow_and_assert(true, 'static/home', 'School not found.')
  end

  test 'should be unable to find update for non-existent school, redirect to site root' do
    log_in_as @admin

    patch school_path(10)
    follow_and_assert(true, 'static/home', 'School not found.')
  end

  test 'should be unable to access show for school when not logged in, redirect to login page' do
    get school_path(@school)
    follow_and_assert(true, 'sessions/new', 'Please login to continue.')
  end

  test 'should be unable to access edit for school when not logged in, redirect to login page' do
    get edit_school_path(@school)
    follow_and_assert(true, 'sessions/new', 'Please login to continue.')
  end

  test 'should be unable to access update for school when not logged in, redirect to login page' do
    patch school_path(@school)
    follow_and_assert(true, 'sessions/new', 'Please login to continue.')
  end

  test 'non-admin staff should be redirected from edit school' do
    log_in_as @user

    get edit_school_path(@school)
    assert_redirected_to root_url
  end

  test 'non-admin staff should be redirected from update school' do
    log_in_as @user

    patch school_path(@school)
    assert_redirected_to root_url
  end

  test 'cannot view pages for other schools' do
    log_in_as @admin

    get school_path(@other_school)
    assert_redirected_to @school
  end

  test 'cannot edit other schools' do
    log_in_as @admin

    get edit_school_path(@other_school)
    assert_redirected_to @school
  end

  test 'cannot update other schools' do
    log_in_as @admin

    patch school_path(@other_school)
    assert_redirected_to @school
  end

end
