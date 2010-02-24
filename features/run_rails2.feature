Feature: Run rails2
  In order to take over the world
  Cucumber-Rails should work on major versions
  of Rails2 and Ruby
  
  Background: A full Rails app
    Given I'm using Ruby 1.8.7 and Rails 2.3.5
    And a Rails app "rails-2-app"
    And I run "script/generate cucumber" in the app

  Scenario: Generate a simple feature
    When I run "script/generate feature post title:string body:text published:boolean" in the app
    And I run "script/generate scaffold post title:string body:text published:boolean" in the app
    And I run "rake db:migrate" in the app
    And I run "rake cucumber" in the app
