# frozen_string_literal: true

Given('I have created a new Rails app and installed cucumber-rails, accidentally outside of the test group in my Gemfile') do
  rails_new
  install_cucumber_rails :not_in_test_group
end

Given('I have created a new Rails app and installed cucumber-rails') do
  rails_new
  install_cucumber_rails
end

Given('I have created a new Rails app and installed cucumber-rails with database_cleaner-active_record') do
  rails_new
  install_cucumber_rails :no_database_cleaner, :database_cleaner_active_record
end

Given('I have created a new Rails app and installed cucumber-rails without database_cleaner') do
  rails_new
  install_cucumber_rails :no_database_cleaner
  overwrite_file('features/support/env.rb', "require 'cucumber/rails'\n")
end

Given('I have created a new Rails app with no database and installed cucumber-rails') do
  rails_new args: '--skip-active-record'
  install_cucumber_rails :no_database_cleaner, :no_factory_bot
  overwrite_file('features/support/env.rb', "require 'cucumber/rails'\n")
end

Given('I have a {string} ActiveRecord model object') do |name|
  run_command_and_stop("bundle exec rails g model #{name}")
  run_command_and_stop('bundle exec rake db:migrate RAILS_ENV=test')
end

Given('I remove the {string} gem from the Gemfile') do |gem_name|
  content = File.open(expand_path('Gemfile'), 'r').readlines
  new_content = []

  content.each do |line|
    next if /gem ["|']#{gem_name}["|'].*/.match?(line)

    new_content << line
  end

  overwrite_file('Gemfile', new_content.join("\r\n"))
end

Given('I force selenium to run Firefox in headless mode') do
  selenium_config = %{
    Capybara.register_driver :selenium do |app|
      http_client = Selenium::WebDriver::Remote::Http::Default.new
      http_client.read_timeout = 180

      browser_options = Selenium::WebDriver::Firefox::Options.new
      browser_options.args << '--headless'
      Capybara::Selenium::Driver.new(
        app,
        browser: :firefox,
        options: browser_options,
        http_client: http_client
      )
    end

    Capybara.server = :webrick
  }

  step 'I append to "features/support/env.rb" with:', selenium_config
end

Given('I force {string} to use select boxes for dates') do |file|
  content = File.read(expand_path(file))

  overwrite_file(file, content.gsub(/\.(datetime|time|date)_field/, '.\1_select'))
end

When('I run the cukes') do
  run_command_and_stop('bundle exec cucumber')
end

# Copied from Aruba
Then('the feature run should pass with:') do |string|
  step 'the output should not contain " failed)"'
  step 'the output should not contain " undefined)"'
  step 'the exit status should be 0'
  step 'the output should contain:', string
end
