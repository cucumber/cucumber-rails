module Cucumber #:nodoc:
  module Rails #:nodoc:
    class World < ActionController::IntegrationTest #:nodoc:
      include ActiveSupport::Testing::SetupAndTeardown if ActiveSupport::Testing.const_defined?("SetupAndTeardown")
      def initialize #:nodoc:
        @_result = Test::Unit::TestResult.new if defined?(Test::Unit::TestResult)
      end
    end
  end
end

World do
  Cucumber::Rails::World.new
end
