ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'database_cleaner'
require_relative Rails.root + 'test/support/varnish_test_helper'

Capybara.default_driver = :poltergeist
Capybara.javascript_driver = :poltergeist

DatabaseCleaner.strategy = :truncation

class ActiveSupport::TestCase
  include VarnishTestHelper

  self.use_transactional_fixtures = false
  setup do
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
  end

  def new_session(login=nil)
    session = Capybara::Session.new(:poltergeist)
    if login
      user = User.create(
        email: login,
        password: "password",
        password_confirmation: "password"
      )
      user.confirm
      session.visit varnish_uri(new_user_session_path)
      session.fill_in 'Email', with: 'alec.hipshear@gmail.com'
      session.fill_in 'Password', with: 'password'
      session.click_button 'Log in'
    end

    session
  end
end

VarnishTestHelper.setup!
