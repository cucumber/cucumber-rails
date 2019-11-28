Feature: Allow Cucumber to rescue exceptions

  Background: A controller that raises an exception
    Given I have created a new Rails app and installed cucumber-rails
    When I write to "app/controllers/posts_controller.rb" with:
      """
      class PostsController < ApplicationController
        def index
          raise 'There is an error in index'
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
    When I write to "features/posts.feature" with:
      """
      Feature: Posts
        @allow-rescue
        Scenario: See posts
          When I look at the posts
          Then I should see the public error page
      """
    And I write to "features/step_definitions/posts_steps.rb" with:
      """
      When('I look at the posts') do
        visit '/posts'
      end

      Then('I should see the public error page') do
        expect(page).to have_content "We're sorry, but something went wrong."
      end
      """
    And I run `bundle exec rake db:migrate`
    And I run `bundle exec cucumber`
    Then the feature run should pass with:
      """
      1 scenario (1 passed)
      2 steps (2 passed)
      """

  Scenario: Don't allow rescue
    When I write to "features/posts.feature" with:
      """
      Feature: Posts
        Scenario: See them
          When I look at the posts
      """
    And I write to "features/step_definitions/posts_steps.rb" with:
      """
      When('I look at the posts') do
        visit '/posts'
      end
      """
    And I run `bundle exec rake db:migrate`
    And I run `bundle exec cucumber`
    Then it should fail with:
       """
       1 scenario (1 failed)
       1 step (1 failed)
       """
