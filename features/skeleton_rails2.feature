Feature: Rails 2 script/generate cucumber
  In order to quickly set up Cucumber
  As a Rails developer
  I want to have the Cucumber skeleton generated automatically

  Scenario Outline: Rails 2 with webrat
    Given I am using rvm "1.8.7"
    And I am using rvm gemset "cucumber-rails-2.3.5"
    When I successfully run "rails rails-2-app"
    Then it should pass with:
      """
      create  README
      """
    And I cd to "rails-2-app"
    When I successfully run "ruby script/generate cucumber <webtesting> <assertions> <spork>"
    Then the following files should exist:
      | config/cucumber.yml                    |
      | config/environments/cucumber.rb        |
      | script/cucumber                        |
      | features/step_definitions/web_steps.rb |
      | features/support/env.rb                |
      | features/support/paths.rb              |
      | lib/tasks/cucumber.rake                |
    And the file "features/support/env.rb" should contain "<env_rb_1>"
    And the file "features/support/env.rb" should contain "<env_rb_2>"
    And the file "config/environments/cucumber.rb" should contain "<cucumber_rb_1>"
    And the file "config/environments/cucumber.rb" should contain "<cucumber_rb_2>"
    And the file "config/database.yml" should contain "cucumber:"

    Examples:
      | webtesting | assertions | spork | env_rb_1                       | env_rb_2                 | cucumber_rb_1         | cucumber_rb_2                 |
      | --webrat   | --rspec    |       | require 'cucumber/rails/rspec' | require 'webrat'         | config.gem 'webrat'   | config.gem 'rspec-rails'      |
      | --capybara | --testunit |       | require 'cucumber/rails/world' | require 'capybara/rails' | config.gem 'capybara' | config.gem 'database_cleaner' |
