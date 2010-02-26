Feature: Rails 2
  In order to take over the world
  Cucumber-Rails should work on major versions
  of Rails2 and Ruby, with Capybara, Webrat, Spork and DatabaseCleaner

  Scenario Outline: Install Cucumber-Rails
    Given I am using rvm "1.8.7"
    And I am using rvm gemset "cucumber-rails-2.3.5"
    When I successfully run "rails rails-2-app"
    Then it should pass with:
      """
      create  README
      """
    And I cd to "rails-2-app"
    When I successfully run "ruby script/generate cucumber <args>"
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
      | args                  | env_rb_1                       | env_rb_2                 | cucumber_rb_1         | cucumber_rb_2                 |
      | --webrat --rspec      | require 'cucumber/rails/rspec' | require 'webrat'         | config.gem 'webrat'   | config.gem 'rspec-rails'      |
      | --capybara --testunit | require 'cucumber/rails/world' | require 'capybara/rails' | config.gem 'capybara' | config.gem 'database_cleaner' |

    @announce-cmd
    Scenario Outline: Run Cucumber
      Given I am using rvm "1.8.7"
      And I am using rvm gemset "cucumber-rails-2.3.5"
      And I successfully run "rails rails-2-app"
      And I cd to "rails-2-app"
      And I symlink this repo to "vendor/plugins/cucumber-rails"
      And I successfully run "ruby script/generate cucumber --capybara"
      And I successfully run "ruby script/generate feature post title:string body:text published:boolean <feature_args>"
      And I successfully run "ruby script/generate scaffold post title:string body:text published:boolean"
      And I successfully run "rake db:migrate"
      When I successfully run "rake cucumber"
      Then it should pass with:
        """
        2 scenarios (2 passed)
        11 steps (11 passed)
        """

      Examples:
        | feature_args        |
        |                     |
        | --capybara culerity |
