module Cucumber
  # This generator generates a baic feature.
  class FeatureGenerator < Rails::Generators::NamedBase

    class NamedArg
      attr_reader :name
      attr_reader :type

      def initialize(s)
        @name, @type = *s.split(':')
      end

      def value(n)
        if @type == 'boolean'
          (n % 2) == 0
        else
          "#{@name} #{n}"
        end
      end
    end

    argument :fields, :optional => true, :type => :array, :banner => "[field:type, field:type]"

    attr_reader :named_args
    
    def parse_fields
      @named_args = @fields.nil? ? [] : @fields.map { |arg| NamedArg.new(arg) }
    end
    
    def create_directory
      empty_directory File.join('features', 'step_definitions')
    end

    def create_feature_file
      template 'feature.erb', File.join('features', "manage_#{plural_name}.feature")
    end
    
    def create_steps_file
      template 'steps.erb', File.join('features', "step_definitions/#{singular_name}_steps.rb")
    end
    
    def create_support_file
      gsub_file File.join('features', 'support', 'paths.rb'), /'\/'/mi do |match|
        "#{match}\n    when /the new #{singular_name} page/\n      new_#{singular_name}_path\n"
      end
    end

    def self.banner
      "#{$0} cucumber:feature ModelName [field:type, field:type]"
    end
    
    def self.source_root
      File.join(File.dirname(__FILE__), 'templates')
    end
    
  end
end