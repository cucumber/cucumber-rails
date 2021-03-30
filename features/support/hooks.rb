# frozen_string_literal: true

After do |scenario|
  if scenario.failed?
    log last_command_stopped.stdout
    log last_command_stopped.stderr
  end
end
