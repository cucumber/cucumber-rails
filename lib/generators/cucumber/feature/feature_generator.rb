require File.join(File.dirname(__FILE__), 'named_arg')

module Cucumber
  class FeatureGenerator < ::Rails::Generators::NamedBase
    source_root File.expand_path("../templates", __FILE__)

    argument :fields, :optional => true, :type => :array, :banner => "[field:type, field:type]"

    attr_reader :named_args
  
    def parse_fields
      @named_args = @fields.nil? ? [] : @fields.map { |arg| NamedArg.new(arg) }
    end    

    def generate
      template 'feature.erb', "features/manage_#{plural_name}.feature"
      template 'steps.erb', "features/step_definitions/#{singular_name}_steps.rb"
      gsub_file 'features/support/paths.rb', /'\/'/mi do |match|
        "#{match}\n    when /the new #{singular_name} page/\n      new_#{singular_name}_path\n"
      end
    end
  
    def self.banner
      "#{$0} cucumber:feature ModelName [field:type, field:type]"
    end
  end
end
