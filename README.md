# Cucumber-Rails

[![Gem Version](https://badge.fury.io/rb/cucumber-rails.svg)](http://badge.fury.io/rb/cucumber-rails)
[![Build Status](https://secure.travis-ci.org/cucumber/cucumber-rails.svg?branch=master)](http://travis-ci.org/cucumber/cucumber-rails)
[![Code Climate](https://codeclimate.com/github/cucumber/cucumber-rails.svg)](https://codeclimate.com/github/cucumber/cucumber-rails)
[![Open Source Helpers](https://www.codetriage.com/cucumber/cucumber-rails/badges/users.svg)](https://www.codetriage.com/cucumber/cucumber-rails)

Cucumber-Rails brings Cucumber to Rails 4.2, 5.x and 6.x.

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

With Rake:

    rake cucumber

Without Rake:

    [bundle exec] cucumber

## Configuration options

By default, cucumber-rails runs `DatabaseCleaner.start` and `DatabaseCleaner.clean`
before and after your scenarios. You can disable this behaviour like so:

```ruby
# features/support/env.rb
# ...
Cucumber::Rails::Database.autorun_database_cleaner = false
```

By default, cucumber-rails will auto mix-in the helpers from  `Rack::Test` into your default Cucumber World instance. You can prevent this behaviour like so:
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
    git checkout -b bugfix/generator-fails-on-ruby-25

Start by making sure you can run the existing features. Now, create a feature that demonstrates
what's wrong. See the existing features for examples. When you have a failing feature that
reproduces the bug, commit, push and send a pull request. Someone from the Cucumber-Rails team
will review it and hopefully create a fix.

If you know how to fix the bug yourself, make a second commit (after committing the failing
feature) before you send the pull request.

### Setting up your environment

Make sure you have a supported ruby installed, cd into your cucumber-rails repository and:

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
Normally these will only run on Travis; however, if you want to run the full test suite against
all gemfiles, run the following commands:

    [bundle exec] appraisal install
    [bundle exec] appraisal rake test

To run the suite against a named gemfile, use the following:

    [bundle exec] appraisal rails_4_2 rake test

To remove and rebuild the different gemfiles (for example, to update a rails version or its
dependencies), use the following:

    [bundle exec] appraisal update

If you've changed versions of the dependencies, you may find it helpful to forcefully clean
each appraisal's gem lock file in `gemfiles/`. You can do this using:

    [bundle exec] rake clean

### Adding dependencies

To support the multiple-gemfile testing, when adding a new dependency the following rules apply:

1. If it's a runtime dependency of the gem, add it to the gemspec
2. If it's a primary development dependency, add it to the gemspec
3. If it's a dependency of a generated rails app in a test, add it to [the helper] that
modifies the `Gemfile`.

For example, rspec is a primary development dependency, so it lives in the gemspec.

[the helper]: https://github.com/cucumber/cucumber-rails/blob/5e37c530560ae1c1a79521c38a54bae0be94242b/features/step_definitions/cucumber_rails_steps.rb#L15

### NOTE

If you get an error while trying to run the tests locally, similar to the one below:

    Could not find a JavaScript runtime. See https://github.com/sstephenson/execjs for a list of available runtimes. (ExecJS::RuntimeUnavailable)
    
You need to install a javascript runtime.

You can do that in ubuntu by using:

    sudo apt-get install nodejs
