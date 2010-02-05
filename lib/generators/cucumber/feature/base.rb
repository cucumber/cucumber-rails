module Generators
  module Cucumber
    module Feature
      module Base

        def create_directory(m = self)
          if defined?(RAILS_2)
            m.directory 'features/step_definitions'
          else
            m.empty_directory File.join('features', 'step_definitions')
          end
        end

        def create_feature_file(m = self)
          m.template 'feature.erb', File.join('features', "manage_#{plural_name}.feature")
        end

        def create_steps_file(m = self)
          m.template 'steps.erb', File.join('features', "step_definitions/#{singular_name}_steps.rb")
        end

        def create_support_file(m = self)
          m.gsub_file File.join('features', 'support', 'paths.rb'), /'\/'/mi do |match|
            "#{match}\n    when /the new #{singular_name} page/\n      new_#{singular_name}_path\n"
          end
        end
        
      end
    end
  end
end