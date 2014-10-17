# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # from: http://www.without-brains.net/blog/2012/08/01/capybara-and-selenium-with-vagrant/
  #
  # Set the default driver to CAPYBARA_DRIVER, when you change the driver in one
  # of your tests resetting it to the default will ensure that its reset to what
  # you specified when starting the tests.
  # possible options for ENV["CAPYBARA_DRIVER"]: selenium_chrome selenium_firefox mobile poltergeist poltergeist_quite_errors poltergeist_debug
  capybara_driver_key = (ENV["CAPYBARA_DRIVER"] || :poltergeist_quite_errors).to_sym
  Capybara.default_driver = capybara_driver_key
  Capybara.javascript_driver = capybara_driver_key
  Capybara.default_wait_time = 30

  Capybara.register_driver :poltergeist_quite_errors do |app|
      Capybara::Poltergeist::Driver.new(app, :js_errors => false)
  end

  Capybara.register_driver :poltergeist_debug do |app|
      Capybara::Poltergeist::Driver.new(app, :inspector => true, :js_errors => false)
  end

  # CapybaraDriverRegistrar is a helper class that enables you to easily register
  # Capybara drivers
  class CapybaraDriverRegistrar
    # register a Selenium driver for the given browser to run on the localhost
    def self.register_selenium_local_driver(browser)
      Capybara.register_driver "selenium_#{browser}".to_sym do |app|
        Capybara::Selenium::Driver.new(app, browser: browser)
      end
    end
  end

  # Register various Selenium drivers
  CapybaraDriverRegistrar.register_selenium_local_driver(:firefox)
  CapybaraDriverRegistrar.register_selenium_local_driver(:chrome)
  
  # Register mobile using Chrome
  Capybara.register_driver :mobile do |app|
    user_agent = 'Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3'
    500
    if Capybara.default_driver == :poltergeist_quite_errors
      driver = Capybara::Poltergeist::Driver.new(app, :js_errors => false)
      driver.headers = {"User-Agent" => user_agent}
      driver.resize 320, 480
      driver
    elsif Capybara.default_driver == :poltergeist_debug
      driver = Capybara::Poltergeist::Driver.new(app, :inspector => true, :js_errors => false)
      driver.headers = {"User-Agent" => user_agent}
      driver.resize 320, 480
      driver
    else
      args = []
      # args << "--window-size=320,480"
      # you can also set the user agent 
      args << "--user-agent='#{user_agent}'"
      Capybara::Selenium::Driver.new(app, :browser => :chrome, :args => args)
    end
  end

  config.include Capybara::DSL
end
