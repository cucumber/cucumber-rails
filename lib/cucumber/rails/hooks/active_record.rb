if defined?(ActiveRecord::Base)
  class ActiveRecord::Base
    mattr_accessor :shared_connection
    @@shared_connection = nil

    def self.connection
      @@shared_connection || retrieve_connection
    end
  end

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