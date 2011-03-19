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
      | features/support/selectors.rb          |
      | lib/tasks/cucumber.rake                |
    And the file "features/support/env.rb" should contain "require 'cucumber/rails'"

  Scenario: Inspect query string
    Given I have created a new Rails 3 app "rails-3-app" with cucumber-rails support
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
            | name | cucumber  |
            | what | vegetable |
          And I should see "Cuke 10"
      """
    And I run "bundle exec rake db:migrate cucumber"
    Then it should pass with:
       """
       3 scenarios (3 passed)
       14 steps (14 passed)
       """

   Scenario: No ActiveRecord and DatabaseCleaner
     Given I have created a new Rails 3 app "rails-3-app" with cucumber-rails support
     # Turn off ActiveRecord
     And I write to "config/application.rb" with:
       """
       require File.expand_path('../boot', __FILE__)

       require 'action_controller/railtie'
       require 'action_mailer/railtie'
       require 'active_resource/railtie'
       require 'rails/test_unit/railtie'

       Bundler.require(:default, Rails.env) if defined?(Bundler)

       module Rails3App
         class Application < Rails::Application
           config.encoding = "utf-8"
           config.filter_parameters += [:password]
         end
       end
       """
     And I remove the file "config/database.yml"
     And I overwrite "features/support/env.rb" with:
       """
       require 'cucumber/rails'
       """
     # Remove DatabaseCleaner and SQLite
     And I write to "Gemfile" with:
       """
       source 'http://rubygems.org'
       gem 'rails'
       gem "cucumber-rails", :group => :test, :path => "../../.."
       gem "capybara", :group => :test
       gem "rspec-rails", :group => :test
       """
     And I write to "app/controllers/posts_controller.rb" with:
       """
       class PostsController < ApplicationController
         def index
           raise "There is an error in index"
         end
       end
       """
     And I write to "config/routes.rb" with:
       """
       Rails3App::Application.routes.draw do
         resources :posts
       end
       """
     And I write to "features/posts.feature" with:
       """
       Feature: posts
         Scenario: See them
           When I do it
       """
     And I write to "features/step_definitions/posts_steps.rb" with:
       """
       When /^I do it$/ do
         visit '/posts'
       end
       """
     And I run "bundle exec rake cucumber"
     Then it should fail with:
        """
        There is an error in index
        """

  Scenario: Compare JSON
    Given I have created a new Rails 3 app "rails-3-app" with cucumber-rails support
    And I write to "app/controllers/posts_controller.rb" with:
      """
      class PostsController < ApplicationController
        def index
          render :json => {'hello' => 'world'}.to_json
        end
      end
      """
    And I write to "config/routes.rb" with:
      """
      Rails3App::Application.routes.draw do
        resources :posts
      end
      """
    And I write to "features/posts.feature" with:
      """
      Feature: posts
        Scenario: See them
          When the client requests GET /posts
          Then the response should be JSON:
            \"\"\"
            {
              "hello": "world"
            }
            \"\"\"
      """
    And I write to "features/step_definitions/rest_steps.rb" with:
      """
      When /^the client requests GET (.*)$/ do |path|
        get(path)
      end

      Then /^the response should be JSON:$/ do |json|
        JSON.parse(last_response.body).should == JSON.parse(json)
      end
      """
    And I run "bundle exec rake db:migrate cucumber"
    Then it should pass with:
       """
       1 scenario (1 passed)
       2 steps (2 passed)
       """

 Scenario: Look within named selector
   Given a project without ActiveRecord
   And a cukes resource
   And I write to "app/views/cukes/index.html.erb" with:
     """
     <div class="foo">foo</div>
     <div class="bar">bar</div>
     """
   And I write to "features/tests.feature" with:
     """
     Feature: Tests
       Scenario: Tests
         When I go to the cukes page
         Then I should see "foo" within the foo div
         And I should not see "bar" within the foo div
     """
   And I overwrite "features/support/selectors.rb" with:
     """
     module HtmlSelectorsHelpers
       def selector_for(locator)
         return '.foo' if locator == 'the foo div'
       end
     end
     World(HtmlSelectorsHelpers)
     """
   And I run "rake cucumber"
   Then it should pass with:
      """
      1 scenario (1 passed)
      3 steps (3 passed)
      """
