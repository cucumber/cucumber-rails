# frozen_string_literal: true

Before('@allow-rescue') do
  @__orig_allow_rescue = ActionController::Base.allow_rescue
  ActionController::Base.allow_rescue = true
end

After('@allow-rescue') do
  ActionController::Base.allow_rescue = @__orig_allow_rescue
end
