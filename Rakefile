# encoding: utf-8
CUCUMBER_RAILS_VERSION = Gem::Specification.load(File.dirname(__FILE__) + '/cucumber-rails.gemspec').version.version
require 'rubygems'
require 'bundler/setup'
Bundler::GemHelper.install_tasks

$:.unshift(File.dirname(__FILE__) + '/lib')
Dir["#{File.dirname(__FILE__)}/dev_tasks/*.rake"].sort.each { |ext| load ext }
task :default => :cucumber