ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # Optionally follow a redirect, then assert page template, then assert alert message
  def follow_and_assert(follow, template, alert)
    if follow
      follow_redirect!
    end
    assert_template template
    assert_select '.alert', alert
  end
end
