Feature: Install Cucumber Rails

  Cucumber-Rails should work on supported versions
  of Ruby on Rails, with Capybara and DatabaseCleaner

  Scenario: Install Cucumber-Rails
    Given I have created a new Rails app and installed cucumber-rails
    Then the following files should exist:
      | config/cucumber.yml                    |
      | script/cucumber                        |
      | features/support/env.rb                |
      | features/step_definitions/.gitkeep     |
      | lib/tasks/cucumber.rake                |
    And the file "features/support/env.rb" should contain "require 'cucumber/rails'"
