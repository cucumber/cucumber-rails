# frozen_string_literal: true

begin
  # Try to load it so we can assign @_result below if needed.
  require 'test/unit/testresult'
rescue LoadError
  Cucumber.logger.debug('Minitest not found.')
end

module Cucumber
  module Rails
    class << self
      def include_rack_test_helpers?
        # Using ActiveModel Boolean casting here will give false positives more often than not!
        !ENV.fetch('CR_REMOVE_RACK_TEST_HELPERS', '').casecmp('true').zero?
      end
    end
  end
end

module Cucumber
  module Rails
    class World < ::ActionDispatch::IntegrationTest
      include Rack::Test::Methods if Cucumber::Rails.include_rack_test_helpers?
      include ActiveSupport::Testing::SetupAndTeardown if ActiveSupport::Testing.const_defined?(:SetupAndTeardown)

      def initialize
        super('MiniTest run-name if needed')
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
