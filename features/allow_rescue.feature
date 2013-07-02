Feature: Allow Cucumber to rescue exceptions

  Background: A controller that raises an exception
    Given I have created a new Rails 3 app with no database and installed cucumber-rails
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
      TestApp::Application.routes.draw do
        resources :posts
      end
      """

  Scenario: Allow rescue
    Given I write to "features/posts.feature" with:
      """
      Feature: posts
        @allow-rescue
        Scenario: See posts
          When I look at the posts
      """
    And I write to "features/step_definitions/posts_steps.rb" with:
      """
      When /^I look at the posts$/ do
        visit '/posts'
      end
      """
    And I run `bundle exec cucumber`
    Then it should pass with:
      """
      1 scenario (1 passed)
      1 step (1 passed)
      """

  Scenario: Exceptions app rescues exceptions
    Given I write to "config/initializers/exception_app.rb" with:
      """
      Rails.application.config.exceptions_app = Proc.new { [500, {}, "Custom Server Error"] }
      """
    Given I write to "features/posts.feature" with:
      """
      Feature: posts
        @allow-rescue
        Scenario: See posts
          When I look at the posts
          Then I see the exceptions app
      """
    And I write to "features/step_definitions/posts_steps.rb" with:
      """
      When /^I look at the posts$/ do
        visit '/posts'
      end

      Then /^I see the exceptions app$/ do
        page.should have_content "Custom Server Error"
      end
      """
    And I run `bundle exec cucumber`
    Then it should pass with:
      """
      1 scenario (1 passed)
      2 steps (2 passed)
      """

  Scenario: Don't allow rescue
    Given I write to "features/posts.feature" with:
      """
      Feature: posts
        Scenario: See them
          When I look at the posts
      """
    And I write to "features/step_definitions/posts_steps.rb" with:
      """
      When /^I look at the posts$/ do
        visit '/posts'
      end
      """
    And I run `bundle exec cucumber`
    Then it should fail with:
       """
       1 scenario (1 failed)
       1 step (1 failed)
       """

