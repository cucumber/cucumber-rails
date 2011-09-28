Feature: Mongoid

  Scenario: Keep Mongoid happy
    Given I successfully run `rails new cuke-app -O`
    And I cd to "cuke-app"
    And I append to "Gemfile" with:
      """
      gem "cucumber-rails", :group => :test, :path => '../../..'
      gem "capybara", :group => :test
      gem "database_cleaner", :group => :test
      gem "mongoid", :group => :test
      gem "bson_ext", :group => :test

      """
    And I successfully run `bundle exec rails generate cucumber:install --skip-database`
    And I successfully run `bundle exec rails generate mongoid:config`
    And I write to "features/tests.feature" with:
      """
      Feature: Tests
        Scenario: Tests
          When I go to the home page
      """
    And I write to "features/step_definitions/web_steps.rb" with:
      """
      When /^I go to the home page$/ do
        visit '/'
      end
      """
    And I overwrite "features/support/env.rb" with:
      """
      require 'cucumber/rails'
      DatabaseCleaner.orm = 'mongoid'
      DatabaseCleaner.strategy = :truncation
      """
    And I run `bundle exec rake cucumber`
    Then it should pass with:
      """
      1 scenario (1 passed)
      1 step (1 passed)
      """
