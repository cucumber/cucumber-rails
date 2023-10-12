Feature: Emulate Javascript

  Background:
    Given I have created a new Rails app and installed cucumber-rails
    And I force selenium to run Firefox in headless mode
    When I run `bundle exec rails generate scaffold widget name:string`
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
    And I run `bundle exec rails generate controller session establish`
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

        # Rails 7.1 introduces raise_on_missing_callback_conditionals and it's on by default
        def establish
          raise "This action must be implemented in child controllers"
        end
      end
      """
    And I write to "features/widgets.feature" with:
      """
      Feature: Widget inventory
        Scenario: Delete a widget
          Given there is a widget named "wrench"
          And I am on the session establish page
          And I navigate to destroy "wrench" page
          Then I should see "wrench"
          And I should see "Destroy"
          When I follow "Destroy"
          Then I should not see "denied"
          And I should be on the widgets page
          And I should not see "wrench"
      """
    And I append the following lines to "features/step_definitions/widget_steps.rb":
      """
      Given('I am on the session establish page') do
        visit session_establish_path
      end

      Given('I navigate to destroy {string} page') do |name|
        if ::Rails::VERSION::MAJOR >= 7
          visit widget_path(Widget.find_by(name: name))
        else
          visit widgets_path
        end
      end

      When('I follow {string}') do |link|
        if ::Rails::VERSION::MAJOR >= 7
          click_button(link)
        else
          click_link(link)
        end
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
      9 steps (9 passed)
      """
