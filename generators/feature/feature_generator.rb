require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'generators', 'cucumber', 'feature', 'base')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'generators', 'cucumber', 'feature', 'named_arg')

# This generator generates a baic feature.
class FeatureGenerator < Rails::Generator::NamedBase
  RAILS_2 = true
  
  def manifest
    record do |m|
      create_directory(m)
      create_feature_file(m)
      create_steps_file(m)
      create_support_file(m)
    end
  end

  def source_root
    File.join(File.dirname(__FILE__), '..', '..', 'templates', 'feature')
  end

  def named_args
    args.map { |arg| NamedArg.new(arg) }
  end

  protected

  def banner
    "Usage: #{$0} feature ModelName [field:type, field:type]"
  end
end
