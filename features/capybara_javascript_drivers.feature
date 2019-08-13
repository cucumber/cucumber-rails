@focus
Feature: Capybara Javascript Drivers

  Background: A simple calendar app
    Given I have created a new Rails app and installed cucumber-rails
    And I force selenium to run Firefox in headless mode
    When I run `bundle exec rails g scaffold appointment name:string when:datetime`

  Scenario: Use a particular driver
    When I write to "features/create_appointment.feature" with:
      """
      @javascript
      Feature: Create appointments
        Scenario: Visit the Constitution on May 17
          Given I am on the new appointment page
          And I fill in "Norway's constitution" for "Name"
          And I select "2015-02-20 15:10:00 UTC" as the "When" date and time
          And I press "Create Appointment"
          Then I should see "Norway's constitution"
          And I should see "2015-02-20 15:10:00 UTC"
      """
    And I write to "features/create_appointment_steps.rb" with:
      """
      Given('I am on the new appointment page') do
        visit new_appointment_path
      end

      When('I fill in {string} for {string}') do |value, field|
        fill_in(field, with: value)
      end

      When('I press {string}') do |button|
        click_button(button)
      end

      Then('I should see {string}') do |text|
        expect(page).to have_content(text)
      end

      When('I select {string} as the {string} date and time') do |datetime, selector|
        select_datetime(datetime, from: selector)
      end
      """
    And I run `bundle exec rake db:migrate`
    And I run `bundle exec rake cucumber`
    Then the feature run should pass with:
      """
      1 scenario (1 passed)
      6 steps (6 passed)
      """

  Scenario: Mixed DB access
    When I write to "features/create_appointment.feature" with:
      """
      @javascript
      Feature: Create appointments
        Scenario: Visit the Constitution on May 17
          Given a random appointment
          And I am viewing the appointment
          Then I should see "Random appointment"
      """
    And I write to "features/step_definitions/create_appointment_steps.rb" with:
      """
      Given('a random appointment') do
        @appointment = Appointment.create!(name: 'Random appointment', when: DateTime.now)
      end

      Given('I am viewing the appointment') do
        visit appointment_path(@appointment)
      end

      Then('I should see {string}') do |text|
        expect(page).to have_content(text)
      end
      """
    And I run `bundle exec rake db:migrate`
    And I run `bundle exec rake cucumber`
    Then the feature run should pass with:
      """
      1 scenario (1 passed)
      3 steps (3 passed)
      """
