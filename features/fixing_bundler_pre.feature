Feature: Fixing Bundler Pre
  In order to keep fix a problem with bundler and rails
  As a user with cucumber-rails outside of test group in my Gemfile
  I want run features without errors
  
  @bundler-pre
  Scenario: Install Cucumber-Rails with bundler prerelease
    Given I have created a new Rails 3 app "rails-3-app" with cucumber-rails support and cucumber-rails is outside of test group
    And I successfully run `rake db:migrate`
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


