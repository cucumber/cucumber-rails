module RailsHelper
  def rails_new(options = '')
    app_name = 'test_app'
    run_simple "rails new #{app_name} --skip-bundle --skip-test-unit #{options}"
    assert_passing_with('README')
    cd app_name
  end

  def install_cucumber_rails
    run_simple 'bundle exec rails generate cucumber:install'
  end

  def append_to_gemfile(content)
    append_to_file('Gemfile', content)
  end
end
World(RailsHelper)

Given /^I have created a new Rails 3 app and installed cucumber\-rails, accidentally outside of the test group in my Gemfile$/ do
  rails_new
  append_to_gemfile %{
gem "cucumber-rails", :path => "#{File.expand_path('.')}"
gem "capybara", :group => :test
gem "rspec-rails", :group => :test
gem "database_cleaner", :group => :test
gem 'factory_girl', :group => :test
  }
  install_cucumber_rails
  create_web_steps
  if(ENV['ARUBA_REPORT_DIR'])
    @aruba_report_start = Time.new
    sleep(1)
  end
end

Given /^I have created a new Rails 3 app with cucumber\-rails support$/ do
  rails_new
  append_to_gemfile %{
gem "cucumber-rails", :group => :test, :path => "#{File.expand_path('.')}"
gem "capybara", :group => :test
gem "rspec-rails", :group => :test
gem "database_cleaner", :group => :test
gem 'factory_girl', :group => :test
  }
  install_cucumber_rails
  create_web_steps

  if(ENV['ARUBA_REPORT_DIR'])
    @aruba_report_start = Time.new
    sleep(1)
  end
end

Given /^I have created a new Rails 3 app with cucumber\-rails support but no database$/ do
  rails_new '--skip-active-record'
  append_to_gemfile %{
gem "cucumber-rails", :group => :test, :path => "#{File.expand_path('.')}"
gem "capybara", :group => :test
gem "rspec-rails", :group => :test
  }
  install_cucumber_rails
  overwrite_file('features/support/env.rb', "require 'cucumber/rails'\n")
  create_web_steps
end

Given /^a cukes resource$/ do
  steps %Q{
    Given I write to "config/routes.rb" with:
      """
      CukeApp::Application.routes.draw do
        resources :cukes
      end

      """
    And I write to "app/controllers/cukes_controller.rb" with:
      """
      class CukesController < ApplicationController
        def index
        end
      end

      """
  }
end

Before('@bundler-pre') do
  run_simple 'gem uninstall bundler'
  run_simple 'gem install bundler --pre'
end

After('@bundler-pre') do
  run_simple 'gem uninstall bundler'
  run_simple 'gem install bundler'
end
