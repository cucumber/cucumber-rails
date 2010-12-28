# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'cucumber/rails/version'

Gem::Specification.new do |s|
  s.name        = 'cucumber-rails'
  s.version     = Cucumber::Rails::VERSION
  s.authors     = ["Aslak Hellesøy", "Dennis Blöte", "Rob Holland"]
  s.description = "Cucumber Generators and Runtime for Rails"
  s.summary     = "cucumber-rails-#{s.version}"
  s.email       = 'cukes@googlegroups.com'
  s.homepage    = "http://cukes.info"

  s.add_dependency('cucumber', '~> 0.10.0')
  s.add_dependency('rack-test', '~> 0.5.6')
  s.add_development_dependency('aruba', '~> 0.3.0')
  s.add_development_dependency('rails', '~> 3.0.3')
  s.add_development_dependency('sqlite3-ruby', '~> 1.3.2')
  s.add_development_dependency('rspec-rails', Cucumber::Rails::DEPS['rspec-rails'])
  s.add_development_dependency('capybara', Cucumber::Rails::DEPS['capybara'])
  s.add_development_dependency('webrat', Cucumber::Rails::DEPS['webrat'])
  s.add_development_dependency('database_cleaner', Cucumber::Rails::DEPS['database_cleaner'])
  
  s.rubygems_version   = "1.3.7"
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extra_rdoc_files = ["LICENSE", "README.rdoc", "History.txt"]
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"
end
