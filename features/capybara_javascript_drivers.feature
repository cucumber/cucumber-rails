Feature: Capybara Javascript Drivers

  Background: A simple calendar app
    Given I have created a new Rails 3 app "rails-3-app" with cucumber-rails support
    And I successfully run `bundle exec rails g scaffold appointment name:string when:datetime`
    And I write to "features/create_appointment.feature" with:
      """
      @javascript
      Feature: Create appointments
        Scenario: Constitution on May 17
          Given I am on the new appointment page
          And I fill in "Norway's constitution" for "Name"
          And I select "2009-02-20 15:10:00 UTC" as the "When" date and time
          And I press "Create Appointment"
          Then I should see "Norway's constitution"
          And I should see "2009-02-20 15:10:00 UTC"

      """
  
  Scenario Outline: Use a particular driver
    Given I append to "Gemfile" with:
      """
      <Gemfile extra>

      """
    And I append to "features/support/env.rb" with:
      """
      <env.rb extra>

      """

    When I run `bundle exec rake db:migrate cucumber`
    Then it should pass with:
      """
      1 scenario (1 passed)
      6 steps (6 passed)
      """
      
    Examples:
      | Gemfile extra                    | env.rb extra                                                  |
      | gem "akephalos", :group => :test | require 'akephalos' ; Capybara.javascript_driver = :akephalos |
    
