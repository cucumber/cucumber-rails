if defined?(ActiveRecord::Base)
  class ActiveRecord::Base
    class_attribute :shared_connection

    def self.connection
      self.shared_connection || retrieve_connection
    end
  end

  Before('@javascript') do
    Cucumber::Rails::Database.before_js if Cucumber::Rails::Database.autorun_database_cleaner
  end

  Before('~@javascript') do
    Cucumber::Rails::Database.before_non_js if Cucumber::Rails::Database.autorun_database_cleaner
  end

  After do
    Cucumber::Rails::Database.after if Cucumber::Rails::Database.autorun_database_cleaner
  end
end
