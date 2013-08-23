# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'cucumber-rails'
  s.version     = '1.4.0'
  s.authors     = ["Aslak Hellesøy", "Dennis Blöte", "Rob Holland"]
  s.description = "Cucumber Generator and Runtime for Rails"
  s.summary     = "#{s.name}-#{s.version}"
  s.email       = 'cukes@googlegroups.com'
  s.homepage    = "http://cukes.info"

  s.add_runtime_dependency('cucumber', '>= 1.2.0')
  s.add_runtime_dependency('nokogiri', '>= 1.5.0')
  s.add_runtime_dependency('capybara', '>= 1.1.2')
  s.add_runtime_dependency('rails', '>= 3.0.0')

  # Main development dependencies
  s.add_development_dependency('rake', '>= 0.9.2.2')
  s.add_development_dependency('bundler', '~> 1.3.5')
  s.add_development_dependency('aruba', '>= 0.4.11')
  s.add_development_dependency('rspec', '>= 2.2')
  s.add_development_dependency('ammeter', '>= 0.2.9')
  s.add_development_dependency('factory_girl', '>= 3.2.0')
  s.add_development_dependency('database_cleaner', '>= 0.7.2')
  s.add_development_dependency('appraisal', '~> 0.5.1')

  # For Documentation:
  s.add_development_dependency('yard', '~> 0.8.5.2')
  s.add_development_dependency('rdoc', '~> 3.12.2')
  s.add_development_dependency('rdiscount', '~> 2.0.7')
  s.add_development_dependency('bcat', '~> 0.6.2')

  s.rubygems_version = ">= 1.6.1"
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_path     = "lib"
end
