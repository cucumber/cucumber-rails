# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)

Gem::Specification.new do |s|
  s.name        = 'cucumber-rails'
  s.version     = '2.4.0'
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

  s.add_runtime_dependency('capybara', ['>= 2.18', '< 4']) # We support legacy capybara (But only the last 2.x)
  s.add_runtime_dependency('cucumber', ['>= 3.2', '< 8']) # Support cucumber in the 3.x <-> 7.x revision range
  s.add_runtime_dependency('mime-types', ['~> 3.3']) # Only support the latest major (3+ years old)
  s.add_runtime_dependency('nokogiri', '~> 1.10') # Only support the latest major (3+ years old)
  s.add_runtime_dependency('railties', ['>= 5.0', '< 8']) # We support any version of Rails in the 5, 6 and 7 series
  s.add_runtime_dependency('rexml', '~> 3.0') # rexml is a bundled gem from ruby 3
  s.add_runtime_dependency('webrick', '~> 1.7') # webrick is a bundled gem from ruby 3

  # Main development dependencies
  s.add_development_dependency('ammeter', '>= 1.1.4')
  s.add_development_dependency('appraisal', '< 2.4') # See: https://github.com/thoughtbot/appraisal/issues/186
  s.add_development_dependency('aruba', '~> 1.0')
  s.add_development_dependency('bundler', '>= 1.17')
  s.add_development_dependency('database_cleaner', ['>= 1.8', '< 3.0'])
  s.add_development_dependency('rake', '>= 12.0')
  s.add_development_dependency('rspec', '~> 3.6')
  s.add_development_dependency('rubocop', '~> 1.7.0')
  s.add_development_dependency('rubocop-packaging', '~> 0.5.1')
  s.add_development_dependency('rubocop-performance', '~> 1.10.2')
  s.add_development_dependency('rubocop-rspec', '~> 2.2.0')
  s.add_development_dependency('sqlite3', '~> 1.3')

  # For Documentation:
  s.add_development_dependency('rdoc', '>= 6.0')
  s.add_development_dependency('yard', '~> 0.9.10')

  s.required_ruby_version = '>= 2.4.0'
  s.rubygems_version = '>= 1.6.1'
  s.require_path     = 'lib'
  s.files            = Dir['lib/**/*', 'CHANGELOG.md', 'CONTRIBUTING.md', 'LICENSE', 'README.md']
end
