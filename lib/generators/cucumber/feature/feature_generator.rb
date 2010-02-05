require File.join(File.dirname(__FILE__), 'base')
require File.join(File.dirname(__FILE__), 'named_arg')

module Cucumber
  # This generator generates a baic feature.
  class FeatureGenerator < Rails::Generators::NamedBase

    argument :fields, :optional => true, :type => :array, :banner => "[field:type, field:type]"

    attr_reader :named_args
    
    def parse_fields
      @named_args = @fields.nil? ? [] : @fields.map { |arg| NamedArg.new(arg) }
    end    

    include Generators::Cucumber::Feature::Base
    
    def self.banner
      "#{$0} cucumber:feature ModelName [field:type, field:type]"
    end
    
    def self.source_root
      File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'templates', 'feature')
    end
    
  end
end