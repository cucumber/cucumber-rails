# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'cucumber-rails'
  s.version     = '1.7.0'
  s.authors     = ["Aslak Hellesøy", "Dennis Blöte", "Rob Holland"]
  s.description = "Cucumber Generator and Runtime for Rails"
  s.summary     = "#{s.name}-#{s.version}"
  s.email       = 'cukes@googlegroups.com'
  s.homepage    = "http://cukes.info"

  s.license = 'MIT'

  s.required_ruby_version = '>= 2.2'

  s.add_runtime_dependency('capybara', ['>= 2.3.0', '< 4'])
  s.add_runtime_dependency('cucumber', ['>= 3.0.2', '< 4'])
  s.add_runtime_dependency('nokogiri', '~> 1.8')
  s.add_runtime_dependency('railties', ['>= 4.2', '< 7'])
  s.add_runtime_dependency('mime-types', ['>= 1.17', '< 4'])

  # Main development dependencies
  s.add_development_dependency('ammeter', ['>= 1.0.0', '!= 1.1.3'])
  s.add_development_dependency('appraisal', '>= 0.5.1')
  s.add_development_dependency('aruba', '~> 0.14.2')
  s.add_development_dependency('bundler', '>= 1.3.5')
  s.add_development_dependency('rubocop', '~> 0.66.0')
  s.add_development_dependency('rake', '>= 10.3')
  s.add_development_dependency('rspec', '~> 3.5')
  s.add_development_dependency('rails', ['>= 4.2', '< 7'])
  s.add_development_dependency('sqlite3', '~> 1.3.13')

  # For Documentation:
  s.add_development_dependency('rdiscount', '>= 2.0.7')
  s.add_development_dependency('rdoc', '>= 3.4')
  s.add_development_dependency('yard', '>= 0.8.7')

  s.required_ruby_version = '>= 2.2.0'
  s.rubygems_version = ">= 1.6.1"
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.require_path     = "lib"
end
