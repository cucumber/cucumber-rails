# frozen_string_literal: true

CUCUMBER_RAILS_VERSION =
  Gem::Specification.load("#{File.dirname(__FILE__)}/cucumber-rails.gemspec").version.version
require 'rubygems'
require 'bundler'
require 'bundler/setup'
require 'appraisal'
require 'rdoc'
require 'rake/clean'
require 'pathname'
Bundler::GemHelper.install_tasks

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
Dir["#{File.dirname(__FILE__)}/dev_tasks/*.rake"].sort.each { |ext| load ext }

CLEAN.include('doc', 'tmp')

task default: :test

task test: %i[spec cucumber]

namespace :test do
  desc 'Run tests against all gemfiles'
  task :all do
    Rake::Task['appraisal'].invoke('test')
  end

  desc 'Run tests against specified gemfile, e.g. rake test:gemfile[rails_6_0]'
  task :gemfile, :name do |_task, args|
    unless args.name && Pathname.new("gemfiles/#{args.name}.gemfile").exist?
      raise ArgumentError, "You must provide the name of an existing Appraisal gemfile,
        e.g. 'rake test:gemfile[rails_6_0]'"
    end

    Rake::Task["appraisal:#{args.name}"].invoke('test')
  end
end

namespace :gemfiles do
  desc 'Install dependencies for all gemfiles'
  task :install do
    system 'bundle exec appraisal update'
  end

  task :clean do
    FileUtils.rm_rf('gemfiles/*')
  end

  desc 'Rebuild generated gemfiles and install dependencies'
  task rebuild: %i[clean install]
end
