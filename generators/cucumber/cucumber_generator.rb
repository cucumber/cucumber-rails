require 'rbconfig'
require 'cucumber/platform'

# This generator bootstraps a Rails project for use with Cucumber
class CucumberGenerator < Rails::Generator::Base
  DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'],
                              Config::CONFIG['ruby_install_name'])

  attr_accessor :driver
  attr_accessor :framework
  attr_reader :language, :template_dir
  
  def initialize(runtime_args, runtime_options = {})
    super
    @language = @args.empty? ? 'en' : @args.first
  end
  
  def manifest
    record do |m|
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

      m.template 'config/cucumber.yml.erb', 'config/cucumber.yml'

      m.template 'environments/cucumber.rb.erb', 'config/environments/cucumber.rb'

      m.file 'script/cucumber', 'script/cucumber', {
        :chmod => 0755, :shebang => options[:shebang] == DEFAULT_SHEBANG ? nil : options[:shebang]
      }

      m.directory 'features/step_definitions'
      m.template "step_definitions/#{driver}_steps.rb.erb", 'features/step_definitions/web_steps.rb'
      if language != 'en'
        m.template "step_definitions/web_steps_#{language}.rb.erb", "features/step_definitions/web_steps_#{language}.rb"
      end

      m.directory 'features/support'
      if spork?
        m.template 'support/rails_spork.rb.erb', 'features/support/env.rb'
      else
        m.template 'support/rails.rb.erb',       'features/support/env.rb'
      end
      m.file       'support/paths.rb',           'features/support/paths.rb'

      m.directory 'lib/tasks'
      m.template  'tasks/cucumber.rake.erb',     'lib/tasks/cucumber.rake'

      m.gsub_file 'config/database.yml', /test:.*\n/, "test: &TEST\n"
      unless File.read('config/database.yml').include? 'cucumber:'
        m.gsub_file 'config/database.yml', /\z/, "\ncucumber:\n  <<: *TEST"
      end
    end
  end

  def framework
    options[:framework] ||= detect_current_framework || detect_default_framework
  end

  def driver
    options[:driver] ||= detect_current_driver || detect_default_driver
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
    IO.read(File.dirname(__FILE__) + '/../../VERSION').chomp
  end

private

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

  def detect_in_env(choices)
    env = File.file?("features/support/env.rb") ? IO.read("features/support/env.rb") : ''
    choices.each do |choice|
      detected = choice[1] if env =~ /#{choice[0]}/n
      return detected if detected
    end
    return nil
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
