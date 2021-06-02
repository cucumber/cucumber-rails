Feature: REST API

  Scenario: Compare JSON
    Given I have created a new Rails app and installed cucumber-rails
    When I write to "app/controllers/posts_controller.rb" with:
      """
      class PostsController < ApplicationController
        def index
          render json: {'hello' => 'world'}.to_json
        end
      end
      """
    And I write to "config/routes.rb" with:
      """
      TestApp::Application.routes.draw do
        resources :posts
      end
      """
    And I write to "features/posts.feature" with:
      """
      Feature: posts
        Scenario: See them
          When the client requests GET /posts
          Then the response should be JSON:
            \"\"\"
            {
              "hello": "world"
            }
            \"\"\"
      """
    And I write to "features/step_definitions/post_steps.rb" with:
      """
      When('the client requests GET \/{word}') do |path|
        get(path)
      end

      Then('the response should be JSON:') do |json|
        expect(JSON.parse(last_response.body)).to eq(JSON.parse(json))
      end
      """
    And I run `bundle exec rake db:migrate`
    And I run `bundle exec rake cucumber`
    Then the feature run should pass with:
      """
      1 scenario (1 passed)
      2 steps (2 passed)
      """
