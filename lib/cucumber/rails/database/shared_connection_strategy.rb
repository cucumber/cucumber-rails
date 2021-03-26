# frozen_string_literal: true

module Cucumber
  module Rails
    module Database
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
    end
  end
end
