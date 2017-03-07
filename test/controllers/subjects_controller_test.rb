require 'test_helper'

class SubjectsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user)
  end

  test 'should get show' do
    log_in_as @user
    get subjects_show_url
    assert_response :success
  end

end
