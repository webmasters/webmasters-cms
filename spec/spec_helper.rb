# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../test/dummy/config/environment", __FILE__)
require 'rspec/rails'
require 'factory_bot_rails'
require 'capybara/rspec'
require 'selenium-webdriver'
require 'database_cleaner'
require 'puma'

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.use_transactional_fixtures = false
  config.mock_with :rspec
  config.infer_base_class_for_anonymous_controllers = false
  config.include FactoryBot::Syntax::Methods
  config.include WebmastersCms::Engine.routes.url_helpers
  config.include Capybara::DSL
  config.before(:suite) do
    FileUtils.rm_rf Rails.root.join('public/system').to_s
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end
  
  config.after(:suite) do
    FileUtils.rm_rf Rails.root.join('public/system').to_s
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
  
  Rails.backtrace_cleaner.remove_silencers!

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  # Checks for pending migrations before tests are run.
  # If you are not using ActiveRecord, you can remove this line.
  ActiveRecord::Migration.maintain_test_schema!

  Capybara.javascript_driver = :selenium
  Capybara.server = :puma, { :Silent => true }
end
