require 'simplecov'
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new()]
SimpleCov.start 'rails' do
  add_filter('/jobs/')
  add_filter('/channels/')
  add_filter('/helpers/')
  add_filter('/mailers/')
  add_filter('/controllers/omniauth_callbacks_controller')
  add_filter do |source_file|
    source_file.lines.count < 4
  end
end
puts 'Started successfully!'
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"


class ActiveSupport::TestCase

  def setup
    self.default_url_options = { locale: I18n.default_locale }
  end
  # Run tests in parallel with specified workers
  #parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def google_oauth2_mock
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: "google_oauth2",
      uid: "12345678910",
      info: {
          email: "fakeemail@gmail-fake.com",
          first_name: "David",
          last_name: "McDonald"
      },
      credentials: {
          token: "abcdefgh12345",
          refresh_token: "12345abcdefgh",
          expires_at: DateTime.now
      }
    })
  end
end
