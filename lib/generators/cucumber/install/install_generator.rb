require File.join(File.dirname(__FILE__), 'install_base')

module Cucumber
  class InstallGenerator < Rails::Generators::Base

    include Cucumber::InstallBase

    DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'], Config::CONFIG['ruby_install_name'])

    argument     :language, :banner => "LANG", :type => :string, :optional => true
    
    class_option :webrat,   :type => :boolean, :desc => "Setup cucumber for use with webrat"
    class_option :capybara, :type => :boolean, :desc => "Setup cucumber for use with capybara"
    class_option :rspec,    :type => :boolean, :desc => "Setup cucumber for use with RSpec"
    class_option :testunit, :type => :boolean, :desc => "Setup cucumber for use with test/unit"
    class_option :spork,    :type => :boolean, :desc => "Setup cucumber for use with Spork"
    
    attr_reader :framework, :driver
    
    def configure_defaults
      @language ||= 'en'
      @framework  = framework_from_options || detect_current_framework || detect_default_framework
      @driver     = driver_from_options    || detect_current_driver    || detect_default_driver
    end

    def generate
      check_upgrade_limitations
      create_templates
      create_scripts
      create_step_definitions
      create_feature_support
      create_tasks
      create_database
    end
    
    def self.gem_root
      File.expand_path("../../../../../", __FILE__)
    end
    
    def self.source_root
      File.join(gem_root, 'templates', 'install')
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
    
  end
end