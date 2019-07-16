# frozen_string_literal: true

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'rubygems'
require 'bundler/setup'
require 'rspec/expectations'
require 'aruba/cucumber'

After do |scenario|
  if scenario.failed?
    puts last_command_stopped.stdout
    puts last_command_stopped.stderr
  end
end
