ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'database_cleaner'

Capybara.default_driver = :poltergeist
Capybara.javascript_driver = :poltergeist

DatabaseCleaner.strategy = :truncation

class ActiveSupport::TestCase
  self.use_transactional_fixtures = false
  setup do
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
  end
end


require_relative Rails.root + 'test/support/varnish_test_helper'
class ActiveSupport::TestCase
  include VarnishTestHelper
end
VarnishTestHelper.setup!
