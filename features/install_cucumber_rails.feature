Feature: Rails 3
  In order to take over the world
  Cucumber-Rails should work on major versions
  of Rails 3 and Ruby, with Capybara, Spork and DatabaseCleaner

  Scenario: Install Cucumber-Rails
    Given I have created a new Rails 3 app "rails-3-app" with cucumber-rails support
    Then the following files should exist:
      | config/cucumber.yml                    |
      | script/cucumber                        |
      | features/support/env.rb                |
      | lib/tasks/cucumber.rake                |
    And the file "features/support/env.rb" should contain "require 'cucumber/rails'"