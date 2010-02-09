Feature: cucumber:skeleton
  In order to quickly set up Cucumber
  As a Rails developer
  I want to have the Cucumber skeleton generate automatically

  Scenario: Rails 2 with Capybara
    Given I'm using Ruby 1.8.7 and Rails 2.3.5
    And a Rails app "rails-2-app"
    When I run "script/generate cucumber --capybara" in the app
    Then I will have the following new files and directories
      | name                                   |
      | config/cucumber.yml                    |
      | config/environments/cucumber.rb        |
      | script/cucumber                        |
      | features/step_definitions              |
      | features/step_definitions/web_steps.rb |
      | features/support                       |
      | features/support/env.rb                |
      | features/support/paths.rb              |
      | lib/tasks                              |
      | lib/tasks/cucumber.rake                |
