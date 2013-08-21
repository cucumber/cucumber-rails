@focus
Feature: Capybara Javascript Drivers

  Background: A simple calendar app
    Given I have created a new Rails app and installed cucumber-rails
    And I successfully run `bundle exec rails g scaffold appointment name:string when:datetime`
    And I write to "features/step_definitions/date_time_steps.rb" with:
      """
      When /^(?:|I )select "([^"]+)" as the "([^"]+)" time$/ do |time, selector|
        select_time(time, :from => selector)
      end

      When /^(?:|I )select "([^"]+)" as the "([^"]+)" date$/ do |date, selector|
        select_date(date, :from => selector)
      end

      When /^(?:|I )select "([^"]+)" as the "([^"]+)" date and time$/ do |datetime, selector|
        select_datetime(datetime, :from => selector)
      end
      """

  Scenario: Use a particular driver
    Given I write to "features/create_appointment.feature" with:
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
    When I run `bundle exec rake db:migrate`
    And I run `bundle exec rake cucumber`
    Then it should pass with:
      """
      1 scenario (1 passed)
      6 steps (6 passed)
      """

  Scenario: Mixed DB access
    Given I write to "features/create_appointment.feature" with:
      """
      @javascript
      Feature: Create appointments
        Scenario: Constitution on May 17
          Given a random appointment
          And I am viewing random appointment
          Then I should see "Random appointment"

      """
    And I write to "features/step_definitions/custom_steps.rb" with:
      """
      Given /^a random appointment$/ do
        @appointment = Appointment.create!(:name => 'Random appointment', :when => DateTime.now)
      end

      Given /^I am viewing random appointment$/ do
        visit appointment_path(@appointment)
      end
      """

    When I run `bundle exec rake db:migrate`
    And I run `bundle exec rake cucumber`
    Then it should pass with:
      """
      1 scenario (1 passed)
      3 steps (3 passed)
      """
