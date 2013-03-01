# Cucumber-Rails

[![Build Status](https://secure.travis-ci.org/cucumber/cucumber-rails.png)](http://travis-ci.org/cucumber/cucumber-rails)

Cucumber-Rails brings Cucumber to Rails 3.x. For Rails 2x support, see the [Cucumber Wiki](https://github.com/cucumber/cucumber/wiki/Ruby-on-Rails). 

## Installation

Before you can use the generator, add the gem to your project's Gemfile as follows:

    group :test do
      gem 'cucumber-rails', :require => false
      # database_cleaner is not required, but highly recommended
      gem 'database_cleaner'
    end

Then install it by running:

    bundle install

Learn about the various options:

    rails generate cucumber:install --help

Finally, bootstrap your Rails app, for example:

    rails generate cucumber:install

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

I strongly recommend rvm and ruby 1.9.3. When you have that, cd into your cucumber-rails repository and:

    gem install bundler
    bundle install

### Running all tests

With all dependencies installed, all specs and features should pass:

    rake

One of the features uses MongoDB, which needs to be running in order to make features/mongoid.feature to pass.

### Running Appraisal suite

In order to test against multiple versions of key dependencies, the [Appraisal](https://github.com/thoughtbot/appraisal) is used to generate multiple gemfiles, stored in the `gemfiles/` directory. Normally these will only run on Travis; however, if you want to run the full test suite against all gemfiles, run the following commands:

    rake gemfiles:install
    rake test:all

To run the suite against a named gemfile, use the following:

    rake test:gemfile[rails_3_0]

To remove and rebuild the different gemfiles (for example, to update a rails version or its dependencies), use the following:

    rake gemfiles:rebuild
