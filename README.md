# Cucumber-Rails

[![Gem Version](https://badge.fury.io/rb/cucumber-rails.svg)](http://badge.fury.io/rb/cucumber-rails)
[![build](https://github.com/cucumber/cucumber-rails/actions/workflows/test.yml/badge.svg)](https://github.com/cucumber/cucumber-rails/actions/workflows/test.yml)
[![Open Source Helpers](https://www.codetriage.com/cucumber/cucumber-rails/badges/users.svg)](https://www.codetriage.com/cucumber/cucumber-rails)

Cucumber-Rails brings Cucumber to Rails 6.1, 7.x, and 8.x.

## Installation

Before you can use the generator, add the gem to your project's Gemfile as follows:

```ruby
group :test do
  gem 'cucumber-rails', require: false
  # database_cleaner is not required, but highly recommended
  gem 'database_cleaner'
end
```

Then install it by running:

    bundle install

Learn about the various options:

    rails generate cucumber:install --help

Finally, bootstrap your Rails app, for example:

    rails generate cucumber:install

## Running Cucumber

    [bundle exec] cucumber

## Configuration options

By default, cucumber-rails runs `DatabaseCleaner.start` and `DatabaseCleaner.clean`
before and after your scenarios. You can disable this behaviour like so:

```ruby
# features/support/env.rb
# ...
Cucumber::Rails::Database.autorun_database_cleaner = false
```

By default, cucumber-rails will auto mix-in the helpers from  `Rack::Test` into your default Cucumber World instance.
You can prevent this behaviour like so:
```ruby
# features/support/env.rb
ENV['CR_REMOVE_RACK_TEST_HELPERS'] = 'true'
```

## Upgrading from a previous version

When upgrading from a previous version it is recommended that you rerun:

    rails generate cucumber:install

## Bugs and feature requests

The *only* way to have a bug fixed or a new feature accepted is to describe it with a
Cucumber feature. Let's say you think you have found a bug in the cucumber:install generator.
Fork this project, clone it to your workstation and check out a branch with a descriptive name:

    git clone git@github.com:you/cucumber-rails.git
    git checkout -b bugfix/generator-fails-on-bundle-exec

Start by making sure you can run the existing features. Now, create a feature that demonstrates
what's wrong. See the existing features for examples. When you have a failing feature that
reproduces the bug, commit, push and send a pull request. Someone from the Cucumber-Rails team
will review it and hopefully create a fix.

If you know how to fix the bug yourself, make a second commit (after committing the failing
feature) before you send the pull request.

### Setting up your environment

Make sure you have a supported ruby installed, cd into your `cucumber-rails` repository and run

    gem install bundler
    bundle install
    bin/install_geckodriver.sh
    bin/install_webpacker.sh

### Running all tests

With all dependencies installed, all specs and features should pass:

    [bundle exec] rake

### Running Appraisal suite

In order to test against multiple versions of key dependencies, the [Appraisal](https://github.com/thoughtbot/appraisal)
gem is used to generate multiple gemfiles, stored in the `gemfiles/` directory.
Normally these will only run on GitHub via GitHub Actions; however if you want to run the full test
suite against all gemfiles, run the following commands:

    [bundle exec] appraisal install
    [bundle exec] appraisal rake test

To run the suite against a named gemfile, use the following:

    [bundle exec] appraisal rails_8_0 rake test

### Adding dependencies

To support the multiple-gemfile testing, when adding a new dependency the following rules apply:

1. If it's a runtime dependency of the gem, add it to the gemspec
2. If it's a primary development dependency, add it to the gemspec
3. If it's a dependency of a generated rails app in a test, add it to [the helper method] that modifies the `Gemfile`

For example, rspec is a primary development dependency, so it lives in the gemspec.

[the helper method]: ./features/support/cucumber_rails_gem_helper.rb
