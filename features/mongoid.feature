@announce
Feature: Mongoid

  Scenario: Keep Mongoid happy
    Given I successfully run `rails new cuke-app`
    And I cd to "cuke-app"
    And I write to "config/application.rb" with:
      """
      require File.expand_path('../boot', __FILE__)

      require 'action_controller/railtie'
      require 'action_mailer/railtie'
      require 'active_resource/railtie'
      require 'rails/test_unit/railtie'

      Bundler.require(:default, Rails.env) if defined?(Bundler)

      module CukeApp
        class Application < Rails::Application
          config.encoding = "utf-8"
          config.filter_parameters += [:password]
        end
      end
      """
    And I remove the file "config/database.yml"
    And I append to "Gemfile" with:
      """
      gem "cucumber-rails", :group => :test, :path => '../../..'
      gem "capybara", :group => :test
      gem "database_cleaner", :group => :test
      gem "mongoid", :group => :test
      gem "bson_ext", :group => :test

      """
    And I successfully run `bundle exec rails generate cucumber:install`
    And I successfully run `bundle exec rails generate mongoid:config`
    And I write to "features/tests.feature" with:
      """
      Feature: Tests
        Scenario: Tests
          When I go to the home page
      """
    And I overwrite "features/support/env.rb" with:
      """
      require 'cucumber/rails'
      DatabaseCleaner.strategy = :truncation
      """
    And I run `bundle exec rake cucumber`
    Then it should pass with:
      """
      1 scenario (1 passed)
      1 step (1 passed)
      """
