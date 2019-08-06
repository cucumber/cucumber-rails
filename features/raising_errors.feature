Feature: Raise Errors

  Scenario: Raise error for undefined route
    Given I have created a new Rails app with no database and installed cucumber-rails
    When I write to "features/tests.feature" with:
      """
      Feature: Tests
        Scenario: Tests
          When I go to the products page
      """
    And I write to "features/test_steps.rb" with:
      """
      When /^I go to (.+)$/ do |page_name|
        visit path_to(page_name)
      end

      def path_to(page_name)
        case page_name
        # Add more mappings here.
        # Here is an example that pulls values out of the Regexp:
        #
        #   when /^(.*)'s profile page$/i
        #     user_profile_path(User.find_by_login($1))
        begin
          page_name =~ /^the (.*) page$/
          path_components = $1.split(/\s+/)
          self.send(path_components.push('path').join('_').to_sym)
        rescue NoMethodError, ArgumentError
          raise "Can't find mapping from \"\#{page_name}\" to a path.\\n" +
            "Now, go and add a mapping in \#{__FILE__}"
        end
      end
      """
    And I run `bundle exec cucumber`
    Then it should fail with:
      """
      1 scenario (1 failed)
      1 step (1 failed)
      """
