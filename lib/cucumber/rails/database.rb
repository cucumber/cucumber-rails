module Cucumber
  module Rails
    module Database

      CUSTOM_STRATEGY_INTERFACE = %w{ before_js before_non_js }

      class InvalidStrategy < ArgumentError;end

      class << self

        attr_accessor :autorun_database_cleaner

        def javascript_strategy=(args)
          strategy, *strategy_opts = args
          strategy_type =
            case strategy
            when Symbol
              map[strategy] || raise(InvalidStrategy, "The strategy '#{strategy}' is not understood. Please use one of #{map.keys.join(',')}")
            when Class
              strategy
            end

          @strategy =  strategy_type.new(*strategy_opts)

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
            :truncation => TruncationStrategy,
            :shared_connection => SharedConnectionStrategy,
            :transaction => SharedConnectionStrategy,
            :deletion => DeletionStrategy
          }
        end

        def validate_interface!
          unless CUSTOM_STRATEGY_INTERFACE.all? {|m| @strategy.respond_to?(m) }
            raise(ArgumentError, "Strategy must respond to all of: #{CUSTOM_STRATEGY_INTERFACE.map{|method| "##{method}" } * '  '} !")
          end
        end

      end

      class Strategy
        def initialize(options={})
          @options=options
        end

        def before_js(strategy)
          @original_strategy = DatabaseCleaner.connections.first.strategy # that feels like a nasty hack
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
