Feature: Raise Errors

  Scenario: Raise error for undefined route
    Given I have created a new Rails app "test-app" with no database and installed cucumber-rails
    And I write to "features/tests.feature" with:
      """
      Feature: Tests
        Scenario: Tests
          When I go to the products page
      """
    And I run `bundle exec cucumber`
    Then it should fail with:
      """
      1 scenario (1 failed)
      1 step (1 failed)
      """