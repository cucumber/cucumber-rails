begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "cucumber-rails"
    gemspec.summary = "Rails Generators for Cucumber"
    gemspec.description = "Rails Generators for Cucumber"
    gemspec.email = "mail@dennisbloete.de"
    gemspec.homepage = "http://github.com/dbloete/cucumber-rails"
    gemspec.authors = ["Dennis Blöte"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }