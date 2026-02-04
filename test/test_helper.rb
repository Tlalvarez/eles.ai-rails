ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Disable parallel testing for SQLite compatibility
    parallelize(workers: 1)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

class ActionDispatch::IntegrationTest
  def sign_in(user)
    post login_path, params: {
      session: { email: user.email, password: "password123" }
    }
    follow_redirect! if response.redirect?
  end

  def sign_in_as(email)
    user = User.find_by(email: email)
    sign_in(user)
  end
end
