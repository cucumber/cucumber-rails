# frozen_string_literal: true

ActionController::Base.class_eval do
  cattr_accessor :allow_rescue
end

module Cucumber
  module Rails
    module ActionDispatch
      module ShowExceptions
        def call(env)
          env['action_dispatch.show_detailed_exceptions'] = !ActionController::Base.allow_rescue
          env['action_dispatch.show_exceptions'] = !env['action_dispatch.show_detailed_exceptions']
          super(env)
        end
      end
    end
  end
end

ActionDispatch::ShowExceptions.prepend(Cucumber::Rails::ActionDispatch::ShowExceptions)
