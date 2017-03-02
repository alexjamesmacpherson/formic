require 'simplecov'
SimpleCov.start

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Optionally follow a redirect, then assert page template, then assert alert message
  def follow_and_assert(follow, template, alert)
    if follow
      follow_redirect!
    end
    assert_template template
    assert_select '.alert', alert
  end

  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user)
    session[:user_id] = user.id
  end

  # Redefine log_in_as(user) for integration tests to fully run login process
  class ActionDispatch::IntegrationTest
    def log_in_as(user, password: 'password', remember_me: '1')
      post login_path, params: { session: { email: user.email, password: password, remember_me: remember_me } }
    end
  end
end
