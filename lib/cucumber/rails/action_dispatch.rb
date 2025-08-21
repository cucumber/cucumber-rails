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

          show_exceptions = !env['action_dispatch.show_detailed_exceptions']
          if ::Rails.gem_version >= Gem::Version.new('7.1.0')
            # Rails 7.1 deprecated `show_exceptions` boolean in favour of symbols
            show_exceptions = show_exceptions ? :all : :none
          end

          env['action_dispatch.show_exceptions'] = show_exceptions
          super(env)
        end
      end
    end
  end
end

ActionDispatch::ShowExceptions.prepend(Cucumber::Rails::ActionDispatch::ShowExceptions)
