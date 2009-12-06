require 'rbconfig'
require 'cucumber/platform'

# This generator bootstraps a Rails project for use with Cucumber
class CucumberGenerator < Rails::Generator::Base
  DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'],
                              Config::CONFIG['ruby_install_name'])

  attr_accessor :driver
  attr_accessor :framework
  attr_reader :language
  
  def initialize(runtime_args, runtime_options = {})
      super
      @language = @args.empty? ? 'en' : @args.first
  end
  
  def manifest
    record do |m|
      m.directory 'features/step_definitions'
      
      m.template "web_steps/#{driver}_steps.rb", 'features/step_definitions/web_steps.rb'
      if language != 'en'
        m.template "web_steps/web_steps_#{language}.rb", "features/step_definitions/web_steps_#{language}.rb"
      end
      m.template 'cucumber_environment.rb', 'config/environments/cucumber.rb',
        :assigns => { :cucumber_version => ::Cucumber::VERSION }

      m.gsub_file 'config/database.yml', /test:.*\n/, "test: &TEST\n"
      unless File.read('config/database.yml').include? 'cucumber:'
        m.gsub_file 'config/database.yml', /\z/, "\ncucumber:\n  <<: *TEST"
      end

      m.directory 'features/support'
      if spork?
        m.template'spork_env.rb', 'features/support/env.rb'
      else
        m.template 'env.rb', 'features/support/env.rb'
        m.template "#{driver}_env.rb", "features/support/#{driver}.rb"
      end
      m.template 'paths.rb', 'features/support/paths.rb'
      m.template 'version_check.rb', 'features/support/version_check.rb'

      m.directory 'lib/tasks'
      m.template'cucumber.rake', 'lib/tasks/cucumber.rake'

      m.file 'cucumber', 'script/cucumber', {
        :chmod => 0755, :shebang => options[:shebang] == DEFAULT_SHEBANG ? nil : options[:shebang]
      }
    end
  end

  def framework
    options[:framework] ||= detect_default_framework!
  end

  def driver
    options[:driver] ||= detect_current_driver! || detect_default_driver!
  end

  def spork?
    options[:spork]
  end

private

  def first_loadable(libraries)
    require 'rubygems'
    libraries.each do |library|
      begin
        require library[0]
        return library[1]
      rescue LoadError => e
        puts e.inspect
      end
    end
    return nil
  end

  def detect_current_driver!
    drivers = [['capybara', :capybara], ['webrat', :webrat ]]
    drivers.each do |driver|
      @current_driver = driver[1] if File.exists?("features/support/#{driver[0]}.rb")
      return @current_driver if @current_driver
    end
    return nil
  end

  def detect_default_driver!
    drivers = [['capybara', :capybara], ['webrat', :webrat ]]
    @default_driver = first_loadable(drivers)
    raise "I don't know which driver you want. Use --capybara or --webrat, or gem install capybara or webrat." unless @default_driver
    @default_driver
  end

  def detect_default_framework!
    @default_framework = first_loadable([['spec', :rspec], ['test/unit', :testunit]])
    raise "I don't know what test framework you want. Use --rspec or --testunit, or gem install rspec or test-unit." unless @default_framework
    @default_framework
  end

  def banner
    "Usage: #{$0} cucumber (language)"
  end

  def after_generate
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

  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on('--webrat', 'Setup cucumber for use with webrat') do |value|
      options[:driver] = :webrat
    end

    opt.on('--capybara', 'Setup cucumber for use with capybara') do |value|
      options[:driver] = :capybara
    end

    opt.on('--rspec', "Setup cucumber for use with RSpec") do |value|
      options[:framework] = :rspec
    end

    opt.on('--testunit', "Setup cucumber for use with test/unit") do |value|
      options[:framework] = :testunit
    end

    opt.on('--spork', 'Setup cucumber for use with Spork') do |value|
      options[:spork] = true
    end
  end

end
