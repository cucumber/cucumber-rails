@announce
Feature: Rails 3
  In order to take over the world
  Cucumber-Rails should work on major versions
  of Rails 3 and Ruby, with Capybara, Spork and DatabaseCleaner

  Scenario: Install Cucumber-Rails
    Given I have a Rails "3.0.0" project named "rails-3-app" with the following appended to Gemfile:
      """
      gem 'capybara', '0.3.9'
      gem 'rspec', '2.0.0.beta.22'
      gem 'cucumber-rails', :path => '../../..' 
      """


    Then the following files should exist:
      | config/cucumber.yml                    |
      | script/cucumber                        |
      | features/step_definitions/web_steps.rb |
      | features/support/env.rb                |
      | features/support/paths.rb              |
      | lib/tasks/cucumber.rake                |
    And the file "features/support/env.rb" should contain "require 'cucumber/rails/world'"
    And the file "features/support/env.rb" should contain "require 'capybara/rails'"

  Scenario Outline: Run Cucumber
    Given I am using rvm "<ruby_version>"
    And I am using rvm gemset "cucumber-rails-3.0.0.beta-gemset-<gemset>" with Gemfile:
      """
      source :gemcutter
      gem 'rails', '3.0.0.rc'
      gem 'sqlite3-ruby', '1.2.5'
      gem 'capybara', '0.3.9'
      gem 'term-ansicolor', '1.0.5'
      gem 'diff-lcs', '1.1.2'
      gem 'rspec-rails', '<rspec_version>'
      """
    And I successfully run "rails new rails-3-app"
    And I cd to "rails-3-app"
    And I append to "Gemfile" with:
      """
      gem 'capybara', '0.3.9'
      gem 'cucumber', '0.8.5' # :path => '../../../../cucumber'
      gem 'cucumber-rails', :path => '../../..'

      """
    And I successfully run "rails generate cucumber:install --capybara"
    And I successfully run "rails generate cucumber:feature post title:string body:text published:boolean"
    And I successfully run "rails generate scaffold post title:string body:text published:boolean"
    And I successfully run "rails generate scaffold cukes name:string"
    And I write to "app/controllers/cukes_controller.rb" with:
      """
      class CukesController < ApplicationController
        def index
          redirect_to cuke_path(10, :overwrite_params => {:name => 'cucumber', :what => 'vegetable'})
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
            |controller|cukes|
            |action|index|
          And I should see "Cuke 10"
      """
    And I successfully run "bundle install"
    And I successfully run "bundle lock"
    And I successfully run "rake db:migrate"
    And I successfully run "rake cucumber"
    Then it should pass with:
       """
       3 scenarios (3 passed)
       14 steps (14 passed)
       """
    
    Examples:
      | ruby_version    | rspec_version | gemset |
      | ruby-1.8.7-p249 | 1.3.2         | 1      |
      | ruby-1.9.1-p378 | 2.0.0.beta.19 | 2      |
