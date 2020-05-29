Feature: Choose javascript database strategy

  Whilst running a scenario with the @javascript tag, Capybara will fire up a web server
  in the same process in a separate thread to your cukes. By default, this means ActiveRecord will give it a
  separate database connection, which in turn means data you put into your database from
  Cucumber step definitions (e.g. using FactoryBot) won't be visible to the web server
  until the database transaction is committed.

  So if you use a transaction strategy for cleaning up your database at the end of a scenario,
  it won't work for javascript scenarios by default.

  There are two ways around this. One is to switch to a truncation strategy for javascript
  scenarios. This is slower, but more reliable.

  The alternative is to patch ActiveRecord to share a single database connection between
  threads. This means you still get the speed benefits of using a transaction to roll back
  your database, but you run the risk of the two threads stomping on one another as they
  talk to the database.

  Right now, the default behavior is to use truncation, but you can override this by telling
  cucumber-rails which strategy to use for javascript scenarios.

  The deletion strategy can be quicker for situations where truncation causes locks which
  has been reported by some Oracle users.

  Background:
    Given I have created a new Rails app and installed cucumber-rails
    And I have a "Widget" ActiveRecord model object
    When I write to "features/step_definitions/widget_steps.rb" with:
      """
      When('I create {int} widgets') do |number|
        number.times { Widget.create! }
      end

      Then('I should have {int} widgets') do |number|
        expect(Widget.count).to eq(number)
      end

      Then('the DatabaseCleaner strategy should be {word}') do |strategy_name|
        expect(DatabaseCleaner.cleaners.values.first.strategy.to_s).to match(/#{strategy_name}/i)
      end
      """

  Scenario: Set the strategy to truncation and run a javascript scenario.
    When I append to "features/env.rb" with:
      """
      DatabaseCleaner.strategy = :transaction
      Cucumber::Rails::Database.javascript_strategy = :truncation
      """
    And I write to "features/widgets.feature" with:
      """
      Feature:
        Background:
          When I create 2 widgets

        @javascript
        Scenario:
          When I create 3 widgets
          Then the DatabaseCleaner strategy should be truncation
          And I should have 5 widgets

        @javascript
        Scenario:
          Then the DatabaseCleaner strategy should be truncation
          And I should have 2 widgets

        Scenario:
          Then the DatabaseCleaner strategy should be transaction
          And I should have 2 widgets
      """
    And I run the cukes
    Then the feature run should pass with:
      """
      3 scenarios (3 passed)
      10 steps (10 passed)
      """

  Scenario: Set the strategy to deletion and run a javascript scenario.
    When I append to "features/env.rb" with:
      """
      Cucumber::Rails::Database.javascript_strategy = :deletion
      """
    And I write to "features/widgets.feature" with:
      """
      @javascript
      Feature:
        Background:
          When I create 2 widgets

        Scenario:
          When I create 3 widgets
          Then I should have 5 widgets

        Scenario:
          Then I should have 2 widgets
      """
    And I run the cukes
    Then the feature run should pass with:
      """
      2 scenarios (2 passed)
      5 steps (5 passed)
      """

  Scenario: Set the strategy to truncation with an except option and run a javascript scenario.
    When I append to "features/env.rb" with:
      """
      Cucumber::Rails::Database.javascript_strategy = :truncation, { except: %w[widgets] }
      """
    And I write to "features/widgets.feature" with:
      """
      @javascript
      Feature:
        Scenario:
          When I create 3 widgets
          Then I should have 3 widgets

        Scenario:
          Then I should have 3 widgets
      """
    And I run the cukes
    Then the feature run should pass with:
      """
      2 scenarios (2 passed)
      3 steps (3 passed)
      """
