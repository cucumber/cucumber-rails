require 'rails'
if Rails.version.to_f < 3.0
  require 'cucumber/rails2'
else
  require 'cucumber/rails3'
end
  
require 'cucumber/rails/world'
require 'cucumber/rails/hooks/database_cleaner'
require 'cucumber/rails/hooks/allow_rescue'
require 'cucumber/rails/hooks/mail'

if defined?(Capybara)
  require 'capybara/rails'
  require 'capybara/cucumber'
  require 'capybara/session'
  require 'cucumber/rails/capybara/javascript_emulation'
  require 'cucumber/rails/capybara/select_dates_and_times'
end

if defined?(Webrat)
end

require 'cucumber/web/tableish'

if !defined?(ActiveRecord::Base)
  module Cucumber::Rails
    def World.fixture_table_names; []; end # Workaround for projects that don't use ActiveRecord
  end
end