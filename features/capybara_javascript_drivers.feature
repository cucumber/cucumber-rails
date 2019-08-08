@focus
Feature: Capybara Javascript Drivers

  Background: A simple calendar app
    Given I have created a new Rails app and installed cucumber-rails
    And I force selenium to run Firefox in headless mode
    When I run `bundle exec rails g scaffold appointment name:string when:datetime`
    And I write to "features/step_definitions/date_time_steps.rb" with:
      """
      When('I select {string} as the {string} date and time') do |datetime, selector|
        select_datetime(datetime, from: selector)
      end
      """

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
      Given /^(?:|I )am on (.+)$/ do |page_name|
        visit path_to(page_name)
      end

      def path_to(page_name)
        case page_name
        when /^the home\s?page$/
          '/'
        # Add more mappings here.
        # Here is an example that pulls values out of the Regexp:
        #
        #   when /^(.*)'s profile page$/i
        #     user_profile_path(User.find_by_login($1))
        else
          begin
            page_name =~ /^the (.*) page$/
            path_components = $1.split(/\s+/)
            self.send(path_components.push('path').join('_').to_sym)
          rescue NoMethodError, ArgumentError
            raise "Can't find mapping from \"\#{page_name}\" to a path.\\n" +
              "Now, go and add a mapping in \#{__FILE__}"
          end
        end
      end

      When /^(?:|I )fill in "([^"]*)" for "([^"]*)"$/ do |value, field|
        fill_in(field, with: value)
      end
      # Use this to fill in an entire form with data from a table. Example:
      #
      #   When I fill in the following:
      #     | Account Number | 5002       |
      #     | Expiry date    | 2009-11-01 |
      #     | Note           | Nice guy   |
      #     | Wants Email?   |            |
      #
      # TODO: Add support for checkbox, select or option
      # based on naming conventions.
      #

      When /^(?:|I )press "([^"]*)"$/ do |button|
        click_button(button)
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
      6 steps (6 passed)
      """

  Scenario: Mixed DB access
    When I write to "features/create_appointment.feature" with:
      """
      @javascript
      Feature: Create appointments
        Scenario: Visit the Constitution on May 17
          Given a random appointment
          And I am viewing a random appointment
          Then I should see "Random appointment"
      """
    And I write to "features/step_definitions/custom_steps.rb" with:
      """
      Given('a random appointment') do
        @appointment = Appointment.create!(name: 'Random appointment', when: DateTime.now)
      end

      Given('I am viewing a random appointment') do
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
