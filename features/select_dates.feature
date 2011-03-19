Feature: Allow Cucumber to rescue exceptions

  Background: A simple calendar app
    Given I have created a new Rails 3 app "rails-3-app" with cucumber-rails support
    And I successfully run "bundle exec rails g scaffold appointment name:string when:datetime"
  
  Scenario: Select dates
    Given I write to "features/create_appointment.feature" with:
      """
      Feature: Create appointments
        Scenario: Constitution on May 17
          Given I am on the new appointment page
          And I fill in "Norway's constitution" for "Name"
          And I select "2009-02-20 15:10:00 UTC" as the "When" date and time
          And I press "Create Appointment"
          Then I should see "Norway's constitution"
          And I should see "2009-02-20 15:10:00 UTC"
      """
    When I run "bundle exec rake db:migrate cucumber"
    Then it should pass with:
      """
      1 scenario (1 passed)
      6 steps (6 passed)
      """
    
