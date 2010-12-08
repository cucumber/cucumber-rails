require 'cucumber/rails3/application'
ENV["RAILS_ENV"] ||= "test"
env = caller.detect{|f| f =~ /\/env\.rb:/}
require File.expand_path(File.dirname(env) + '/../../config/environment')
require 'cucumber/rails3/action_controller'

if defined?(ActiveRecord::Base)
  require 'rails/test_help' 
else
  require 'action_controller/test_process'
  require 'action_controller/integration'
end

if !Rails.application.config.cache_classes
  warn "WARNING: You have set Rails' config.cache_classes to false (most likely in config/environments/test.rb).  This setting is known to break Cucumber's use_transactional_fixtures method. Set config.cache_classes to true if you want to use transactional fixtures.  For more information see https://rspec.lighthouseapp.com/projects/16211/tickets/165."
end