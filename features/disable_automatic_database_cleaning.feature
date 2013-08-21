Feature: Disable automatic database cleaning

  By default, a set of Before/After hooks are installed to
  invoke database_cleaner on every scenario except those tagged
  "@no-database-cleaner". Sometimes when a user is switching between
  cleaning strategies, this can initiate an undesired database
  transaction.

  To avoid the need for users making frequent strategy switches to apply
  this tag, a configuration option is provided so that the user can
  control the invocation of database_cleaner explicitly.

  Scenario: Disabling automatic cleaning
    Given I have created a new Rails app and installed cucumber-rails
    And I append to "features/env.rb" with:
      """
      Cucumber::Rails::Database.autorun_database_cleaner = false
      """
    And I write to "features/widgets.feature" with:
      """
      Feature: Create widgets
        Scenario: Create 3 widgets
          When I create 3 widgets
          Then I should have 3 widgets

        Scenario: Create 5 widgets
          When I create 5 widgets
          Then I should have 8 widgets
      """
    And I successfully run `rails generate model widget name:string`
    And I write to "features/step_definitions/widget_steps.rb" with:
      """
      Given /^I have (\d+) widgets$/ do |n|
        n.to_i.times do |i|
          Widget.create! :name => "Widget #{Widget.count + i}"
        end
      end

      When /^I create (\d+) widgets$/ do |n|
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
       4 steps (4 passed)
       """