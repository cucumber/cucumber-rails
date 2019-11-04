# frozen_string_literal: true


require 'cucumber/rails/world'

if defined?(RSpec::Matchers)
  [Cucumber::Rails::World, ActionDispatch::Integration::Session].each do |klass|
    klass.class_eval do
      include RSpec::Matchers
    end
  end
else
  [Cucumber::Rails::World, ActionDispatch::Integration::Session].each do |klass|
    klass.class_eval do
      include Spec::Matchers if defined?(Spec::Matchers)
      include Spec::Rails::Matchers if defined?(Spec::Rails::Matchers)
    end
  end
end
