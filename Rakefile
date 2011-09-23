# encoding: utf-8
CUCUMBER_RAILS_VERSION = Gem::Specification.load(File.dirname(__FILE__) + '/cucumber-rails.gemspec').version.version
require 'rubygems'
require 'bundler/setup'
Bundler::GemHelper.install_tasks

$:.unshift(File.dirname(__FILE__) + '/lib')
Dir["#{File.dirname(__FILE__)}/dev_tasks/*.rake"].sort.each { |ext| load ext }


# Needed for selenium browser
# See http://about.travis-ci.org/docs/user/selenium-setup/
task :travis do
  ["rspec spec", "rake cucumber"].each do |cmd|
    puts "Starting to run #{cmd}..."
    system("export DISPLAY=:99.0 && bundle exec #{cmd}")
    raise "#{cmd} failed!" unless $?.exitstatus == 0
  end
end

if ENV['TRAVIS']
  task :default => :travis
else
  task :default => :cucumber
end