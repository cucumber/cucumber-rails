Feature: Run rails2
  In order to take over the world
  Cucumber-Rails should work on major versions
  of Rails2 and Ruby
  
  Scenario: Generate a simple feature
    Given I am using rvm "1.8.7"
    And I am using rvm gemset "cucumber-rails-2.3.5"
    And I run "rails rails-2-app"
    And I cd to "rails-2-app"
    And I run "ruby script/generate cucumber --capybara"
    And I run "script/generate feature post title:string body:text published:boolean"
    And I run "script/generate scaffold post title:string body:text published:boolean"
    And I run "rake db:migrate"
    When I run "rake cucumber"
    Then it should pass with:
      """
      Jalla
      """
