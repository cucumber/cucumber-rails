Before do
  Rails.application.env_config["action_dispatch.show_exceptions"] = !!ActionController::Base.allow_rescue
end

Before('@allow-rescue') do
  Rails.application.env_config["action_dispatch.show_exceptions"] = true
end
