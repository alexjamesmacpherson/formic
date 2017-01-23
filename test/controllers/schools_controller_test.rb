require 'test_helper'

class SchoolsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @school = schools(:test_college)
  end

  test 'should get index' do
    get schools_url
    assert_response :success
  end

  test 'should get show' do
    get school_url(@school)
    assert_response :success
  end

  test 'should be unable to find school for show, edit, update and destroy, should then redirect to schools index' do
    get school_url(10)
    follow_and_assert(true, 'schools/index', 'School not found.')

    get edit_school_url(10)
    follow_and_assert(true, 'schools/index', 'School not found.')

    patch school_path(10), params: { school: {name: 'Test School', address: '41 Test Close, UK', phone_number: '+44 1928 110011'} }
    follow_and_assert(true, 'schools/index', 'School not found.')

    delete school_path(10)
    follow_and_assert(true, 'schools/index', 'School not found.')
  end

  test 'should create new school, should then redirect to school profile' do
    get new_school_url
    assert_response :success
    assert_difference 'School.count', 1 do
      post schools_path, params: { school: {name: '   Test     School   ', address: '41 Test Close, UK', phone_number: '+44 1928 110011'} }
    end
    # Also asserts strings are correctly trimmed and squished before validation
    follow_and_assert(true, 'schools/show', 'Test School has been created successfully!')
  end

  test 'should not create new school, should then remain on new school page' do
    get new_school_url
    assert_response :success
    assert_no_difference 'School.count' do
      post schools_path, params: { school: {name: '', address: '', phone_number: ''} }
    end
    follow_and_assert(false, 'schools/new', 'The form contains 4 errors.')
  end

  test 'should edit school, should then redirect to school profile' do
    get edit_school_url(@school)
    assert_response :success
    patch school_path(@school), params: { school: {name: 'Test School', address: '41 Test Close, UK', phone_number: '+44 1928 110011'} }
    assert_redirected_to @school
    follow_and_assert(true, 'schools/show', 'Information for Test School has been updated successfully!')
  end

  test 'should not edit school, should then remain on edit school page' do
    get edit_school_url(@school)
    assert_response :success
    patch school_path(@school), params: { school: {name: '', address: '', phone_number: ''} }
    follow_and_assert(false, 'schools/edit', 'The form contains 4 errors.')
  end

  test 'should delete school' do
    assert_difference 'School.count', -1 do
      delete school_path(@school)
    end
    follow_and_assert(true, 'schools/index', 'Test College and all its associated records have been removed.')
  end

end
