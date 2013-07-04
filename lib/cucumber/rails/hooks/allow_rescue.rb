Before do
  Rails.application.env_config.merge!(
    "action_dispatch.show_exceptions" => !!ActionController::Base.allow_rescue,
    "action_dispatch.show_detailed_exceptions" => true
  )
end

Before('@allow-rescue') do
  Rails.application.env_config.merge!(
    "action_dispatch.show_exceptions" => true,
    "action_dispatch.show_detailed_exceptions" => false
  )
end
