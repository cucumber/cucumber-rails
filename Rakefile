# frozen_string_literal: true

require 'appraisal'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'

Cucumber::Rake::Task.new
RSpec::Core::RakeTask.new

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")

task default: :test
task test: %i[spec cucumber]

namespace :test do
  desc 'Run tests against all gemfiles'
  task :all do
    Rake::Task['appraisal'].invoke('test')
  end

  desc 'Run tests against specified gemfile, e.g. rake test:gemfile[rails_8_0]'
  task :full, :name do |_task, args|
    unless args.name && File.exist?("gemfiles/#{args.name}.gemfile")
      raise ArgumentError, "You must provide the name of an existing Appraisal gemfile,
        e.g. 'rake test:full[rails_8_0]'"
    end

    Rake::Task["appraisal:#{args.name}"].invoke('test')
  end

  desc 'Run unit tests only against specified gemfile, e.g. rake test:gemfile[rails_8_0]'
  task :spec, :name do |_task, args|
    unless args.name && File.exist?("gemfiles/#{args.name}.gemfile")
      raise ArgumentError, "You must provide the name of an existing Appraisal gemfile,
        e.g. 'rake test:spec[rails_8_0]'"
    end

    system "BUNDLE_GEMFILE=/home/luke/Code/cucumber-rails/gemfiles/#{args.name}.gemfile bundle exec rspec"
  end
end

namespace :gemfiles do
  desc 'Re-install dependencies for all gemfiles'
  task :reinstall do
    system 'bundle exec appraisal update'
  end

  desc 'Remove all generated gemfiles'
  task :clean do
    system 'bundle exec appraisal clean'
  end

  desc 'Remove all generated gemfiles and re-install dependencies'
  task rebuild: %i[clean reinstall]
end
