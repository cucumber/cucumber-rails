# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)

Gem::Specification.new do |s|
  s.name        = 'cucumber-rails'
  s.version     = File.read("#{__dir__}/VERSION")
  s.authors     = ['Aslak Hellesøy', 'Dennis Blöte', 'Rob Holland']
  s.description = 'Cucumber Generator and Runtime for Rails'
  s.summary     = "#{s.name}-#{s.version}"
  s.email       = 'cukes@googlegroups.com'
  s.homepage    = 'https://cucumber.io'

  s.license = 'MIT'

  s.required_ruby_version = '>= 2.6.0'
  s.required_rubygems_version = '>= 3.2.3'

  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/cucumber/cucumber-rails/issues',
    'changelog_uri' => "https://github.com/cucumber/cucumber-rails/blob/v#{s.version}/CHANGELOG.md",
    'documentation_uri' => 'https://cucumber.io/docs',
    'mailing_list_uri' => 'https://groups.google.com/forum/#!forum/cukes',
    'source_code_uri' => "https://github.com/cucumber/cucumber-rails/tree/v#{s.version}"
  }

  s.add_runtime_dependency('capybara', '>= 3.11', '< 4')
  s.add_runtime_dependency('cucumber', '>= 5', '< 10')
  s.add_runtime_dependency('railties', '>= 5.2', '< 8')

  # Main development dependencies
  s.add_development_dependency('ammeter', '>= 1.1.5')
  s.add_development_dependency('appraisal', '>= 2.4.1', '< 3')
  s.add_development_dependency('aruba', '>= 1.1.2', '< 3')
  s.add_development_dependency('database_cleaner', '>= 1.8', '< 3.0')
  s.add_development_dependency('rails', '>= 5.2', '< 8')
  s.add_development_dependency('rake', '>= 12.0')
  s.add_development_dependency('rspec', '~> 3.6')
  s.add_development_dependency('rubocop', '~> 1.45.0')
  s.add_development_dependency('rubocop-packaging', '~> 0.5.2')
  s.add_development_dependency('rubocop-performance', '~> 1.17.0')
  s.add_development_dependency('rubocop-rspec', '~> 2.12.0')

  # For Documentation:
  s.add_development_dependency('yard', '~> 0.9.10')

  s.require_path     = 'lib'
  s.files            = Dir['lib/**/*', 'CHANGELOG.md', 'CONTRIBUTING.md', 'LICENSE', 'README.md']
end
