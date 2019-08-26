Feature: Cucumber Rails Configuration

  In order to configure how Cucumber-Rails runs
  As a developer
  I should be able to alter the settings of my project

  Background:
    Given I have created a new Rails app with no database and installed cucumber-rails
    When I write to "features/step_definitions/config_steps.rb" with:
      """
      Given('I boot up cucumber rails normally') do
        puts 'nothing altered'
      end

      Then('`Rack::Test` should be included as an ancestor of `World`') do
        expect(self.class.ancestors).to include(Rack::Test::Methods)
      end

      Then('`Rack::Test` should not be included as an ancestor of `World`') do
        expect(self.class.ancestors).not_to include(Rack::Test::Methods)
      end
      """

  Scenario: Default configuration
    When I write to "features/config.feature" with:
      """
      Feature: Rack Test Methods
        Scenario: Default Methods are added to the World
          Given I boot up cucumber rails normally
          Then `Rack::Test` should be included as an ancestor of `World`
      """
    And I run `bundle exec rake cucumber`
    Then the feature run should pass with:
      """
      1 scenario (1 passed)
      2 steps (2 passed)
      """

  Scenario: Altered configuration
    Given I set the environment variable "CR_REMOVE_RACK_TEST_HELPERS" to "true"
    When I write to "features/config.feature" with:
      """
      Feature: Rack Test Methods
        Scenario: Default Methods are added to the World
          Given I boot up cucumber rails normally
          Then `Rack::Test` should not be included as an ancestor of `World`
      """
    And I run `bundle exec rake cucumber`
    Then the feature run should pass with:
      """
      1 scenario (1 passed)
      2 steps (2 passed)
      """
