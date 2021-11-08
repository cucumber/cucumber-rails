# frozen_string_literal: true

module Cucumber
  module Rails
    module Database
      class NullStrategy
        def before_js; end

        def before_non_js; end

        def after; end
      end
    end
  end
end
