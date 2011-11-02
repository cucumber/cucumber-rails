module RailsHelper
  def rails_new(app_name)
    run_simple "rails new #{app_name} --skip-bundle --skip-test-unit"
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

Given /^I have created a new Rails 3 app "([^"]*)" with cucumber\-rails support and cucumber-rails is outside of test group$/ do |app_name|
  rails_new app_name
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

Given /^I have created a new Rails 3 app "([^"]*)" with cucumber\-rails support$/ do |app_name|
  rails_new app_name
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

Given /^a project without ActiveRecord$/ do
  steps %Q{
    Given I successfully run `rails new cuke-app`
    And I cd to "cuke-app"
    And I append to "Gemfile" with:
      """
      gem "cucumber-rails", :group => :test, :path => "#{File.expand_path('.')}"
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
  create_web_steps
  if(ENV['ARUBA_REPORT_DIR'])
    @aruba_report_start = Time.new
    sleep(1)
  end
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
  steps %Q{
    Given I successfully run `gem uninstall bundler`
    And I successfully run `gem install bundler --pre`
  }
end

After('@bundler-pre') do
  steps %Q{
    Given I successfully run `gem uninstall bundler`
    And I successfully run `gem install bundler`
  }
end
