if defined?(ActiveRecord::Base)
  class ActiveRecord::Base
    class_attribute :shared_connection

    def self.connection
      self.shared_connection || retrieve_connection
    end
  end

  Before('@javascript') do
    Cucumber::Rails::Database.before_js
  end

  Before('~@javascript') do
    Cucumber::Rails::Database.before_non_js
  end

  After do
    Cucumber::Rails::Database.after
  end
end
