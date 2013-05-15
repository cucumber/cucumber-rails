Feature: Rails
  In order to take over the world
  Cucumber-Rails should work on major versions
  of Rails 3 or 4 and Ruby, with Capybara, Spork and DatabaseCleaner

  Scenario: Install Cucumber-Rails
    Given I have created a new Rails app and installed cucumber-rails
    Then the following files should exist:
      | config/cucumber.yml                    |
      | script/cucumber                        |
      | features/support/env.rb                |
      | lib/tasks/cucumber.rake                |
    And the file "features/support/env.rb" should contain "require 'cucumber/rails'"