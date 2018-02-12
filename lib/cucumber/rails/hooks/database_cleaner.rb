begin
  require 'database_cleaner'

  Before('~@no-database-cleaner, not @no-database-cleaner') do
    DatabaseCleaner.start if Cucumber::Rails::Database.autorun_database_cleaner
  end

  After('~@no-database-cleaner, not @no-database-cleaner') do
    DatabaseCleaner.start if Cucumber::Rails::Database.autorun_database_cleaner
  end

rescue LoadError => ignore_if_database_cleaner_not_present
end
