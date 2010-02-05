require File.join(File.dirname(__FILE__), 'steps')
require File.join(File.dirname(__FILE__), 'template_methods')

module Cucumber
  class InstallGenerator < Rails::Generators::Base

    GEM_ROOT        = File.join(File.dirname(__FILE__), '..', '..', '..', '..')
    DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'], Config::CONFIG['ruby_install_name'])

    argument     :language, :banner => "LANG", :type => :string, :optional => true
    
    class_option :webrat,   :type => :boolean, :desc => "Setup cucumber for use with webrat"
    class_option :capybara, :type => :boolean, :desc => "Setup cucumber for use with capybara"
    class_option :rspec,    :type => :boolean, :desc => "Setup cucumber for use with RSpec"
    class_option :testunit, :type => :boolean, :desc => "Setup cucumber for use with test/unit"
    class_option :spork,    :type => :boolean, :desc => "Setup cucumber for use with Spork"
    
    attr_reader :framework, :driver
    
    def self.gem_root
      GEM_ROOT
    end
    
    def self.source_root
      File.join(gem_root, 'templates', 'install')
    end
    
    def configure_defaults
      @language ||= 'en'
      @framework  = framework_from_options || detect_current_framework || detect_default_framework
      @driver     = driver_from_options    || detect_current_driver    || detect_default_driver
    end
    
    include Generators::Cucumber::Install::Base

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