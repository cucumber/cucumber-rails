@announce
Feature: Rails 3
  In order to take over the world
  Cucumber-Rails should work on major versions
  of Rails 3 and Ruby, with Capybara, Spork and DatabaseCleaner

  Scenario: Install Cucumber-Rails
    Given I have created a new Rails 3 app "rails-3-app" with cucumber-rails support
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
    Given I have created a new Rails 3 app "rails-3-app" with cucumber-rails support
    When I successfully run "bundle install"
    And I successfully run "rails generate cucumber:feature post title:string body:text published:boolean"
    And I successfully run "rails generate scaffold post title:string body:text published:boolean"

    And I successfully run "rails generate scaffold cukes name:string"
    And I overwrite "app/controllers/cukes_controller.rb" with:
      """
      class CukesController < ApplicationController
        def index
          redirect_to cuke_path(10, {:name => 'cucumber', :what => 'vegetable'})
        end
        
        def show
          render :text => "Cuke #{params[:id]}"
        end
      end
      """
    And I write to "features/tests.feature" with:
      """
      Feature: Tests
        Scenario: Tests
          When I go to the cukes page
          Then I should have the following query string: 
            | name       | cucumber  |
            | what       | vegetable |
          And I should see "Cuke 10"
      """
    And I successfully run "rake db:migrate"
    And I successfully run "rake cucumber"
    Then it should pass with:
       """
       3 scenarios (3 passed)
       14 steps (14 passed)
       """
