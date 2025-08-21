# frozen_string_literal: true

require 'rbconfig'

module Cucumber
  class InstallGenerator < ::Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    DEFAULT_SHEBANG = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])

    class_option :skip_database,
                 type: :boolean,
                 desc: 'Skip modification of database.yml',
                 aliases: '-D',
                 default: false

    def create_templates
      template 'config/cucumber.yml.erb', 'config/cucumber.yml'
    end

    def create_scripts
      copy_file 'bin/cucumber', 'bin/cucumber'
      chmod     'bin/cucumber', 0755
    end

    def create_step_definitions
      empty_directory 'features/step_definitions'
      create_file 'features/step_definitions/.keep'
    end

    def create_feature_support
      empty_directory 'features/support'
      template 'support/env.rb.erb', 'features/support/env.rb'
    end

    def configure_environment
      environment(<<~CONFIG, env: %w[development test])
        # Configure 'rails notes' to inspect Cucumber files
        config.annotations.register_directories('features')
        config.annotations.register_extensions('feature') { |tag| /#\\s*(\#{tag}):?\\s*(.*)$/ }

      CONFIG
    end

    def create_tasks
      empty_directory 'lib/tasks'
      template 'tasks/cucumber.rake.erb', 'lib/tasks/cucumber.rake'
    end

    def create_database
      return unless File.exist?('config/database.yml')
      return unless File.read('config/database.yml').include? 'cucumber:'

      gsub_file 'config/database.yml', /^test:.*\n/, "test: &test\n"
      gsub_file 'config/database.yml', /\z/, "\ncucumber:\n  <<: *test\n"
    end

    protected

    def embed_file(source, indent = '')
      File.read(File.join(self.class.source_root, source)).gsub(/^/, indent)
    end

    def embed_template(source, indent = '')
      template = File.join(self.class.source_root, source)
      ERB.new(File.read(template), trim_mode: '-').result(binding).gsub(/^/, indent)
    end
  end
end
