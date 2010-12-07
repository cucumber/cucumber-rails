if Rails.version.to_f >= 3.0
  require 'cucumber/rails/v3/action_controller'
else
  require 'cucumber/rails/v2/action_controller'
end

Before('@allow-rescue') do
  @__orig_allow_rescue = ActionController::Base.allow_rescue
  ActionController::Base.allow_rescue = true
end

After('@allow-rescue') do
  ActionController::Base.allow_rescue = @__orig_allow_rescue
end
