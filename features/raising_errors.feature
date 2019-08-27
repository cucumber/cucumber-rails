Feature: Raise Errors

  Scenario: Raise error for undefined route
    Given I have created a new Rails app with no database and installed cucumber-rails
    When I write to "features/home.feature" with:
      """
      Feature: Tests
        Scenario: Tests
          When I go to the home page
      """
    And I write to "features/home_steps.rb" with:
      """
      When('I go to the home page') do
        visit('/')
      end
      """
    And I run `bundle exec cucumber`
    Then it should fail with:
      """
      1 scenario (1 failed)
      1 step (1 failed)
      """
