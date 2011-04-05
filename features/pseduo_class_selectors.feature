Feature: Pseudo-class Selectors

  Scenario: Look within css pseudo-class selectors
    Given a project without ActiveRecord
    And a cukes resource
    And I write to "app/views/cukes/index.html.erb" with:
      """
      <div>foo</div>
      <div>bar</div>
      """
    And I write to "features/tests.feature" with:
      """
      Feature: Tests
        Scenario: Tests
          When I go to the cukes page
          Then I should see "bar" within "div:nth-child(2)"
          And I should not see "foo" within "div:nth-child(2)"
      """
    And I run `rake cucumber`
    Then it should pass with:
      """
      1 scenario (1 passed)
      3 steps (3 passed)
      """
