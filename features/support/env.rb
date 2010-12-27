ENV['CUCUMBER_RAILS_TEST'] = 'yeah baby'
$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'rubygems'
require 'bundler/setup'
require 'rspec/expectations'
require 'aruba/cucumber'

Before do
  @aruba_timeout_seconds = 10
end