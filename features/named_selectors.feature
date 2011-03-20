Feature: Named Selectors

  Scenario: Look within named selector
    Given a project without ActiveRecord
    And a cukes resource
    And I write to "app/views/cukes/index.html.erb" with:
      """
      <div class="foo">foo</div>
      <div class="bar">bar</div>
      """
    And I write to "features/tests.feature" with:
      """
      Feature: Tests
        Scenario: Tests
          When I go to the cukes page
          Then I should see "foo" within the foo div
          And I should not see "bar" within the foo div
      """
    And I overwrite "features/support/selectors.rb" with:
      """
      module HtmlSelectorsHelpers
        def selector_for(locator)
          return '.foo' if locator == 'the foo div'
        end
      end
      World(HtmlSelectorsHelpers)
      """
    And I run `rake cucumber`
    Then it should pass with:
      """
      1 scenario (1 passed)
      3 steps (3 passed)
      """
