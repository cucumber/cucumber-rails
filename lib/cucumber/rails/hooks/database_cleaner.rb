# frozen_string_literal: true

begin
  require 'database_cleaner/core'
rescue LoadError
  begin
    require 'database_cleaner'
  rescue LoadError
    Cucumber.logger.debug('neither database_cleaner v1 or v2 present')
  end
end

if defined?(DatabaseCleaner)
  Before('not @no-database-cleaner') do
    DatabaseCleaner.start if Cucumber::Rails::Database.autorun_database_cleaner
  end

  After('not @no-database-cleaner') do
    DatabaseCleaner.clean if Cucumber::Rails::Database.autorun_database_cleaner
  end
end
