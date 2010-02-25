@announce-cmd
Feature: Run rails2
  In order to take over the world
  Cucumber-Rails should work on major versions
  of Rails2 and Ruby
  
  Scenario: Generate a simple feature
    Given I am using rvm "1.8.7"
    And I am using rvm gemset "cucumber-rails-2.3.5"
    And I successfully run "rails rails-2-app"
    And I cd to "rails-2-app"
    And I symlink this repo to "vendor/plugins/cucumber-rails"
    And I successfully run "ruby script/generate cucumber --capybara"
    And I successfully run "ruby script/generate feature post title:string body:text published:boolean"
    And I successfully run "ruby script/generate scaffold post title:string body:text published:boolean"
    And I successfully run "rake db:migrate"
    When I successfully run "rake cucumber"
    Then it should pass with:
      """
      2 scenarios (2 passed)
      11 steps (11 passed)
      """
