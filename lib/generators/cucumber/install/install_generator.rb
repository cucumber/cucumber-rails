require 'rbconfig'

module Cucumber
  class InstallGenerator < ::Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    DEFAULT_SHEBANG = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])

    class_option :spork,         :type => :boolean, :desc => "Use Spork"
    class_option :skip_database, :type => :boolean, :desc => "Skip modification of database.yml", :aliases => '-D', :default => false

    def create_templates
      template 'config/cucumber.yml.erb', 'config/cucumber.yml'
    end

    def create_scripts
      copy_file 'script/cucumber', 'script/cucumber'
      chmod     'script/cucumber', 0755
    end

    def create_step_definitions
      empty_directory 'features/step_definitions'
    end

    def create_feature_support
      empty_directory 'features/support'
      if spork?
        template 'support/rails_spork.rb.erb', 'features/support/env.rb'
      else
        template 'support/rails.rb.erb',       'features/support/env.rb'
      end
    end

    def create_tasks
      empty_directory 'lib/tasks'
      template 'tasks/cucumber.rake.erb', 'lib/tasks/cucumber.rake'
    end

    def create_database
      return unless File.exist?('config/database.yml')
      unless File.read('config/database.yml').include? 'cucumber:'
        gsub_file 'config/database.yml', /^test:.*\n/, "test: &test\n"
        gsub_file 'config/database.yml', /\z/, "\ncucumber:\n  <<: *test"
        
        # Since gsub_file doesn't ask the user, just inform user that the file was overwritten.
        puts "       force  config/database.yml"
      end
    end

    protected

    def spork?
      options[:spork]
    end

    def embed_file(source, indent='')
      IO.read(File.join(self.class.source_root, source)).gsub(/^/, indent)
    end

    def embed_template(source, indent='')
      template = File.join(self.class.source_root, source)
      ERB.new(IO.read(template), nil, '-').result(binding).gsub(/^/, indent)
    end

  end
end