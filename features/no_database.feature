Feature: No Database
  Allow Cucumber to work with a Rails app without a database

  Scenario: No ActiveRecord and DatabaseCleaner
    Given I have created a new Rails 3 app "rails-3-app" with cucumber-rails support
    # Turn off ActiveRecord
    And I write to "config/application.rb" with:
      """
      require File.expand_path('../boot', __FILE__)

      require 'action_controller/railtie'
      require 'action_mailer/railtie'
      require 'active_resource/railtie'
      require 'rails/test_unit/railtie'

      Bundler.require(:default, Rails.env) if defined?(Bundler)

      module Rails3App
        class Application < Rails::Application
          config.encoding = "utf-8"
          config.filter_parameters += [:password]
        end
      end
      """
    And I remove the file "config/database.yml"
    And I overwrite "features/support/env.rb" with:
      """
      require 'cucumber/rails'
      """
    # Remove DatabaseCleaner and SQLite
    And I write to "Gemfile" with:
      """
      source 'http://rubygems.org'
      gem 'rails'
      gem "cucumber-rails", :group => :test, :path => "../../.."
      gem "capybara", :group => :test
      gem "rspec-rails", :group => :test
      """
    And I write to "app/controllers/posts_controller.rb" with:
      """
      class PostsController < ApplicationController
        def index
          raise "There is an error in index"
        end
      end
      """
    And I write to "config/routes.rb" with:
      """
      Rails3App::Application.routes.draw do
        resources :posts
      end
      """
    And I write to "features/posts.feature" with:
      """
      Feature: posts
        Scenario: See them
          When I do it
      """
    And I write to "features/step_definitions/posts_steps.rb" with:
      """
      When /^I do it$/ do
        visit '/posts'
      end
      """
    And I run `bundle exec rake cucumber`
    Then it should fail with:
      """
      There is an error in index
      """
