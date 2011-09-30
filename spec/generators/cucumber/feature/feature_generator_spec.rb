require 'spec_helper'

# Generators are not automatically loaded by Rails
require 'generators/cucumber/feature/feature_generator'

describe Cucumber::FeatureGenerator do
  # Tell the generator where to put its output (what it thinks of as Rails.root)
  destination File.expand_path("../../../../../tmp", __FILE__)

  before { prepare_destination }

  describe 'no arguments' do
    before { run_generator %w(post) }

    describe 'manage_posts.feature' do
      subject { file('features/manage_posts.feature') }
      it { should exist }
      it { should contain /Feature: Manage posts/ }
      it { should contain /Scenario: Register new post/ }
    end

    describe 'post_steps.rb' do
      subject { file('features/step_definitions/post_steps.rb') }
      it { should exist }
      it { should contain "Given /^the following posts:$/ do |posts|" }
      it { should contain "When /^I delete the (\\d+)(?:st|nd|rd|th) post$/ do |pos|" }
      it { should contain "Then /^I should see the following posts:$/ do |expected_posts_table|" }
    end
  end

  describe 'with attribute arguments' do
    before { run_generator %w(post title:string body:text published:boolean) }

    describe 'manage_posts.feature' do
      subject { file('features/manage_posts.feature') }
      it { should exist }
      it { should contain "Feature: Manage posts" }
      it { should contain "Scenario: Register new post" }
      it { should contain "Scenario: Delete post" }
      it { should contain "|Title|Body|Published|" }
    end

    describe 'post_steps.rb' do
      subject { file('features/step_definitions/post_steps.rb') }
      it { should exist }
      it { should contain "Given /^the following posts:$/ do |posts|" }
      it { should contain "When /^I delete the (\\d+)(?:st|nd|rd|th) post$/ do |pos|" }
      it { should contain "Then /^I should see the following posts:$/ do |expected_posts_table|" }
    end
  end

end