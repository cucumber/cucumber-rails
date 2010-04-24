@announce-cmd
Feature: Rails 3
  In order to take over the world
  Cucumber-Rails should work on major versions
  of Rails2 and Ruby, with Capybara, Spork and DatabaseCleaner

  Scenario: Install Cucumber-Rails
    Given I am using rvm "1.8.7"
    And I am using rvm gemset "cucumber-rails-3.0.0.beta" with Gemfile:
      """
      gem 'rails', '3.0.0.beta'
      gem 'sqlite3-ruby', '1.2.5'
      gem 'capybara', '0.3.6'
      """
    When I successfully run "rails rails-3-app"
    Then it should pass with:
      """
      README
      """
    And I cd to "rails-3-app"
    And I symlink this repo to "vendor/plugins/cucumber-rails"
    When I successfully run "rails generate cucumber:skeleton --capybara"
    Then the following files should exist:
      | config/cucumber.yml                    |
      | script/cucumber                        |
      | features/step_definitions/web_steps.rb |
      | features/support/env.rb                |
      | features/support/paths.rb              |
      | lib/tasks/cucumber.rake                |
    And the file "features/support/env.rb" should contain "require 'cucumber/rails/world'"
    And the file "features/support/env.rb" should contain "require 'capybara/rails'"

  Scenario: Run Cucumber
    Given I am using rvm "1.8.7"
    And I am using rvm gemset "cucumber-rails-3.0.0.beta" with Gemfile:
      """
      gem 'rails', '3.0.0.beta'
      gem 'sqlite3-ruby', '1.2.5'
      gem 'capybara', '0.3.6'
      """
    And I successfully run "rails rails-3-app"
    And I cd to "rails-3-app"
    And I symlink this repo to "vendor/plugins/cucumber-rails"
    And I successfully run "rails generate cucumber:skeleton --capybara"
    And I successfully run "rails generate cucumber:feature post title:string body:text published:boolean"
    And I successfully run "rails generate scaffold post title:string body:text published:boolean"
    And I append to "Gemfile" with:
      """
      gem 'cucumber'
      gem 'database_cleaner'
      gem 'capybara'

      """
    And I successfully run "bundle install"
    And I successfully run "rake db:migrate"
    And I successfully run "rake cucumber"
    Then it should pass with:
       """
       2 scenarios (2 passed)
       11 steps (11 passed)
       """
      
