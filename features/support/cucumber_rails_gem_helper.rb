# frozen_string_literal: true

require 'rails'
require 'cucumber'
require 'capybara'

module CucumberRailsGemHelper
  def install_cucumber_rails(*options)
    configure_rails_gems
    add_cucumber_rails(options)
    add_sqlite3_gem
    add_selenium_webdriver_gem
    add_remaining_gems(options)
    bundle_install
    run_command_and_stop 'bundle exec rails generate cucumber:install'
  end

  private

  def configure_rails_gems
    %w[bootsnap byebug jbuilder listen rails sass-rails turbolinks webpacker].each { |gem| remove_gem(gem) }
    %w[railties activerecord actionpack].each { |rails_gem| add_gem(rails_gem, Rails.version) }
  end

  def add_cucumber_rails(options)
    if options.include?(:not_in_test_group)
      add_gem 'cucumber-rails', path: File.expand_path('.').to_s
    else
      add_gem 'cucumber-rails', group: :test, require: false, path: File.expand_path('.').to_s
    end
  end

  def add_sqlite3_gem
    if rails_equal_or_higher_than?('7.1')
      add_gem 'sqlite3', '~> 2.0'
    elsif rails_equal_or_higher_than?('6.0')
      add_gem 'sqlite3', '~> 1.4'
    else
      add_gem 'sqlite3', '~> 1.3.13'
    end
  end

  def add_selenium_webdriver_gem
    if rails_equal_or_higher_than?('7.0')
      add_gem 'selenium-webdriver', '~> 4.22', group: :test
    elsif rails_equal_or_higher_than?('6.0')
      add_gem 'selenium-webdriver', '~> 4.0', group: :test
      add_gem 'webdrivers', '~> 5.0', group: :test
    else
      add_gem 'selenium-webdriver', '< 4', group: :test
      add_gem 'webdrivers', '~> 4.0', group: :test
      remove_gem 'chromedriver-helper'
    end
  end

  def add_remaining_gems(options)
    add_gem 'cucumber', Cucumber::VERSION, group: :test
    add_gem 'capybara', Capybara::VERSION, group: :test
    add_gem 'database_cleaner', '>= 2.0.0', group: :test unless options.include?(:no_database_cleaner)
    add_gem 'database_cleaner-active_record', '>= 2.0.0', group: :test if options.include?(:database_cleaner_active_record)
    if rails_equal_or_higher_than?('6.0')
      add_gem 'factory_bot', '>= 6.4', group: :test unless options.include?(:no_factory_bot)
    else
      add_gem 'factory_bot', '< 6.4', group: :test unless options.include?(:no_factory_bot)
    end
    add_gem 'rspec-expectations', '~> 3.12', group: :test
  end

  def bundle_install
    run_command_and_stop 'bundle config set --local without "development"'
    run_command_and_stop "bundle config set --local path '#{ENV.fetch('GITHUB_WORKSPACE')}/vendor/bundle'" if ENV.key?('GITHUB_WORKSPACE')
    run_command_and_stop 'bundle install --jobs 4'
  end

  def convert_gem_opts_to_string(name, *args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    parts = ["'#{name}'"]
    parts << args.map(&:inspect) if args.any?
    parts << options.inspect[1..-2] if options.any?
    "gem #{parts.flatten.join(', ')}\n"
  end

  def remove_gem(name)
    content = File.read(expand_path('Gemfile')).gsub(/^\s*gem ["']#{name}["'].*$/, '')
    overwrite_file('Gemfile', content)
  end

  def add_gem(name, *args)
    line = convert_gem_opts_to_string(name, *args)
    gem_regexp = /gem ["']#{name}["'].*$/
    gemfile_content = File.read(expand_path('Gemfile'))

    if gemfile_content.match?(gem_regexp)
      updated_gemfile_content = gemfile_content.gsub(gem_regexp, line)
      overwrite_file('Gemfile', updated_gemfile_content)
    else
      append_to_file('Gemfile', line)
    end
  end

  def rails_equal_or_higher_than?(version)
    Rails.gem_version >= Gem::Version.new(version)
  end
end

World(CucumberRailsGemHelper)
