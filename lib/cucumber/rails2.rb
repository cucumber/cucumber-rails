require 'cucumber/rails2/action_controller'
ENV["RAILS_ENV"] ||= "cucumber"
env = caller.detect{|f| f =~ /\/env\.rb:/}
require File.expand_path(File.dirname(env) + '/../../config/environment')


if defined?(ActiveRecord::Base)
  require 'test_help' 
else
  require 'action_dispatch/testing/test_process'
  require 'action_dispatch/testing/integration'
end

if !Rails.configuration.cache_classes
  warn "WARNING: You have set Rails' config.cache_classes to false (most likely in config/environments/cucumber.rb).  This setting is known to cause problems with database transactions. Set config.cache_classes to true if you want to use transactions.  For more information see https://rspec.lighthouseapp.com/projects/16211/tickets/165."
end
