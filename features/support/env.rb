$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'rubygems'
require 'bundler/setup'
require 'rspec/expectations'
require 'aruba/cucumber'

Before do
  @aruba_timeout_seconds = 120 # A long time needed some times
  unset_bundler_env_vars
end




if(ENV['ARUBA_REPORT_DIR'])
  # Override reporting behaviour so we don't document all files, only the ones
  # that have been created after @aruba_report_start (a Time object). This is
  # given a value after the Rails app is generated (see cucumber_rails_steps.rb)
  module Aruba
    module Reporting
      def children(dir)
        children = Dir["#{dir}/*"].sort
        
        # include
        children = children.select do |child|
          File.directory?(child) || 
          (@aruba_report_start && File.stat(child).mtime > @aruba_report_start)
        end
        
        # exclude
        children = children.reject do |child|
          child =~ /Gemfile/ || 
          child =~ /\.log$/
        end

        children
      end
    end
  end
end