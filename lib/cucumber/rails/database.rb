module Cucumber
  module Rails
    module Database
      class << self
        def javascript_strategy=(strategy)
          strategy_type = map[strategy] || raise("The strategy '#{strategy}' is not understood. Please use one of #{map.keys.join(',')}")
          @strategy = strategy_type.new
        end
        
        def before_js
          @strategy.before_js
        end
        
        def before_non_js
          @strategy.before_non_js
        end
      private
      
        def map
          { 
            :truncation => TruncationStrategy,
            :shared_connection => SharedConnectionStrategy,
            :transaction => SharedConnectionStrategy
          }
        end
      end
      
      class SharedConnectionStrategy
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
      
      class TruncationStrategy
        def before_js
          @original_strategy = DatabaseCleaner.strategy
          DatabaseCleaner.strategy = :truncation
        end
        
        def before_non_js
          DatabaseCleaner.strategy = @original_strategy
        end
      end
      
      self.javascript_strategy = :transaction
    end
  end
end