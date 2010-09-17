# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'cucumber-rails'
  s.version     = '0.3.3'
  s.authors     = ["Aslak Hellesøy", "Dennis Blöte", "Rob Holland"]
  s.description = "Cucumber Generators and Runtime for Rails"
  s.summary     = "cucumber-rails-#{s.version}"
  s.email       = 'cukes@googlegroups.com'
  s.homepage    = "http://cukes.info"

  s.platform    = Gem::Platform::RUBY

  s.add_dependency('cucumber', '~> 0.9.0') unless File.directory?(File.expand_path(File.dirname(__FILE__) + '/../cucumber'))
  s.add_dependency 'aruba', '~> 0.2.2' unless File.directory?(File.expand_path(File.dirname(__FILE__) + '/../aruba'))
  s.add_development_dependency('rspec-rails', "~> 2.0.0.beta.22")
  
  s.rubygems_version   = "1.3.7"
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extra_rdoc_files = ["LICENSE", "README.rdoc", "History.txt"]
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"
end
