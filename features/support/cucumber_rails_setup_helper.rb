# frozen_string_literal: true

require 'rails'
require 'cucumber'
require 'capybara'

module CucumberRailsSetupHelper
  def rails_new(options = {})
    # This expectation allows us to wait until the command line monitor has output a README file (i.e. the command has completed)
    expect(run_rails_new_command(options)).to have_output(/README/)

    cd 'test_app'
    configure_rails_requires
    configure_rails_layout
    clear_bundle_env_vars
  end

  private

  def run_rails_new_command(options)
    flags = %w[--skip-action-cable --skip-action-mailer --skip-active-job --skip-bootsnap --skip-bundle --skip-javascript
               --skip-jbuilder --skip-listen --skip-spring --skip-sprockets --skip-test-unit --skip-turbolinks
               --skip-active-storage --skip-action-mailbox --skip-action-text]
    run_command "bundle exec rails new test_app #{flags.join(' ')} #{options[:args]}"
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
end

World(CucumberRailsSetupHelper)
