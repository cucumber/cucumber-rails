Feature: Emulate Javascript

  Scenario: Delete a widget
    Given I have created a new Rails 3 app "widgets" with cucumber-rails support
    And I successfully run `rails generate scaffold widget name:string`
    And I write to "features/f.feature" with:
      """
      Feature: Widget inventory
        Scenario: Delete a widget
          Given there is a widget named "wrench"
          When I go to the widgets page
          And I follow "Destroy"
          Then I should not see "wrench"
      """
    And I write to "features/step_definitions/s.rb" with:
      """
      Given /^there is a widget named "([^"]*)"$/ do |name|
        Factory(:widget, :name => name)
      end
      """
    And I write to "features/support/factories.rb" with:
      """
      Factory.define :widget do |f| 
        f.name 'testwidget'
      end
      """
    When I run `rake db:migrate cucumber`
    Then it should pass with:
       """
       1 scenario (1 passed)
       4 steps (4 passed)
       """

