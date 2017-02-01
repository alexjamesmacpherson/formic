require 'test_helper'

class SchoolsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @school = schools(:test_college)
  end

  test 'should get show' do
    get school_path(@school)
    assert_response :success
  end

  test 'should be unable to find school for show, edit and update, should then redirect to schools index' do
    get school_path(10)
    follow_and_assert(true, 'static/home', 'School not found.')

    get edit_school_path(10)
    follow_and_assert(true, 'static/home', 'School not found.')

    patch school_path(10), params: { school: {name: 'Test School', address: '41 Test Close, UK', phone_number: '+44 1928 110011'} }
    follow_and_assert(true, 'static/home', 'School not found.')
  end

  test 'should edit school, should then redirect to school profile' do
    get edit_school_path(@school)
    assert_response :success
    patch school_path(@school), params: { school: {name: 'Test School', address: '41 Test Close, UK', phone_number: '+44 1928 110011'} }
    assert_redirected_to @school
    follow_and_assert(true, 'schools/show', 'Information for Test School has been updated successfully!')
  end

  test 'should not edit school, should then remain on edit school page' do
    get edit_school_path(@school)
    assert_response :success
    patch school_path(@school), params: { school: {name: '', address: '', phone_number: ''} }
    follow_and_assert(false, 'schools/edit', 'The form contains 4 errors.')
  end

end
