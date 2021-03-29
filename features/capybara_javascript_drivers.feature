Feature: Capybara Javascript Drivers

  Scenario: Use a particular driver
    Given I have created a new Rails app and installed cucumber-rails
    And I force selenium to run Firefox in headless mode
    When I run `bundle exec rails g scaffold appointment name:string when:datetime`
    And I write to "features/create_appointment.feature" with:
      """
      @javascript
      Feature: Create appointments
        Scenario: Create an appointment using the Web Interface
          Given I am on the new appointment page
          And I fill in "Cucumber Trainee" for "Name"
          And I select "2026-02-20 15:10:00 UTC" as the "When" date and time
          And I press "Create Appointment"
          Then I should see "Cucumber Trainee"
          And I should see "2026-02-20 15:10:00 UTC"
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
    Given I have created a new Rails app and installed cucumber-rails
    And I force selenium to run Firefox in headless mode
    When I run `bundle exec rails g scaffold appointment name:string when:datetime`
    And I write to "features/create_appointment.feature" with:
      """
      @javascript
      Feature: Create appointments
        Scenario: Create appointment using DB injection
          Given a random appointment
          And I am viewing the appointment
          Then I should see the correct appointment details
      """
    And I write to "features/step_definitions/create_appointment_steps.rb" with:
      """
      Given('a random appointment') do
        @when = DateTime.now
        @name = 'Random appointment for Cucumber Trainee'
        @appointment = Appointment.create!(name: @name, when: @when)
      end

      Given('I am viewing the appointment') do
        visit appointment_path(@appointment)
      end

      Then('I should see the correct appointment details') do
        expect(page).to have_text(@when)

        expect(page).to have_text(@name)
      end
      """
    And I run `bundle exec rake db:migrate`
    And I run `bundle exec rake cucumber`
    Then the feature run should pass with:
      """
      1 scenario (1 passed)
      3 steps (3 passed)
      """

  Scenario: Use a particular driver without a DB
    Given I have created a new Rails app and installed cucumber-rails without database_cleaner
    And I force selenium to run Firefox in headless mode
    When I run `bundle exec rails g scaffold appointment name:string when:datetime`
    And I write to "features/create_appointment.feature" with:
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
    And I append to "features/support/env.rb" with:
      """
        Cucumber::Rails::Database.autorun_database_cleaner = false
      """
    And I run `bundle exec rake db:migrate`
    And I run `bundle exec rake cucumber`
    Then the feature run should pass with:
      """
      1 scenario (1 passed)
      6 steps (6 passed)
      """
