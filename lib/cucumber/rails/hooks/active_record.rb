# frozen_string_literal: true

if defined?(ActiveRecord::Base)
  module ActiveRecord
    class Base
      class_attribute :shared_connection

      def self.connection
        shared_connection || retrieve_connection
      end
    end
  end

  Before('@javascript') do
    Cucumber::Rails::Database.before_js if Cucumber::Rails::Database.autorun_database_cleaner
  end

  Before('not @javascript') do
    Cucumber::Rails::Database.before_non_js if Cucumber::Rails::Database.autorun_database_cleaner
  end

  After do
    Cucumber::Rails::Database.after if Cucumber::Rails::Database.autorun_database_cleaner
  end
end
