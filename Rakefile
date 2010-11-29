# encoding: utf-8
require 'rubygems'
require 'bundler/setup'

$:.unshift(File.dirname(__FILE__) + '/lib')
Dir["#{File.dirname(__FILE__)}/dev_tasks/*.rake"].sort.each { |ext| load ext }
task :default => :cucumber