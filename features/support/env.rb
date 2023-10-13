# frozen_string_literal: true

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../../lib")

require 'rspec/expectations'
require 'aruba/cucumber'

Aruba.configure do |config|
  config.exit_timeout = 360
end
