# frozen_string_literal: true

require_relative 'database/strategy'
require_relative 'database/deletion_strategy'
require_relative 'database/null_strategy'
require_relative 'database/shared_connection_strategy'
require_relative 'database/truncation_strategy'

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

        def default_strategy!
          self.javascript_strategy = :truncation
          self.autorun_database_cleaner = true
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
            deletion: DeletionStrategy,
            none: NullStrategy
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

      default_strategy!
    end
  end
end
