if defined?(ActiveRecord::Base)
  require 'cucumber/rails3/active_record'

  Before('@javascript') do
    # Forces all threads to share the same connection. This works on
    # Capybara because it starts the web server in a thread.
    ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
  end

  Before('~@javascript') do
    # Do not use a shared connection unless we're in a @javascript scenario
    ActiveRecord::Base.shared_connection = nil
  end
end