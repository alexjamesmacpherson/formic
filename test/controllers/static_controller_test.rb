require 'test_helper'

class StaticControllerTest < ActionDispatch::IntegrationTest
  test 'static home exists' do
    get root_path
    assert_response :success
    assert_select 'title', 'Formic Learning'
  end

  test 'static about exists' do
    get about_path
    assert_response :success
    assert_select 'title', 'About Us | Formic Learning'
  end

  test 'static features exists' do
    get features_path
    assert_response :success
    assert_select 'title', 'Features | Formic Learning'
  end

  test 'static contact exists' do
    get contact_path
    assert_response :success
    assert_select 'title', 'Contact Us | Formic Learning'
  end

end
