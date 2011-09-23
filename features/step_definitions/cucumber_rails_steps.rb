Given /^I have created a new Rails 3 app "([^"]*)" with cucumber\-rails support and cucumber-rails is outside of test group$/ do |app_name|
  steps %Q{
    When I successfully run `rails new #{app_name}`
    Then it should pass with:
      """
      README
      """
    And I cd to "#{app_name}"
    And I append to "Gemfile" with:
      """
      gem "cucumber-rails", :path => "../../.."
      gem "capybara", :group => :test
      gem "rspec-rails", :group => :test
      gem "database_cleaner", :group => :test
      gem 'factory_girl', :group => :test

      """
    And I successfully run `bundle exec rails generate cucumber:install`
  }
  if(ENV['ARUBA_REPORT_DIR'])
    @aruba_report_start = Time.new
    sleep(1)
  end
end

Given /^I am using bundler prerelease$/ do
  steps %Q{
    Given I successfully run `gem uninstall bundler`
    And I successfully run `gem install bundler --pre`
  }
end

Given /^I am using stable bundler$/ do
  steps %Q{
    Given I successfully run `gem uninstall bundler`
    And I successfully run `gem install bundler`
  }
end

Given /^I have created a new Rails 3 app "([^"]*)" with cucumber\-rails support$/ do |app_name|
  steps %Q{
    When I successfully run `rails new #{app_name}`
    Then it should pass with:
      """
      README
      """
    And I cd to "#{app_name}"
    And I append to "Gemfile" with:
      """
      gem "cucumber-rails", :group => :test, :path => "../../.."
      gem "capybara", :group => :test
      gem "rspec-rails", :group => :test
      gem "database_cleaner", :group => :test
      gem 'factory_girl', :group => :test

      """
    And I successfully run `bundle exec rails generate cucumber:install`
  }
  if(ENV['ARUBA_REPORT_DIR'])
    @aruba_report_start = Time.new
    sleep(1)
  end
end

Given /^a project without ActiveRecord$/ do
  steps %Q{
    Given I successfully run `rails new cuke-app`
    And I cd to "cuke-app"
    And I append to "Gemfile" with:
      """
      gem "cucumber-rails", :group => :test, :path => "../../.."
      gem "capybara", :group => :test
      gem "rspec-rails", :group => :test

      """
    And I successfully run `bundle exec rails generate cucumber:install`
    And I overwrite "features/support/env.rb" with:
      """
      require 'cucumber/rails'

      """

    And I write to "config/application.rb" with:
      """
      require File.expand_path('../boot', __FILE__)

      require 'action_controller/railtie'
      require 'action_mailer/railtie'
      require 'active_resource/railtie'
      require 'rails/test_unit/railtie'

      Bundler.require(:default, Rails.env) if defined?(Bundler)

      module CukeApp
        class Application < Rails::Application
          config.encoding = "utf-8"
          config.filter_parameters += [:password]
        end
      end

      """
    And I remove the file "config/database.yml"
  }
  if(ENV['ARUBA_REPORT_DIR'])
    @aruba_report_start = Time.new
    sleep(1)
  end
end

And /^a cukes resource$/ do
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