Feature: Routing

  Scenario: Visit undefined route
    Given I have created a new Rails app with no database and installed cucumber-rails
    And I write to "features/tests.feature" with:
      """
      Feature: Tests
        Scenario: Tests
          When I go to the home page
      """
    And I run `rake cucumber`
    Then it should fail with:
      """
      1 scenario (1 failed)
      1 step (1 failed)
      """
    And the stdout should contain "ActionController::RoutingError"
