# frozen_string_literal: true

module Cucumber
  module Rails
    module Database
      class Strategy
        def initialize(options = {})
          @options = options
        end

        def before_js(strategy)
          @original_strategy = if defined?(DatabaseCleaner) && Gem::Version.new(DatabaseCleaner::VERSION) >= Gem::Version.new('1.8.0')
                                 raise "No DatabaseCleaner strategies found. Make sure you have required one of DatabaseCleaner's adapters" if DatabaseCleaner.cleaners.empty?

                                 DatabaseCleaner.cleaners.values.first.strategy # that feels like a nasty hack
                               else
                                 DatabaseCleaner.connections.first.strategy # that feels like a nasty hack
                               end
          DatabaseCleaner.strategy = strategy, @options
        end

        def before_non_js
          # no-op
        end

        def after
          return unless @original_strategy

          DatabaseCleaner.strategy = @original_strategy
          @original_strategy = nil
        end
      end
    end
  end
end
