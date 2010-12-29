require File.expand_path(File.join(File.dirname(__FILE__), '../../lib/generators/cucumber/install/install_base'))

# This generator bootstraps a Rails project for use with Cucumber
class CucumberGenerator < Rails::Generator::Base
  include Cucumber::Generators::InstallBase

  attr_reader :language, :template_dir

  def initialize(runtime_args, runtime_options = {})
    super
    @language = @args.empty? ? 'en' : @args.first
  end

  def manifest
    record do |m|
      install_cucumber_rails(m)
    end
  end

  def self.gem_root
    File.expand_path('../../../', __FILE__)
  end

  def self.source_root
    File.join(gem_root, 'templates', 'install')
  end

  def source_root
    self.class.source_root
  end

  private

  def banner
    "Usage: #{$0} cucumber (language)"
  end

  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on('--spork', 'Use Spork to run features') do
      options[:spork] = true
    end
  end

end
