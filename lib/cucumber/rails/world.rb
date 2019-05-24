# frozen_string_literal: true

begin
  # Try to load it so we can assign @_result below if needed.
  require 'test/unit/testresult'
rescue LoadError
  # Test Unit not found
end

module Cucumber
  module Rails
    class World < ActionDispatch::IntegrationTest
      include Rack::Test::Methods
      include ActiveSupport::Testing::SetupAndTeardown if ActiveSupport::Testing.const_defined?('SetupAndTeardown')

      def initialize
        @_result = Test::Unit::TestResult.new if defined?(Test::Unit::TestResult)
      end

      unless defined?(ActiveRecord::Base)
        # Workaround for projects that don't use ActiveRecord
        def self.fixture_table_names
          []
        end
      end
    end
  end
end

World do
  Cucumber::Rails::World.new
end
