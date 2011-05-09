require 'rbconfig'
require File.join(File.dirname(__FILE__), 'install_base')

module Cucumber
  class InstallGenerator < ::Rails::Generators::Base
    include Cucumber::Generators::InstallBase

    argument     :language,      :type => :string,  :banner => "LANG", :optional => true

    class_option :rspec,         :type => :boolean, :desc => "Use RSpec"
    class_option :testunit,      :type => :boolean, :desc => "Use Test::Unit"
    class_option :spork,         :type => :boolean, :desc => "Use Spork"
    class_option :skip_database, :type => :boolean, :desc => "Skip modification of database.yml", :aliases => '-D', :default => false

    attr_reader :framework

    def configure_defaults
      @language ||= 'en'
      @framework  = framework_from_options || detect_current_framework || detect_default_framework
    end

    def generate
      install_cucumber_rails(self)
    end
  
    def self.gem_root
      File.expand_path("../../../../../", __FILE__)
    end
  
    def self.source_root
      File.join(gem_root, 'templates/install')
    end

    private

    def framework_from_options
      return 'rspec-rails' if options[:rspec]
      return 'testunit' if options[:testunit]
      return 'rspec-rails'
    end

  end
end