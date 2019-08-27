Feature: Rerun profile

  In order to concentrate on failing features
  As a Rails developer working with Cucumber
  I want to rerun only failing features

  Scenario: Rerun
    Given I have created a new Rails app and installed cucumber-rails
    And a file named "rerun.txt" with:
      """
      features/rerun_test.feature:2
      features/rerun_test.feature:5
      """
    And a file named "features/rerun_test.feature" with:
      """
      Feature: Rerun test
        Scenario: failing before
          Given fixed now

        Scenario: still failing
          Given broken

        Scenario: always passing
          Given passing
      """
    And a file named "features/step_definitions/rerun_steps.rb" with:
      """
      Given('fixed now') do
        puts 'All fixed now'
      end

      Given('broken') do
        raise "I'm broken"
      end

      Given('passing') do
        puts "I've always been passing"
      end
      """
    When I run `bundle exec cucumber -p rerun`
    Then it should fail with:
      """
      2 scenarios (1 failed, 1 passed)
      2 steps (1 failed, 1 passed)
      """
    And the file "rerun.txt" should not contain "features/rerun_test.feature:2"
    And the file "rerun.txt" should contain "features/rerun_test.feature:5"
