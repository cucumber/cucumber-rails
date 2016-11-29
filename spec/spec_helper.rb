require 'rubygems'

require 'rails/version'
require 'rspec/rails/fixture_support'
# Avoid load order issues in activesupport
require 'active_support/deprecation'
# Ensure Rails stuff is present before ammeter needs it
require 'rails/all'
require 'ammeter/init'
