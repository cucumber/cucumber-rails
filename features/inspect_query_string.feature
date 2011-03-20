Feature: Inspect query string

  Scenario: Inspect query string
    Given I have created a new Rails 3 app "rails-3-app" with cucumber-rails support
    And I successfully run `rails generate cucumber:feature post title:string body:text published:boolean`
    And I successfully run `rails generate scaffold post title:string body:text published:boolean`
    And I successfully run `rails generate scaffold cukes name:string`
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
            | name | cucumber  |
            | what | vegetable |
          And I should see "Cuke 10"
      """
    And I run `bundle exec rake db:migrate cucumber`
    Then it should pass with:
       """
       3 scenarios (3 passed)
       14 steps (14 passed)
       """

