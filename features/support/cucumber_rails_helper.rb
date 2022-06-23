# frozen_string_literal: true

require 'rails'
require 'cucumber'
require 'capybara'

module CucumberRailsHelper
  def rails_new(options = {})
    validate_rails_new_success(run_rails_new_command(options))
    cd options[:name]
    configure_rails_gems
    configure_rails_requires
    configure_rails_layout
    clear_bundle_env_vars
  end

  def install_cucumber_rails(*options)
    add_conditional_gems(options)

    add_gem 'cucumber', Cucumber::VERSION, group: :test
    add_gem 'capybara', Capybara::VERSION, group: :test
    add_gem 'selenium-webdriver', '~> 3.11', group: :test
    add_gem 'rspec-expectations', '~> 3.7', group: :test
    add_gem 'database_cleaner', '>= 1.8.0', group: :test unless options.include?(:no_database_cleaner)
    add_gem 'database_cleaner-active_record', '>= 2.0.0.beta2', group: :test if options.include?(:database_cleaner_active_record)
    add_gem 'factory_bot', '>= 3.2', group: :test unless options.include?(:no_factory_bot)

    bundle_install
    run_command_and_stop 'bundle exec rails generate cucumber:install'
  end

  private

  def add_gem(name, *args)
    line = convert_gem_opts_to_string(name, *args)
    gem_regexp = /gem ["']#{name}["'].*$/
    gemfile_content = File.read(expand_path('Gemfile'))

    if gemfile_content&.match?(gem_regexp)
      updated_gemfile_content = gemfile_content.gsub(gem_regexp, line)
      overwrite_file('Gemfile', updated_gemfile_content)
    else
      append_to_file('Gemfile', line)
    end
  end

  def remove_gem(name)
    content = File.read(expand_path('Gemfile')).gsub(/^\s*gem ["']#{name}["'].*$/, '')
    overwrite_file('Gemfile', content)
  end

  def bundle_install
    run_command_and_stop 'bundle config set --local without "development"'
    run_command_and_stop "bundle config set --local path '#{ENV.fetch('GITHUB_WORKSPACE')}/vendor/bundle'" if ENV.key?('GITHUB_WORKSPACE')
    run_command_and_stop 'bundle install --jobs 4'
  end

  def configure_rails_gems
    %w[bootsnap byebug jbuilder listen rails sass-rails turbolinks webpacker].each { |gem| remove_gem(gem) }
    %w[railties activerecord actionpack].each { |rails_gem| add_gem(rails_gem, Rails.version) }
  end

  def configure_rails_requires
    content = File.read(expand_path('config/application.rb'))
    %w[ active_job/railtie active_storage/engine action_mailer/railtie action_mailbox/engine
        action_text/engine action_cable/engine rails/test_unit/railtie sprockets/railtie ].each do |require|
      content = content.gsub(/^.*require ["']#{require}["']\s*$/, '')
    end
    overwrite_file('config/application.rb', content)
  end

  def configure_rails_layout
    file = 'app/views/layouts/application.html.erb'
    content = File.read(expand_path(file)).gsub(/^\s*<%= stylesheet_link_tag .*%>\s*$/, '')
    overwrite_file(file, content)
  end

  def run_rails_new_command(options)
    options[:name] ||= 'test_app'
    flags = %w[ --skip-action-cable --skip-action-mailer --skip-active-job --skip-bootsnap --skip-bundle --skip-javascript
                --skip-jbuilder --skip-listen --skip-spring --skip-sprockets --skip-test-unit --skip-turbolinks ]
    flags += %w[--skip-active-storage] if rails_5_2_or_higher?
    flags += %w[--skip-action-mailbox --skip-action-text] if rails_6_0_or_higher?
    run_command "bundle exec rails new #{options[:name]} #{flags.join(' ')} #{options[:args]}"
  end

  def validate_rails_new_success(result)
    expect(result).to have_output(/README/)
    expect(last_command_started).to be_successfully_executed
  end

  def clear_bundle_env_vars
    unset_bundler_env_vars
    delete_environment_variable 'BUNDLE_GEMFILE'
  end

  def rails_5_2_or_higher?
    Rails.gem_version >= Gem::Version.new('5.2')
  end

  def rails_6_0_or_higher?
    Rails.gem_version >= Gem::Version.new('6.0')
  end

  def add_conditional_gems(options)
    if options.include?(:not_in_test_group)
      add_gem 'cucumber-rails', path: File.expand_path('.').to_s
    else
      add_gem 'cucumber-rails', group: :test, require: false, path: File.expand_path('.').to_s
    end

    if rails_6_0_or_higher?
      add_gem 'sqlite3', '~> 1.4'
    else
      add_gem 'sqlite3', '~> 1.3.13'
    end
  end

  def convert_gem_opts_to_string(name, *args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    parts = ["'#{name}'"]
    parts << args.map(&:inspect) if args.any?
    parts << options.inspect[1..-2] if options.any?
    new_parts = parts.flatten.map { |part| part.gsub(/:(\w+)=>/, '\1: ') }
    "gem #{new_parts.join(', ')}\n"
  end
end

World(CucumberRailsHelper)
