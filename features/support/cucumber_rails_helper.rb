# frozen_string_literal: true

require 'rails'
require 'cucumber'
require 'capybara'

module CucumberRailsHelper
  def rails_new(options = {})
    # This expectation allows us to wait until the command line monitor has output a README file (i.e. the command has completed)
    expect(run_rails_new_command(options)).to have_output(/README/)

    cd options[:name]
    configure_rails_gems
    configure_rails_requires
    configure_rails_layout
    clear_bundle_env_vars
  end

  def install_cucumber_rails(*options)
    add_cucumber_rails(options)
    add_rails_conditional_gems
    add_remaining_gems(options)
    bundle_install
    run_command_and_stop 'bundle exec rails generate cucumber:install'
  end

  private

  def run_rails_new_command(options)
    options[:name] ||= 'test_app'
    flags = %w[--skip-action-cable --skip-action-mailer --skip-active-job --skip-bootsnap --skip-bundle --skip-javascript
               --skip-jbuilder --skip-listen --skip-spring --skip-sprockets --skip-test-unit --skip-turbolinks --skip-active-storage]
    flags += %w[--skip-action-mailbox --skip-action-text] if rails_equal_or_higher_than?('6.0')
    run_command "bundle exec rails new #{options[:name]} #{flags.join(' ')} #{options[:args]}"
  end

  def configure_rails_gems
    %w[bootsnap byebug jbuilder listen rails sass-rails turbolinks webpacker].each { |gem| remove_gem(gem) }
    %w[railties activerecord actionpack].each { |rails_gem| add_gem(rails_gem, Rails.version) }
  end

  def configure_rails_requires
    content = File.read(expand_path('config/application.rb'))
    %w[active_job/railtie active_storage/engine action_mailer/railtie action_mailbox/engine
       action_text/engine action_cable/engine rails/test_unit/railtie sprockets/railtie].each do |require|
      content = content.gsub(/^.*require ["']#{require}["']\s*$/, '')
    end
    overwrite_file('config/application.rb', content)
  end

  def configure_rails_layout
    file = 'app/views/layouts/application.html.erb'
    content = File.read(expand_path(file)).gsub(/^\s*<%= stylesheet_link_tag .*%>\s*$/, '')
    overwrite_file(file, content)
  end

  def clear_bundle_env_vars
    unset_bundler_env_vars
    delete_environment_variable 'BUNDLE_GEMFILE'
  end

  def rails_equal_or_higher_than?(version)
    Rails.gem_version >= Gem::Version.new(version)
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

  def convert_gem_opts_to_string(name, *args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    parts = ["'#{name}'"]
    parts << args.map(&:inspect) if args.any?
    parts << options.inspect[1..-2] if options.any?
    "gem #{parts.flatten.join(', ')}\n"
  end

  def add_cucumber_rails(options)
    if options.include?(:not_in_test_group)
      add_gem 'cucumber-rails', path: File.expand_path('.').to_s
    else
      add_gem 'cucumber-rails', group: :test, require: false, path: File.expand_path('.').to_s
    end
  end

  def add_rails_conditional_gems
    if rails_equal_or_higher_than?('6.0')
      add_gem 'sqlite3', '~> 1.4'
      add_gem 'selenium-webdriver', '~> 4.0', group: :test
    else
      add_gem 'sqlite3', '~> 1.3.13'
      add_gem 'selenium-webdriver', '< 4', group: :test
    end

    add_gem 'webdrivers', '~> 5.0' unless rails_equal_or_higher_than?('7.0')
    remove_gem 'chromedriver-helper' unless rails_equal_or_higher_than?('6.0')
  end

  def add_remaining_gems(options)
    add_gem 'cucumber', Cucumber::VERSION, group: :test
    add_gem 'capybara', Capybara::VERSION, group: :test
    add_gem 'database_cleaner', '>= 2.0.0', group: :test unless options.include?(:no_database_cleaner)
    add_gem 'database_cleaner-active_record', '>= 2.0.0', group: :test if options.include?(:database_cleaner_active_record)
    add_gem 'factory_bot', '>= 5.0', group: :test unless options.include?(:no_factory_bot)
    add_gem 'rspec-expectations', '~> 3.12', group: :test
  end

  def bundle_install
    run_command_and_stop 'bundle config set --local without "development"'
    run_command_and_stop "bundle config set --local path '#{ENV.fetch('GITHUB_WORKSPACE')}/vendor/bundle'" if ENV.key?('GITHUB_WORKSPACE')
    run_command_and_stop 'bundle install --jobs 4'
  end
end

World(CucumberRailsHelper)
