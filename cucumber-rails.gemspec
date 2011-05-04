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

  s.add_dependency('cucumber', Cucumber::Rails::DEPS['cucumber'])
  s.add_dependency('rack-test', Cucumber::Rails::DEPS['rack-test'])
  s.add_dependency('nokogiri', Cucumber::Rails::DEPS['nokogiri'])
  s.add_development_dependency('bundler', Cucumber::Rails::DEPS['bundler'])
  s.add_development_dependency('aruba', Cucumber::Rails::DEPS['aruba'])
  s.add_development_dependency('rails', Cucumber::Rails::DEPS['rails'])
  s.add_development_dependency('sqlite3-ruby', Cucumber::Rails::DEPS['sqlite3-ruby'])
  s.add_development_dependency('rspec-rails', Cucumber::Rails::DEPS['rspec-rails'])
  s.add_development_dependency('capybara', Cucumber::Rails::DEPS['capybara'])
  s.add_development_dependency('webrat', Cucumber::Rails::DEPS['webrat'])
  s.add_development_dependency('database_cleaner', Cucumber::Rails::DEPS['database_cleaner'])
  s.add_development_dependency('mongoid', Cucumber::Rails::DEPS['mongoid'])
  s.add_development_dependency('bson_ext', Cucumber::Rails::DEPS['bson_ext'])
  s.add_development_dependency('akephalos', Cucumber::Rails::DEPS['akephalos'])

  s.rubygems_version = ">= 1.6.1"
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extra_rdoc_files = ["LICENSE", "README.rdoc", "History.txt"]
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"
end
