# frozen_string_literal: true

module Cucumber
  module Rails
    module Database
      CUSTOM_STRATEGY_INTERFACE = %w[before_js before_non_js].freeze

      class InvalidStrategy < ArgumentError; end

      class << self
        attr_accessor :autorun_database_cleaner

        def javascript_strategy=(args)
          strategy, *strategy_opts = args
          strategy_type =
            case strategy
            when Symbol
              map[strategy] || throw_invalid_strategy_error(strategy)
            when Class
              strategy
            end

          @strategy = strategy_type.new(*strategy_opts)

          validate_interface!
        end

        def before_js
          @strategy.before_js
        end

        def before_non_js
          @strategy.before_non_js
        end

        def after
          @strategy.after
        end

        private

        def map
          {
            truncation: TruncationStrategy,
            shared_connection: SharedConnectionStrategy,
            transaction: SharedConnectionStrategy,
            deletion: DeletionStrategy
          }
        end

        def throw_invalid_strategy_error(strategy)
          raise(InvalidStrategy, "The strategy '#{strategy}' is not understood. Please use one of #{mapped_keys}")
        end

        def mapped_keys
          map.keys.join(', ')
        end

        def validate_interface!
          return if CUSTOM_STRATEGY_INTERFACE.all? { |m| @strategy.respond_to?(m) }

          throw_invalid_strategy_interface_error
        end

        def throw_invalid_strategy_interface_error
          raise(
            ArgumentError,
            "Strategy must respond to all of: #{CUSTOM_STRATEGY_INTERFACE.map { |method| "##{method}" } * '  '} !"
          )
        end
      end

      class Strategy
        def initialize(options = {})
          @options = options
        end

        def before_js(strategy)
          @original_strategy = if Gem::Version.new(DatabaseCleaner::VERSION) >= Gem::Version.new('1.8.0.beta')
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

      class TruncationStrategy < Strategy
        def before_js
          super :truncation
        end
      end

      class DeletionStrategy < Strategy
        def before_js
          super :deletion
        end
      end

      class SharedConnectionStrategy < Strategy
        def before_js
          # Forces all threads to share a connection on a per-model basis,
          # as connections may vary per model as per establish_connection. This works
          # on Capybara because it starts the web server in a thread.
          ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
          ActiveRecord::Base.descendants.each do |model|
            model.shared_connection = model.connection
          end
        end

        def before_non_js
          # Do not use a shared connection unless we're in a @javascript scenario
          ActiveRecord::Base.shared_connection = nil
          ActiveRecord::Base.descendants.each do |model|
            model.shared_connection = nil
          end
        end
      end

      Database.javascript_strategy = :truncation
      Database.autorun_database_cleaner = true
    end
  end
end
