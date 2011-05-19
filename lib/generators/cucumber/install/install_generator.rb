require 'rbconfig'

module Cucumber
  class InstallGenerator < ::Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'], Config::CONFIG['ruby_install_name'])

    argument     :language,      :type => :string,  :banner => "LANG", :optional => true

    class_option :rspec,         :type => :boolean, :desc => "Use RSpec"
    class_option :testunit,      :type => :boolean, :desc => "Use Test::Unit"
    class_option :spork,         :type => :boolean, :desc => "Use Spork"
    class_option :skip_database, :type => :boolean, :desc => "Skip modification of database.yml", :aliases => '-D', :default => false

    attr_reader :framework

    def create_templates
      template 'config/cucumber.yml.erb', 'config/cucumber.yml'
    end

    def create_scripts
      copy_file 'script/cucumber', 'script/cucumber'
      chmod     'script/cucumber', 0755
    end

    def create_step_definitions
      empty_directory 'features/step_definitions'

      template "step_definitions/web_steps.rb.erb", 'features/step_definitions/web_steps.rb'
      if language
        template "step_definitions/web_steps_#{language}.rb.erb", "features/step_definitions/web_steps_#{language}.rb"
      end
    end

    def create_feature_support
      empty_directory 'features/support'
      copy_file       'support/paths.rb',     'features/support/paths.rb'
      copy_file       'support/selectors.rb', 'features/support/selectors.rb'

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

    private

    def framework_from_options
      return 'rspec-rails' if options[:rspec]
      return 'testunit' if options[:testunit]
      return 'rspec-rails'
    end

  end
end