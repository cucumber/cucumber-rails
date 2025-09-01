# frozen_string_literal: true

module Cucumber
  module Rails
    module Database
      class DeletionStrategy < Strategy
        def before_js
          super(:deletion)
        end
      end
    end
  end
end
