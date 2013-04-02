Feature: Fixing Bundler Pre
  In order to keep fix a problem with bundler and rails
  As a user with cucumber-rails outside of test group in my Gemfile
  I want run features without errors
  
  @bundler-pre
  Scenario: Install Cucumber-Rails with bundler prerelease
    Given I have created a new Rails app and installed cucumber-rails, accidentally outside of the test group in my Gemfile
    And I successfully run `rake db:migrate`
    And I write to "app/controllers/home_controller.rb" with:
      """
      class HomeController < ActionController::Base
        def index
        end
      end
      """
    And I write to "config/routes.rb" with:
      """
      TestApp::Application.routes.draw do
        root to: 'home#index'
      end
      """
    And I write to "app/views/home/index.html.erb" with: 
      """
      h1 Test App
      """
    And I write to "features/tests.feature" with:
      """
      Feature: Tests
        Scenario: Tests
          When I go to the home page
      """
    And I run `bundle exec rake cucumber`
    Then it should pass with:
      """
      1 scenario (1 passed)
      1 step (1 passed)
      """
    And the output should contain "WARNING:"
    And the output should contain ":require => false"


