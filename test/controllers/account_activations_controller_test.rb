require 'test_helper'

# noinspection RubyClassModuleNamingConvention
class AccountActivationsControllerTest < ActionDispatch::IntegrationTest
  test 'edit page exists and redirects to root with invalid request' do
    get edit_account_activation_path('invalid request')
    follow_and_assert(true, 'static/home', 'Invalid activation link.')
  end
end
