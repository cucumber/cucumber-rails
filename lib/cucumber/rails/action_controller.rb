ActionController::Base.class_eval do
  cattr_accessor :allow_rescue
end

class ActionDispatch::ShowExceptions
  alias __cucumber_orig_call__ call

  def call(env)
    env['action_dispatch.show_exceptions'] = !!ActionController::Base.allow_rescue
    if Rails.version >= "3.2.1"
      env['action_dispatch.show_detailed_exceptions'] = !ActionController::Base.allow_rescue
    end
    __cucumber_orig_call__(env)
  end
end
