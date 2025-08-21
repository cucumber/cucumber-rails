# frozen_string_literal: true

module Cucumber
  module Rails
    module Database
      class TruncationStrategy < Strategy
        def before_js
          super(:truncation)
        end
      end
    end
  end
end
