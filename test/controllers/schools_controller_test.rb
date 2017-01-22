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

  test 'should be unable to find school for show, edit and update, should then redirect to schools index' do
    get school_url(10)
    follow_redirect!
    assert_template 'schools/index'
    assert_select '.alert', 'School not found.'

    get edit_school_url(10)
    follow_redirect!
    assert_template 'schools/index'
    assert_select '.alert', 'School not found.'

    patch school_path(10), params: { school: {name: 'Test School', address: '41 Test Close, UK', phone_number: '+44 1928 110011'} }
    follow_redirect!
    assert_template 'schools/index'
    assert_select '.alert', 'School not found.'
  end

  test 'should create new school, should then redirect to school profile' do
    get new_school_url
    assert_response :success
    assert_difference 'School.count', 1 do
      post schools_path, params: { school: {name: '   Test     School   ', address: '41 Test Close, UK', phone_number: '+44 1928 110011'} }
    end
    follow_redirect!
    assert_template 'schools/show'
    # Also assert flash is rendered correctly and strings are trimmed and squished on save
    assert_select '.alert', 'Test School has been created successfully!'
  end

  test 'should not create new school, should then remain on new school page' do
    get new_school_url
    assert_response :success
    assert_no_difference 'School.count' do
      post schools_path, params: { school: {name: '', address: '', phone_number: ''} }
    end
    assert_template 'schools/new'
    # Also assert flash renders correctly
    assert_select '.alert', 'The form contains 4 errors.'
  end

  test 'should edit school, should then redirect to school profile' do
    get edit_school_url(@school)
    assert_response :success
    patch school_path(@school), params: { school: {name: 'Test School', address: '41 Test Close, UK', phone_number: '+44 1928 110011'} }
    follow_redirect!
    assert_template 'schools/show'
    # Also assert flash renders correctly
    assert_select '.alert', 'Information for Test School has been updated successfully!'
  end

  test 'should not edit school, should then remain on edit school page' do
    get edit_school_url(@school)
    assert_response :success
    patch school_path(@school), params: { school: {name: '', address: '', phone_number: ''} }
    assert_template 'schools/edit'
    # Also assert flash renders correctly
    assert_select '.alert', 'The form contains 4 errors.'
  end

end
