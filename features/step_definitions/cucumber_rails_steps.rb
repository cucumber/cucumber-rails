Given /^I have created a new Rails 3 app "([^"]*)" with cucumber\-rails support$/ do |app_name|
  steps %Q{
    When I successfully run "rails new rails-3-app"
    Then it should pass with:
      """
      README
      """
    And I cd to "#{app_name}"
    And I successfully run "rails generate cucumber:install"
    And I successfully run "bundle install"
    And I successfully run "rake db:migrate"
  }
end
