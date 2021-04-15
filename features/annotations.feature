Feature: Annotations

  In order to track my development progress
  As a developer
  I should be able to list annotations in my features

  Scenario: See annotations in feature file
    Given I have created a new Rails app with no database and installed cucumber-rails
    When I write to "features/products.feature" with:
      """
      Feature: Products
        Scenario: Test a Product
          # TODO: When I go to the products page
      """
    When I run `bundle exec rails notes`
    Then it should pass with:
      """
      features/products.feature:
        * [3] [TODO] When I go to the products page
      """
