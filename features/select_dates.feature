Feature: Select dates

  Background: A simple calendar app
    Given I have created a new Rails 3 app "rails-3-app" with cucumber-rails support
  
  Scenario: Select date and time
    Given I successfully run `bundle exec rails g scaffold appointment name:string when:datetime`
    And I write to "features/create_appointment.feature" with:
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
    When I run `bundle exec rake db:migrate cucumber`
    Then it should pass with:
      """
      1 scenario (1 passed)
      6 steps (6 passed)
      """
  
  Scenario: Select date with label pointing to first select
    Given I successfully run `bundle exec rails g scaffold appointment name:string when:date`
    And I write to "features/create_appointment.feature" with:
      """
      Feature: Create appointments
        Scenario: Constitution on May 17
          Given I am on the new appointment page
          And I fill in "Norway's constitution" for "Name"
          And I select "2009-02-20" as the "When" date
          And I press "Create Appointment"
          Then I should see "Norway's constitution"
          And I should see "2009-02-20"
      """
    And I write to "app/views/appointments/_form.html.erb" with:
      """
      <%= form_for(@appointment) do |f| %>
        <div class="field">
          <%= f.label :name %><br />
          <%= f.text_field :name %>
        </div>
        <div class="field">
          <%= f.label :when, :for => "appointment_when_1i" %><br />
          <%= f.date_select :when %>
        </div>
        <div class="actions">
          <%= f.submit %>
        </div>
      <% end %>
      """
    When I run `bundle exec rake db:migrate cucumber`
    Then it should pass with:
      """
      1 scenario (1 passed)
      6 steps (6 passed)
      """