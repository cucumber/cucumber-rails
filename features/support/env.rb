$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'rubygems'
require 'bundler'
Bundler.setup
require 'rspec/expectations'
require 'aruba'
require 'aruba/rails3'
require 'aruba/rails2'
