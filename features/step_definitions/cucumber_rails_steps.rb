Given /^I symlink this repo to "([^\"]*)"$/ do |target|
  source = File.expand_path('../../..', __FILE__)
  in_current_dir do
    target = File.expand_path(target)
    FileUtils.ln_s(source, target)
  end
end

Given /^I have created a new Rails 2 app "([^\"]*)" with cucumber\-rails support$/ do |app_name|
  steps %Q{
    Given I am using rvm "1.8.7"
    And I am using rvm gemset "cucumber-rails-2.3.5" with Gemfile:
      """
      gem 'rails', '2.3.5'
      gem 'sqlite3-ruby', '1.2.5'
      gem 'capybara', '0.3.6'
      gem 'webrat'
      gem 'rspec-rails'
      gem 'cucumber'
      gem 'database_cleaner'
      gem 'culerity'
      gem 'celerity'
      """
    And I successfully run "rails #{app_name}"
    And I cd to "#{app_name}"
    And I symlink this repo to "vendor/plugins/cucumber-rails"
    And I successfully run "ruby script/generate cucumber --capybara"
    And I successfully run "rake db:migrate"
  }
end
