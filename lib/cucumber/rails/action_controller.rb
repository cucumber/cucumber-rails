# frozen_string_literal: true

ActionController::Base.class_eval do
  cattr_accessor :allow_rescue
end

module ActionDispatch
  class ShowExceptions
    alias __cucumber_orig_call__ call

    def call(env)
      env['action_dispatch.show_exceptions'] = !!ActionController::Base.allow_rescue
      env['action_dispatch.show_detailed_exceptions'] = !ActionController::Base.allow_rescue
      __cucumber_orig_call__(env)
    end
  end
end
