Feature: Emulate Javascript

  Scenario: See a widget
    Given I have created a new Rails app and installed cucumber-rails
    And I successfully run `rails generate scaffold widget name:string`
    And I write to "features/f.feature" with:
      """
      @javascript
      Feature: Widget inventory
        Scenario: Delete a widget
          Given there is a widget named "wrench"
          When I go to the widgets page
          Then I should see "wrench"
      """
    And I write to "features/step_definitions/s.rb" with:
      """
      Given /^there is a widget named "([^"]*)"$/ do |name|
        FactoryGirl.create(:widget, :name => name)
      end
      """
    And I write to "features/support/factories.rb" with:
      """
      FactoryGirl.define do
        factory :widget do
          name 'testwidget'
        end
      end
      """
    When I run `bundle exec rake db:migrate`
    And I run `bundle exec rake cucumber`
    Then it should pass with:
       """
       1 scenario (1 passed)
       3 steps (3 passed)
       """

  Scenario: Pass on the CSRF token
    Given I have created a new Rails app and installed cucumber-rails
    And I successfully run `rails generate scaffold widget name:string`
    And I successfully run `sed -i -e 's/forgery_protection *= false/forgery_protection = true/' config/environments/test.rb`
    And I successfully run `rails generate controller session establish`
    And I write to "app/controllers/session_controller.rb" with:
      """
      class SessionController < ApplicationController
        def establish
          session[:verified] = true
        end
      end
      """
    And I write to "app/controllers/application_controller.rb" with:
      """
      class ApplicationController < ActionController::Base
        protect_from_forgery
        before_filter :except => :establish do
          render :text => "denied", :status => :forbidden and return false unless session[:verified]
        end
      end
      """
    And I write to "features/f.feature" with:
      """
      Feature: Widget inventory
        Scenario: Delete a widget
          Given there is a widget named "wrench"
          When I go to the session establish page
          And I go to the widgets page
          Then I should see "wrench"
          When I follow "Destroy"
          Then I should not see "denied"
          And I should be on the widgets page
          And I should not see "wrench"
      """
    And I write to "features/step_definitions/s.rb" with:
      """
      Given /^there is a widget named "([^"]*)"$/ do |name|
        FactoryGirl.create(:widget, :name => name)
      end
      """
    And I write to "features/support/factories.rb" with:
      """
      FactoryGirl.define do
        factory :widget do
          name 'testwidget'
        end
      end
      """
    When I run `bundle exec rake db:migrate`
    And I run `bundle exec rake cucumber`
    Then it should pass with:
       """
       1 scenario (1 passed)
       8 steps (8 passed)
       """
