Feature: Detecting a field has errors on it

  Scenario: A form with some fields with errors
    Given I have created a new Rails 3 app "enemies" with cucumber-rails support
    And I successfully run `rails generate scaffold enemy name:string nickname:string`
    And I write to "app/models/enemy.rb" with:
      """
      class Enemy < ActiveRecord::Base
        validates_presence_of :name
      end
      """
    And I write to "features/f.feature" with:
      """
      Feature: Enemy form
        Scenario: Making an enemy
          Given I am on the new enemy page
          And I press "Create Enemy"
          Then the "Name" field should have the error "can't be blank"
          And the "Nickname" field should have no error
      """
    When I run `bundle exec rake db:migrate`
    And I run `bundle exec rake cucumber`
    Then it should pass with:
       """
       1 scenario (1 passed)
       4 steps (4 passed)
       """

  Scenario: A formtastic form with some fields with errors
    Given I have created a new Rails 3 app "enemies" with cucumber-rails support
    And I append to "Gemfile" with:
      """
      gem "formtastic"
      """
    And I successfully run `bundle`
    And I successfully run `rails generate scaffold enemy name:string nickname:string`
    And I write to "app/models/enemy.rb" with:
      """
      class Enemy < ActiveRecord::Base
        validates_presence_of :name
      end
      """
    And I write to "features/f.feature" with:
      """
      Feature: Enemy form
        Scenario: Making an enemy
          Given I am on the new enemy page
          And I press "Create Enemy"
          Then the "Name" field should have the error "can't be blank"
          And the "Nickname" field should have no error
      """
    And I write to "app/views/enemies/new.html.erb" with:
    """
    <%= semantic_form_for(@enemy) do |form| %>
      <%= form.inputs do %>
        <%= form.input :name %>
        <%= form.input :nickname %>
      <% end %>
      <%= form.buttons do %>
        <%= form.commit_button %>
      <% end %>
    <% end %>
    """
    When I run `bundle exec rake db:migrate`
    And I run `bundle exec rake cucumber`
    Then it should pass with:
       """
       1 scenario (1 passed)
       4 steps (4 passed)
       """
