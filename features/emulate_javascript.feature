Feature: Emulate Javascript

  Background:
    Given I have created a new Rails app and installed cucumber-rails
    And I force selenium to run Firefox in headless mode
    When I run `rails generate scaffold widget name:string`
    And I write to "features/step_definitions/widget_steps.rb" with:
    """
      Given('there is a widget named {string}') do |name|
        FactoryBot.create(:widget, name: name)
      end

      When('I am on the widgets page') do
        visit widgets_path
      end

      Then('I should see {string}') do |text|
        expect(page).to have_content(text)
      end
      """
    And I write to "features/support/factories/widget.rb" with:
      """
      FactoryBot.define do
        factory :widget do
          name { 'testwidget' }
        end
      end
      """

  Scenario: See a widget
    When I write to "features/widgets.feature" with:
      """
      @javascript
      Feature: Widget inventory
        Scenario: Delete a widget
          Given there is a widget named "wrench"
          And I am on the widgets page
          Then I should see "wrench"
      """
    And I run `bundle exec rake db:migrate`
    And I run `bundle exec rake cucumber`
    Then the feature run should pass with:
      """
      1 scenario (1 passed)
      3 steps (3 passed)
      """

  Scenario: Pass on the CSRF token
    When I run `sed -i -e 's/forgery_protection *= false/forgery_protection = true/' config/environments/test.rb`
    And I run `rails generate controller session establish`
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

        before_action except: :establish do
          render text: 'denied', status: :forbidden and return false unless session[:verified]
        end
      end
      """
    And I write to "features/widgets.feature" with:
      """
      Feature: Widget inventory
        Scenario: Delete a widget
          Given there is a widget named "wrench"
          And I am on the session establish page
          And I am on the widgets page
          Then I should see "wrench"
          When I follow "Destroy"
          Then I should not see "denied"
          And I should be on the widgets page
          And I should not see "wrench"
      """
    And I append to "features/step_definitions/widget_steps.rb" with:
      # TODO: Remove the newline below (Required) once bug is fixed: https://github.com/cucumber/aruba/issues/662
      """

      Given('I am on the session establish page') do
        visit session_establish_path
      end

      When('I follow {string}') do |link|
        click_link(link)
      end

      Then('I should not see {string}') do |text|
        expect(page).not_to have_content(text)
      end

      Then('I should be on the widgets page') do
        current_path = URI.parse(current_url).path
        expect(current_path).to eq(widgets_path)
      end
      """
    And I run `bundle exec rake db:migrate`
    And I run `bundle exec rake cucumber`
    Then the feature run should pass with:
      """
      1 scenario (1 passed)
      8 steps (8 passed)
      """
