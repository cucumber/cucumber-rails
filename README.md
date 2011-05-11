# Cucumber-Rails

Cucumber-Rails brings Cucumber to Rails3. It contains 2 generators - one
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

## Hacking on Cucumber-Rails

If you have a bugfix or a new feature you want to contribute, please fork on Github and make your own feature branch:

  git clone git@github.com:you/cucumber-rails.git
  git checkout -b 87-my-awesome-bugfix

The feature branch should contain a ticket number (if applicable) and a descriptive name that aligns with the ticket name.
When you think you're done send a pull request.

### Setting up your environment

I strongly recommend rvm and ruby 1.9.2. When you have that, cd into your cucumber-rails repository and:

  gem install bundler
  bundle install

### Running all features

  rake cucumber

One of the features uses MongoDB, which needs to be running in order to make features/mongoid.feature to pass.
