require 'rbconfig'
require 'cucumber/rails/version'

module Cucumber
  module Generators
    module InstallBase
      DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'], Config::CONFIG['ruby_install_name'])

      def install_cucumber_rails(m)
        check_upgrade_limitations
        create_templates(m)
        create_scripts(m)
        create_step_definitions(m)
        create_feature_support(m)
        create_tasks(m)
        create_database(m) unless options[:skip_database]
      end

      # Checks and prints the limitations
      def check_upgrade_limitations
        if File.exist?('features/step_definitions/webrat_steps.rb')
          STDERR.puts "Please remove features/step_definitions/webrat_steps.rb\n" +
          "See upgrading instructions for 0.2.0 in History.txt"
          exit(1)
        end

        if File.exist?('features/support/version_check.rb')
          STDERR.puts "Please remove features/support/version_check.rb\n" +
          "See upgrading instructions for 0.2.0 in History.txt"
          exit(1)
        end
      end

      # Creates templates
      def create_templates(m)
        m.template 'config/cucumber.yml.erb', 'config/cucumber.yml'
        if rails2?
          m.template 'environments/cucumber.rb.erb', 'config/environments/cucumber.rb'
        end
      end

      def create_scripts(m)
        if rails2?
          m.file 'script/cucumber', 'script/cucumber', {
            :chmod => 0755, :shebang => options[:shebang] == DEFAULT_SHEBANG ? nil : options[:shebang]
          }
        else
          m.copy_file 'script/cucumber', 'script/cucumber'
          m.chmod     'script/cucumber', 0755
        end
      end

      def create_step_definitions(m)
        if rails2?
          m.directory 'features/step_definitions'
        else
          m.empty_directory 'features/step_definitions'
        end

        m.template "step_definitions/#{driver}_steps.rb.erb", 'features/step_definitions/web_steps.rb'
        if language != 'en'
          m.template "step_definitions/web_steps_#{language}.rb.erb", "features/step_definitions/web_steps_#{language}.rb"
        end
      end

      def create_feature_support(m)
        if rails2?
          m.directory 'features/support'
          m.file      'support/paths.rb',     'features/support/paths.rb'
          m.file      'support/selectors.rb', 'features/support/selectors.rb'
        else
          m.empty_directory 'features/support'
          m.copy_file       'support/paths.rb',     'features/support/paths.rb'
          m.copy_file       'support/selectors.rb', 'features/support/selectors.rb'
        end

        if spork?
          m.template 'support/rails_spork.rb.erb', 'features/support/env.rb'
        else
          m.template 'support/rails.rb.erb',       'features/support/env.rb'
        end
      end

      def create_tasks(m)
        if rails2?
          m.directory 'lib/tasks'
        else
          m.empty_directory 'lib/tasks'
        end

        m.template 'tasks/cucumber.rake.erb', 'lib/tasks/cucumber.rake'
      end

      def create_database(m)
        return unless File.exist?('config/database.yml')
        unless File.read('config/database.yml').include? 'cucumber:'
          m.gsub_file 'config/database.yml', /^test:.*\n/, "test: &test\n"
          m.gsub_file 'config/database.yml', /\z/, "\ncucumber:\n  <<: *test"
          
          # Since gsub_file doesn't ask the user, just inform user that the file was overwritten.
          puts "       force  config/database.yml"
        end
      end

      protected

      def add_gem(*args)
        if rails2?
        else
          self.gem(*args)
        end
      end

      def spork?
        options[:spork]
      end

      def rails2?
        defined?(Rails::Generator::Base) # In Rails3 it's Rails::Generators::Base (plural s)
      end

      def embed_file(source, indent='')
        IO.read(File.join(self.class.source_root, source)).gsub(/^/, indent)
      end

      def embed_template(source, indent='')
        template = File.join(self.class.source_root, source)
        ERB.new(IO.read(template), nil, '-').result(binding).gsub(/^/, indent)
      end

      def version
        IO.read(File.join(self.class.gem_root, 'VERSION')).chomp
      end

      def detect_in_env(choices)
        return nil unless File.file?("features/support/env.rb")

        env = IO.read("features/support/env.rb")

        choices.each do |choice|
          detected = choice[1] if env =~ /#{choice[0]}/n
          return detected if detected
        end

        nil
      end
    end
  end
end