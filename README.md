# Cucumber-Rails

[![Build Status](https://secure.travis-ci.org/cucumber/cucumber-rails.png)](http://travis-ci.org/cucumber/cucumber-rails)

Cucumber-Rails brings Cucumber to Rails 3.x. For Rails 2x support, see the [Cucumber Wiki](https://github.com/cucumber/cucumber/wiki/Ruby-on-Rails). 

Cucumber-Rails contains 2 generators - one
for bootstrapping your Rails app for Cucumber, and a second one for generating features.

Cucumber-Rails also contains Cucumber Step Definitions that wrap Capybara,
giving you a head start for writing Cucumber features against your Rails app.

## Installation

Before you can use the generator, add the gem to your project's Gemfile as follows:

    group :test do
      gem 'cucumber-rails'
      # database_cleaner is not required, but highly recommended
      gem 'database_cleaner'
    end

Then install it by running:

    bundle install

Learn about the various options:

    rails generate cucumber:install --help

Finally, bootstrap your Rails app, for example:

    rails generate cucumber:install

## Generating a Cucumber feature

IMPORTANT: Only do this if you are new to Cucumber. We recommend you write your
Cucumber features by hand once you get the hang of it.

Example:

    rails generate cucumber:feature post title:string body:text published:boolean
    rails generate scaffold post title:string body:text published:boolean
    rake db:migrate
    rake cucumber

## Running Cucumber

With Rake:

    rake cucumber

Without Rake:

    [bundle exec] cucumber

## Bugs and feature requests

The *only* way to have a bug fixed or a new feature accepted is to describe it with a Cucumber feature. Let's say you think you have found a bug in the cucumber:install generator. Fork this project, clone it to your workstation and check out a branch with a descriptive name:

    git clone git@github.com:you/cucumber-rails.git
    git checkout -b bug-install-generator

Start by making sure you can run the existing features. Now, create a feature that demonstrates what's wrong. See the existing features for examples. When you have a failing feature that reproduces the bug, commit, push and send a pull request. Someone from the Cucumber-Rails team will review it and hopefully create a fix.

If you know how to fix the bug yourself, make a second commit (after committing the failing feature) before you send the pull request.

### Setting up your environment

I strongly recommend rvm and ruby 1.9.2. When you have that, cd into your cucumber-rails repository and:

    gem install bundler
    bundle install

### Running all features

With all dependencies installed, all features should pass:

    rake cucumber

One of the features uses MongoDB, which needs to be running in order to make features/mongoid.feature to pass.
