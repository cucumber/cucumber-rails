$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'fileutils'
require 'rubygems'
require 'spec'

Before do
  FileUtils.rm_rf("tmp") if File.directory?("tmp")
  Dir.mkdir("tmp")
end