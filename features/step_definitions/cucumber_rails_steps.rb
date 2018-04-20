module CucumberRailsHelper
  def rails_new(options = {})
    options[:name] ||= 'test_app'
    command = run "bundle exec rails new #{options[:name]} --skip-bundle --skip-test-unit --skip-spring #{options[:args]}"
    expect(command).to have_output /README/
    expect(last_command_started).to be_successfully_executed
    cd options[:name]
    delete_environment_variable 'RUBYOPT'
    delete_environment_variable 'BUNDLE_BIN_PATH'
    delete_environment_variable 'BUNDLE_GEMFILE'

    run_simple 'bundle install'
  end

  def install_cucumber_rails(*options)
    if options.include?(:not_in_test_group)
      gem 'cucumber-rails', path: "#{File.expand_path('.')}"
    else
      gem 'cucumber-rails' , group: :test, require: false, path: "#{File.expand_path('.')}"
    end
    # From Rails 5.1 some gems are already part of the Gemfile
    if Gem.loaded_specs['rails'].version < Gem::Version.new('5.1.0')
      gem 'capybara', group: :test
      gem 'selenium-webdriver', group: :test
    end

    gem 'geckodriver-helper', group: :test
    gem 'rspec-rails', group: :test
    gem 'database_cleaner', group: :test unless options.include?(:no_database_cleaner)
    gem 'factory_bot', group: :test unless options.include?(:no_factory_bot)
    # Newer versions of rake remove a method used by RSpec older versions
    # See https://stackoverflow.com/questions/35893584/nomethoderror-undefined-method-last-comment-after-upgrading-to-rake-11#35893625
    if Gem::Version.new(RSpec::Support::Version::STRING) < Gem::Version.new('3.4.4')
      gem 'rake', '< 11.0'
      run_simple 'bundle update rake --local'
    end
    run_simple 'bundle exec rails generate cucumber:install'
  end

  def gem(name, options)
    line = %{gem "#{name}", #{options.inspect}\n}
    append_to_file('Gemfile', line)
  end

  def prepare_aruba_report
    if(ENV['ARUBA_REPORT_DIR'])
      @aruba_report_start = Time.new
      sleep(1)
    end
  end

  def fixture(path)
    File.expand_path(File.dirname(__FILE__) + "./../support/fixtures/#{path}")
  end
end
World(CucumberRailsHelper)

Given /^I have created a new Rails app and installed cucumber\-rails, accidentally outside of the test group in my Gemfile$/ do
  rails_new
  install_cucumber_rails :not_in_test_group
  create_web_steps
  prepare_aruba_report
end

Given /^I have created a new Rails app "([^"]*)" and installed cucumber\-rails$/ do |app_name|
  rails_new name: app_name
  install_cucumber_rails
  create_web_steps
  prepare_aruba_report
end

Given /^I have created a new Rails app and installed cucumber\-rails$/ do
  rails_new
  install_cucumber_rails
  create_web_steps
  prepare_aruba_report
end

Given /^I have created a new Rails app with no database and installed cucumber-rails$/ do
  rails_new args: '--skip-active-record'
  install_cucumber_rails :no_database_cleaner, :no_factory_bot
  overwrite_file('features/support/env.rb', "require 'cucumber/rails'\n")
  create_web_steps
end

Given /^I have created a new Rails app "(.*?)" with no database and installed cucumber\-rails$/ do |app_name|
  rails_new name: app_name, args: '--skip-active-record'
  install_cucumber_rails :no_database_cleaner, :no_factory_bot
  overwrite_file('features/support/env.rb', "require 'cucumber/rails'\n")
  create_web_steps
end

Given /^I have a "([^"]*)" ActiveRecord model object$/ do |name|
  run_simple("bundle exec rails g model #{name}")
  run_simple('bundle exec rake db:migrate RAILS_ENV=test')
end

Given /^I force selenium to run Firefox in headless mode$/ do
  selenium_config = %{
    Capybara.register_driver :selenium do |app|
      browser_options = ::Selenium::WebDriver::Firefox::Options.new()
      browser_options.args << '--headless'
      Capybara::Selenium::Driver.new(app, browser: :firefox, options: browser_options)
    end
  }

  step 'I append to "features/support/env.rb" with:', selenium_config
end

When /^I run the cukes$/ do
  run_simple('bundle exec cucumber')
end

# Copied from Aruba
Then /^the feature run should pass with:$/ do |string|
  step 'the output should not contain " failed)"'
  step 'the output should not contain " undefined)"'
  step 'the exit status should be 0'
  step 'the output should contain:', string
end

Given("I remove the {string} gem from the Gemfile") do |gem_name|
  run 'pwd'
  app_path = last_command_started.output.strip
  gemfile_path = File.join(app_path, 'Gemfile')

  content = File.open(gemfile_path, 'r').readlines
  new_content = []

  content.each do |line|
    next if line =~ /gem ["|']#{gem_name}["|'].*/
    
    new_content << line
  end

  overwrite_file(gemfile_path, new_content.join("\r\n"))
end