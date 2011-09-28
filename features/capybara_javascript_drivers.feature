Feature: Capybara Javascript Drivers

  Background: A simple calendar app
    Given I have created a new Rails 3 app "rails-3-app" with cucumber-rails support
    And I successfully run `bundle exec rails g scaffold appointment name:string when:datetime`
    And I write to "features/step_definitions/date_time_steps.rb" with:
      """
      When /^(?:|I )select "([^"]+)" as the "([^"]+)" time$/ do |time, selector|
        select_time(selector, :with => time)
      end
      
      When /^(?:|I )select "([^"]+)" as the "([^"]+)" date$/ do |date, selector|
        select_date(selector, :with => date)
      end
      
      When /^(?:|I )select "([^"]+)" as the "([^"]+)" date and time$/ do |datetime, selector|
        select_datetime(selector, :with => datetime)
      end
      """

  Scenario Outline: Use a particular driver
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
    And I append to "Gemfile" with:
      """
      <Gemfile extra>

      """
    And I append to "features/support/env.rb" with:
      """
      <env.rb extra>

      """

    When I run `bundle exec rake db:migrate`
    And I run `bundle exec rake cucumber`
    Then it should pass with:
      """
      1 scenario (1 passed)
      6 steps (6 passed)
      """

    Examples:
      | Gemfile extra                    | env.rb extra       |
      | ''  | '' |

  Scenario Outline: Mixed DB access
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
    And I append to "Gemfile" with:
      """
      <Gemfile extra>

      """
    And I append to "features/support/env.rb" with:
      """
      <env.rb extra>

      """

    When I run `bundle exec rake db:migrate`
    And I run `bundle exec rake cucumber`
    Then it should pass with:
      """
      1 scenario (1 passed)
      3 steps (3 passed)
      """

    Examples:
      | Gemfile extra                    | env.rb extra       |
      | ''  | '' |

