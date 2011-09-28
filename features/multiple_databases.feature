Feature: Multiple Databases
  In order to use Database Cleaner with multiple database repositories
  As an engineer
  I want to specify explicit strategies for each

  Background: A Rails 3 app utilizing multiple database repositories exists
    Given I have created a new Rails 3 app "rails-3-app" with cucumber-rails support
    And I append to "config/database.yml" with:
      """

      ursidae:
        adapter: sqlite3
        database: db/ursidae.sqlite3
      """
    And I write to "app/models/bear.rb" with:
      """
      class Bear < ActiveRecord::Base
        establish_connection "ursidae"
      end
      """
    And a directory named "db/migrate"
    And I write to "db/migrate/001_create_bears.rb" with:
      """
      class CreateBears < ActiveRecord::Migration
        def self.up
          if Rails.env == 'ursidae'
            create_table :bears do |t|
              t.string :name, :null => false
            end
            add_index :bears, :name,  :unique => true
          end
        end
      end
      """
    And I successfully run `bundle exec rake db:migrate`
    And I successfully run `bundle exec rake db:migrate RAILS_ENV=ursidae`
    And I write to "features/support/env.rb" with:
      """
      require 'cucumber/rails'
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner[:active_record, {:connection => "ursidae"}].strategy = :truncation
      """
    And I write to "features/create_bear.feature" with:
      """
      Feature: Screws up in transactional test and must use truncation
        Scenario: I create a bear
          When I create a bear
          And something transactional happens
      """
    And I write to "features/step_definitions/create_bear_steps.rb" with:
      """
      When /^I create a bear$/ do
        Bear.create!(:name => "yogi")
      end
      When /^something transactional happens$/ do
        Bear.transaction { Bear.find_by_name("yogi").lock! }
      end
      """

  Scenario: Default transactional strategy is not attempted on second database
    When I run `bundle exec rake cucumber FEATURE=features/create_bear.feature`
    Then it should pass with:
      """
      1 scenario (1 passed)
      2 steps (2 passed)
      """
    And the output should not contain "cannot rollback - no transaction is active"

  Scenario: Truncation strategy is used on the second database
    Given I successfully run `bundle exec rails runner 'Bear.create(:name => "boo boo")'`
    And I successfully run `bundle exec rake cucumber FEATURE=features/create_bear.feature`
    When I run `bundle exec rails runner 'raise "ahh! bears!" if Bear.count > 0'`
    Then the exit status should be 0
