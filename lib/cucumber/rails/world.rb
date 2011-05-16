begin
  # Try to load it so we can assign @_result below if needed.
  require 'test/unit/testresult'
rescue LoadError => ignore
end

module Cucumber #:nodoc:
  module Rails #:nodoc:
    class World < ActionController::IntegrationTest #:nodoc:
      include Rack::Test::Methods
      include ActiveSupport::Testing::SetupAndTeardown if ActiveSupport::Testing.const_defined?("SetupAndTeardown")

      def initialize #:nodoc:
        @_result = Test::Unit::TestResult.new if defined?(Test::Unit::TestResult)
      end

      if !defined?(ActiveRecord::Base)
        def self.fixture_table_names; []; end # Workaround for projects that don't use ActiveRecord
      end
    end
  end
end

World do
  Cucumber::Rails::World.new
end
