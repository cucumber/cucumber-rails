require 'cucumber/rails/world'

begin
  require 'rspec/expectations'
  require 'rspec/rails'

  [Cucumber::Rails::World, ActionController::Integration::Session].each do |klass|
    klass.class_eval do
      include Rspec::Matchers
      include Rspec::Rails::Matchers
    end
  end
rescue LoadError => try_rspec_1
  require 'spec/expectations'
  require 'spec/rails'

  [Cucumber::Rails::World, ActionController::Integration::Session].each do |klass|
    klass.class_eval do
      include Spec::Matchers
      include Spec::Rails::Matchers
    end
  end
end