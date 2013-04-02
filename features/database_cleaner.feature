Feature: DatabaseCleaner

  Scenario: Create records in background
    Given I have created a new Rails app and installed cucumber-rails
    And I write to "features/widgets.feature" with:
      """
      Feature: Create widgets
        Background: some widdgets
          Given I have 2 widgets
      
        Scenario: Add 3
          When I create 3 more widgets
          Then I should have 5 widgets

        Scenario: Add 7
          When I create 7 more widgets
          Then I should have 9 widgets
      """
    And I successfully run `rails generate model widget name:string`
    And I write to "features/step_definitions/widget_steps.rb" with:
      """
      Given /^I have (\d+) widgets$/ do |n|
        n.to_i.times do |i|
          Widget.create! :name => "Widget #{Widget.count + i}"
        end
      end

      When /^I create (\d+) more widgets$/ do |n|
        n.to_i.times do |i|
          Widget.create! :name => "Widget #{Widget.count + i}"
        end
      end

      Then /^I should have (\d+) widgets$/ do |n|
        Widget.count.should == n.to_i
      end
      """
    And I run `bundle exec rake db:migrate`
    And I run `bundle exec rake cucumber`
    Then it should pass with:
       """
       2 scenarios (2 passed)
       6 steps (6 passed)
       """
