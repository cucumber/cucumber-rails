# frozen_string_literal: true

called_from_env_rb = caller.detect { |f| f.include? '/env.rb:' }

if called_from_env_rb
  env_caller = File.dirname(called_from_env_rb)

  require 'rails'
  require 'cucumber/rails/application'
  ENV['RAILS_ENV'] ||= 'test'
  ENV['RAILS_ROOT'] ||= File.expand_path("#{env_caller}/../..")
  require File.expand_path("#{ENV.fetch('RAILS_ROOT')}/config/environment")
  require 'cucumber/rails/action_dispatch'
  require 'rails/test_help'

  unless Rails.application.config.cache_classes || defined?(Spring)
    warn <<~MESSAGE
      WARNING: You have set Rails' config.cache_classes to false (Spring needs cache_classes set to false).
      This is known to cause problems with database transactions.

      Set config.cache_classes to true if you want to use transactions.
    MESSAGE
  end

  require 'cucumber/rails/world'
  require 'cucumber/rails/hooks'
  require 'cucumber/rails/capybara'
  require 'cucumber/rails/database/strategy'
  require 'cucumber/rails/database/deletion_strategy'
  require 'cucumber/rails/database/null_strategy'
  require 'cucumber/rails/database/shared_connection_strategy'
  require 'cucumber/rails/database/truncation_strategy'
  require 'cucumber/rails/database'

  MultiTest.disable_autorun
else
  warn <<~MESSAGE
    WARNING: Cucumber-rails has been required outside of env.rb. The rest of loading is being deferred until env.rb is called.

    To avoid this warning, move `gem 'cucumber-rails', require: false` under `group :test` in your Gemfile.
    If it is already in the `:test` group, be sure you are specifying 'require: false'.
  MESSAGE
end
