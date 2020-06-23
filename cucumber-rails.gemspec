# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)

Gem::Specification.new do |s|
  s.name        = 'cucumber-rails'
  s.version     = '2.1.0'
  s.authors     = ['Aslak Hellesøy', 'Dennis Blöte', 'Rob Holland']
  s.description = 'Cucumber Generator and Runtime for Rails'
  s.summary     = "#{s.name}-#{s.version}"
  s.email       = 'cukes@googlegroups.com'
  s.homepage    = 'https://cucumber.io'

  s.license = 'MIT'

  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/cucumber/cucumber-rails/issues',
    'changelog_uri' => "https://github.com/cucumber/cucumber-rails/blob/v#{s.version}/CHANGELOG.md",
    'documentation_uri' => 'https://cucumber.io/docs',
    'mailing_list_uri' => 'https://groups.google.com/forum/#!forum/cukes',
    'source_code_uri' => "https://github.com/cucumber/cucumber-rails/tree/v#{s.version}"
  }

  s.add_runtime_dependency('capybara', ['>= 2.12', '< 4'])
  s.add_runtime_dependency('cucumber', ['>= 3.0.2', '< 5'])
  s.add_runtime_dependency('mime-types', ['>= 2.0', '< 4'])
  s.add_runtime_dependency('nokogiri', '~> 1.8')
  s.add_runtime_dependency('rails', ['>= 4.2', '< 7'])

  # Main development dependencies
  s.add_development_dependency('ammeter', '>= 1.1.4')
  s.add_development_dependency('appraisal', '~> 2.2')
  s.add_development_dependency('aruba', '~> 1.0')
  s.add_development_dependency('bundler', '>= 1.17')
  s.add_development_dependency('rake', '>= 12.0')
  s.add_development_dependency('rspec', '~> 3.6')
  s.add_development_dependency('rubocop', '~> 0.85.0')
  s.add_development_dependency('rubocop-performance', '~> 1.6.1')
  s.add_development_dependency('rubocop-rspec', '~> 1.39.0')
  s.add_development_dependency('sqlite3', '~> 1.3')

  # For Documentation:
  s.add_development_dependency('rdoc', '>= 6.0')
  s.add_development_dependency('yard', '~> 0.9.10')

  s.required_ruby_version = '>= 2.4.0'
  s.rubygems_version = '>= 1.6.1'
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.require_path     = 'lib'
end
