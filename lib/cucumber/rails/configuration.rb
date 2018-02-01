module Cucumber
  module Rails
    class Configuration
      attr_writer :use_rack_test_helpers

      def use_rack_test_helpers
        return @use_rack_test_helpers if defined? @use_rack_test_helpers
        true
      end
    end
    private_constant :Configuration

    # Sets the specified configuration options, if a block is provided
    # @return [Configuration] the current configuration object.
    def self.config
      yield self.configuration if block_given?
      self.configuration
    end

    private

    def self.configuration
      @config ||= Configuration.new
    end
  end
end
