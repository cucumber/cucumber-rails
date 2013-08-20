module CucumberRailsHelper
  def rails_new(options={})
    options[:name] ||= 'test_app'
    run_simple "bundle exec rails new #{options[:name]} --skip-test-unit #{options[:args]}"
    assert_passing_with('README')
    cd options[:name]
  end

  def install_cucumber_rails(*options)
    if options.include?(:not_in_test_group)
      gem "cucumber-rails", :path => "#{File.expand_path('.')}"
    else
      gem "cucumber-rails", :group => :test, :require => false, :path => "#{File.expand_path('.')}"
    end
    gem "capybara", :group => :test
    gem "rspec-rails", :group => :test
    gem "database_cleaner", :group => :test unless options.include?(:no_database_cleaner)
    gem 'factory_girl', :group => :test unless options.include?(:no_factory_girl)
    gem "selenium-webdriver", :group => :test
    run_simple "bundle exec rails generate cucumber:install"
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
  rails_new :name => app_name
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
  rails_new :args => '--skip-active-record'
  install_cucumber_rails :no_database_cleaner, :no_factory_girl
  overwrite_file('features/support/env.rb', "require 'cucumber/rails'\n")
  create_web_steps
end

Given /^I have created a new Rails app "(.*?)" with no database and installed cucumber\-rails$/ do |app_name|
  rails_new :name => app_name, :args => '--skip-active-record'
  install_cucumber_rails :no_database_cleaner, :no_factory_girl
  overwrite_file('features/support/env.rb', "require 'cucumber/rails'\n")
  create_web_steps
end

Given /^I have a "([^"]*)" ActiveRecord model object$/ do |name|
  run_simple("bundle exec rails g model #{name}")
  run_simple("bundle exec rake db:migrate RAILS_ENV=test")
end

When /^I run the cukes$/ do
  run_simple('bundle exec cucumber')
end
