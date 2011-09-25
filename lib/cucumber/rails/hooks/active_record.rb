if defined?(ActiveRecord::Base)
  class ActiveRecord::Base
    class_attribute :shared_connection

    def self.connection
      self.shared_connection || retrieve_connection
    end
  end
  
  Before('@javascript') do
    # Forces all threads to share a connection on a per-model basis,
    # as connections may vary per model as per establish_connection. This works
    # on Capybara because it starts the web server in a thread.
    ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
    ActiveRecord::Base.descendants.each do |model|
      model.shared_connection = model.connection
    end
  end

  Before('~@javascript') do
    # Do not use a shared connection unless we're in a @javascript scenario
    ActiveRecord::Base.shared_connection = nil
    ActiveRecord::Base.descendants.each do |model|
      model.shared_connection = nil
    end
  end
end