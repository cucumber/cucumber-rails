env_caller = File.dirname(caller.detect{|f| f =~ /\/env\.rb:/}) if caller.detect{|f| f =~ /\/env\.rb:/}
if env_caller
  require 'rails'
  require 'cucumber/rails/application'
  ENV["RAILS_ENV"] ||= "test"
  ENV["RAILS_ROOT"] ||= File.expand_path(env_caller + "/../..")
  require File.expand_path(ENV["RAILS_ROOT"] + '/config/environment')
  require 'cucumber/rails/action_controller'

  if defined?(ActiveRecord::Base)
    require 'rails/test_help'
  else
    require 'action_dispatch/testing/test_process'
    require 'action_dispatch/testing/integration'
  end

  if !Rails.application.config.cache_classes
    warn "WARNING: You have set Rails' config.cache_classes to false (most likely in config/environments/cucumber.rb).  This setting is known to cause problems with database transactions. Set config.cache_classes to true if you want to use transactions.  For more information see https://rspec.lighthouseapp.com/projects/16211/tickets/165."
  end

  require 'cucumber/rails/world'
  require 'cucumber/rails/hooks'
  require 'cucumber/rails/capybara'
  require 'cucumber/rails/database'

else
  warn "WARNING: Cucumber-rails required outside of env.rb.  The rest of loading is being deferred until env.rb is called.
  To avoid this warning, move 'gem \'cucumber-rails\', :require => false' under only group :test in your Gemfile. 
  If already in the :test group, be sure you are specifying ':require => false'."
end
