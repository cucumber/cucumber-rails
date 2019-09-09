Feature: Cucumber Rails Configuration

  In order to configure how Cucumber-Rails runs
  As a developer
  I should be able to alter the settings of my project

  Scenario: Default configuration
    Given I have created a new Rails app with no database and installed cucumber-rails
    When I write to "features/config.feature" with:
      """
      Feature: Rack Test Methods
        Scenario: Default Methods are added to the World
          Then Rack Test should be mixed into the Cucumber World
      """
    When I write to "features/step_definitions/config_steps.rb" with:
      """
      Then('Rack Test should be mixed into the Cucumber World') do
        expect(self.class.ancestors).to include(Rack::Test::Methods)
      end
      """
    And I run `bundle exec rake cucumber`
    Then the feature run should pass with:
      """
      1 scenario (1 passed)
      1 step (1 passed)
      """

  Scenario: Altered configuration
    Given I have created a new Rails app with no database and installed cucumber-rails
    And I set the environment variable "CR_REMOVE_RACK_TEST_HELPERS" to "true"
    When I write to "features/config.feature" with:
      """
      Feature: Rack Test Methods
        Scenario: Rack Test Methods can be removed from the world
          Then Rack Test should not be mixed into the Cucumber World
      """
    When I write to "features/step_definitions/config_steps.rb" with:
      """
      Then('Rack Test should not be mixed into the Cucumber World') do
        expect(self.class.ancestors).not_to include(Rack::Test::Methods)
      end
      """
    And I run `bundle exec rake cucumber`
    Then the feature run should pass with:
      """
      1 scenario (1 passed)
      1 step (1 passed)
      """
