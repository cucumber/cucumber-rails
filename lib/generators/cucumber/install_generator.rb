module Cucumber
  class InstallGenerator < Rails::Generators::Base

    DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'],
                                Config::CONFIG['ruby_install_name'])

    argument :language, :banner => "LANG", :type => :string, :optional => true
    
    class_option :webrat,   :type => :boolean, :desc => "Setup cucumber for use with webrat"
    class_option :capybara, :type => :boolean, :desc => "Setup cucumber for use with capybara"
    class_option :rspec,    :type => :boolean, :desc => "Setup cucumber for use with RSpec"
    class_option :testunit, :type => :boolean, :desc => "Setup cucumber for use with test/unit"
    class_option :spork,    :type => :boolean, :desc => "Setup cucumber for use with Spork"
    
    attr_reader :framework, :driver
    
    def self.source_root
      File.join(File.dirname(__FILE__), 'templates')
    end
    
    def configure_defaults
      @language ||= 'en'
      @framework  = framework_from_options || detect_current_framework || detect_default_framework
      @driver     = driver_from_options    || detect_current_driver    || detect_default_driver
      
      puts @framework
      puts @driver
    end
    
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
    
    def create_templates
      template File.join('config', 'cucumber.yml.erb'),       File.join('config', 'cucumber.yml')
      template File.join('environments', 'cucumber.rb.erb'),  File.join('config', 'environments', 'cucumber.rb')
    end
    
    def create_scripts
      copy_file File.join('script', 'cucumber'), File.join('script', 'cucumber')
      chmod File.join('script', 'cucumber'), 0755
    end
    
    def create_step_definitions
      empty_directory File.join('features', 'step_definitions')
      template File.join('step_definitions', "#{@driver}_steps.rb.erb"), File.join('features', 'step_definitions', 'web_steps.rb')
      if language != 'en'
        template File.join('step_definitions', "web_steps_#{@language}.rb.erb"), File.join('features', 'step_definitions', "web_steps_#{language}.rb")
      end
    end
    
    def create_feature_support
      empty_directory File.join('features', 'support')
      if spork?
        template File.join('support', 'rails_spork.rb.erb'), File.join('features', 'support', 'env.rb')
      else
        template File.join('support', 'rails.rb.erb'),       File.join('features', 'support', 'env.rb')
      end
      copy_file  File.join('support', 'paths.rb'),           File.join('features', 'support', 'paths.rb')
    end
    
    def create_tasks
      empty_directory File.join('lib', 'tasks')
      template  File.join('tasks', 'cucumber.rake.erb'),     File.join('lib', 'tasks', 'cucumber.rake')
    end
    
    def create_database
      gsub_file File.join('config', 'database.yml'), /test:.*\n/, "test: &TEST\n"
      unless File.read(File.join('config', 'database.yml')).include? 'cucumber:'
        gsub_file File.join('config', 'database.yml'), /\z/, "\ncucumber:\n  <<: *TEST"
      end
    end
    
    def print_instructions
      require 'cucumber/formatter/ansicolor'
      extend Cucumber::Formatter::ANSIColor

      if @default_driver
        puts <<-WARNING

  #{yellow_cukes(15)} 

                #{yellow_cukes(1)}   D R I V E R   A L E R T    #{yellow_cukes(1)}

  You didn't explicitly generate with --capybara or --webrat, so I looked at
  your gems and saw that you had #{green(@default_driver.to_s)} installed, so I went with that. 
  If you want something else, be specific about it. Otherwise, relax.

  #{yellow_cukes(15)} 

  WARNING
      end

      if @default_framework
        puts <<-WARNING

  #{yellow_cukes(15)} 

            #{yellow_cukes(1)}   T E S T   F R A M E W O R K   A L E R T    #{yellow_cukes(1)}

  You didn't explicitly generate with --rspec or --testunit, so I looked at
  your gems and saw that you had #{green(@default_framework.to_s)} installed, so I went with that. 
  If you want something else, be specific about it. Otherwise, relax.

  #{yellow_cukes(15)} 

  WARNING
      end
    end
    
    private

    def framework_from_options
      return :rspec if options[:rspec]
      return :testunit if options[:testunit]
      return nil
    end
    
    def driver_from_options
      return :webrat if options[:webrat]
      return :capybara if options[:capybara]
      return nil
    end

    def detect_current_driver
      detect_in_env([['capybara', :capybara], ['webrat', :webrat ]])
    end

    def detect_default_driver
      @default_driver = first_loadable([['capybara', :capybara], ['webrat', :webrat ]])
      raise "I don't know which driver you want. Use --capybara or --webrat, or gem install capybara or webrat." unless @default_driver
      @default_driver
    end

    def detect_current_framework
      detect_in_env([['spec', :rspec], ['test/unit', :testunit]])
    end

    def detect_default_framework
      @default_framework = first_loadable([['spec', :rspec], ['test/unit', :testunit]])
      raise "I don't know what test framework you want. Use --rspec or --testunit, or gem install rspec or test-unit." unless @default_framework
      @default_framework
    end
    
    def spork?
      options[:spork]
    end

    def embed_file(source, indent='')
      IO.read(File.join(File.dirname(__FILE__), 'templates', source)).gsub(/^/, indent)
    end

    def embed_template(source, indent='')
      template = File.join(File.dirname(__FILE__), 'templates', source)
      ERB.new(IO.read(template), nil, '-').result(binding).gsub(/^/, indent)
    end

    def version
      IO.read(File.dirname(__FILE__) + '/../../../VERSION').chomp
    end

    def first_loadable(libraries)
      require 'rubygems'
      libraries.each do |library|
        begin
          require library[0]
          return library[1]
        rescue LoadError => ignore
        end
      end
      return nil
    end

    def detect_in_env(choices)
      env = File.file?("features/support/env.rb") ? IO.read("features/support/env.rb") : ''
      choices.each do |choice|
        detected = choice[1] if env =~ /#{choice[0]}/n
        return detected if detected
      end
      return nil
    end

  end
end