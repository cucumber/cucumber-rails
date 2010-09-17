@announce
Feature: Rails 2
  In order to take over the world
  Cucumber-Rails should work on major versions
  of Rails2 and Ruby, with Capybara, Webrat, Spork and DatabaseCleaner

  Scenario: Run Cucumber
    Given a Rails "2.3.5" project named "rails-2-app" with Cucumber-Rails generated with "--capybara --rspec"

    Given break
    And I symlink "../../../../cucumber" to "vendor/plugins/cucumber"
    And I symlink "../../.." to "vendor/plugins/cucumber-rails"
    And I successfully run "ruby script/generate cucumber --capybara"
    And I successfully run "ruby script/generate feature post title:string body:text published:boolean <feature_args>"
    And I successfully run "ruby script/generate scaffold post title:string body:text published:boolean"
    And I successfully run "ruby script/generate scaffold cukes name:string"
    And I write to "app/controllers/cukes_controller.rb" with:
      """
      class CukesController < ApplicationController
        def index
          redirect_to cuke_path(10, :params => {:name => 'cucumber', :what => 'vegetable'})
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
            |name|cucumber|
            |what|vegetable|
          And I should see "Cuke 10"
      """
    And I successfully run "rake db:migrate"
    When I successfully run "rake cucumber"
    Then it should pass with:
      """
      3 scenarios (3 passed)
      14 steps (14 passed)
      """
