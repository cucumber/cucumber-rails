# frozen_string_literal: true

begin
  require 'database_cleaner'

  Before('not @no-database-cleaner') do
    DatabaseCleaner.start if Cucumber::Rails::Database.autorun_database_cleaner
  end

  After('not @no-database-cleaner') do
    DatabaseCleaner.clean if Cucumber::Rails::Database.autorun_database_cleaner
  end
rescue LoadError
  Cucumber.logger.debug('database_cleaner gem not present.')
end
