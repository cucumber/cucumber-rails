# frozen_string_literal: true

module CucumberRailsHelper
  def rails_new(options = {})
    validate_rails_new_success(run_rails_new_command(options))
    clear_bundle_env_vars(options[:name])
  end

  def install_cucumber_rails(*options)
    add_conditional_gems(options)

    add_gem 'capybara', group: :test
    add_gem 'selenium-webdriver', '~> 3.11', group: :test
    add_gem 'rspec-expectations', '~> 3.7', group: :test
    add_gem 'database_cleaner', '>= 1.8.0', group: :test unless options.include?(:no_database_cleaner)
    add_gem 'factory_bot', '>= 3.2', group: :test unless options.include?(:no_factory_bot)

    run_command_and_stop 'bundle install'
    run_command_and_stop 'bundle exec rails webpacker:install' if rails6?
    run_command_and_stop 'bundle exec rails generate cucumber:install'
  end

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

  private

  def run_rails_new_command(options)
    options[:name] ||= 'test_app'
    flags = '--skip-bundle --skip-test-unit --skip-spring --skip-bootsnap'
    flags += ' --skip-webpack-install' if rails6?
    run_command "bundle exec rails new #{options[:name]} #{flags} #{options[:args]}"
  end

  def validate_rails_new_success(result)
    expect(result).to have_output(/README/)
    expect(last_command_started).to be_successfully_executed
  end

  def clear_bundle_env_vars(dir)
    cd dir
    delete_environment_variable 'RUBYOPT'
    delete_environment_variable 'BUNDLE_BIN_PATH'
    delete_environment_variable 'BUNDLE_GEMFILE'
  end

  def rails6?
    `bundle exec rails -v`.start_with?('Rails 6')
  end

  def add_conditional_gems(options)
    if options.include?(:not_in_test_group)
      add_gem 'cucumber-rails', path: File.expand_path('.').to_s
    else
      add_gem 'cucumber-rails', group: :test, require: false, path: File.expand_path('.').to_s
    end

    if rails6?
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
