@requires-rails-version-42
Feature: Annotations

  I order to track my development progress
  As a developer
  I should be able to list annotations in my features

  Background:
    Given I have created a new Rails app "test-app" with no database and installed cucumber-rails
    And I write to "features/tests.feature" with:
      """
      Feature: Tests
        Scenario: Tests
          # TODO: When I go to the products page
      """

  Scenario: See annotations in .feature file
    When I run `bundle exec rake notes`
    Then it should pass with:
      """
      features/tests.feature:
        * [ 3] [TODO] When I go to the products page
      """
