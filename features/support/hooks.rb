# frozen_string_literal: true

After do |scenario|
  if scenario.failed?
    puts last_command_stopped.stdout
    puts last_command_stopped.stderr
  end
end
