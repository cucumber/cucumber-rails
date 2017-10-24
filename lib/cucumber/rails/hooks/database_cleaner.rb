begin
  require 'database_cleaner'

  Before('not @no-database-cleaner') do
    DatabaseCleaner.start if Cucumber::Rails::Database.autorun_database_cleaner
  end

  After('not @no-database-cleaner') do
    DatabaseCleaner.clean if Cucumber::Rails::Database.autorun_database_cleaner
  end

rescue LoadError => ignore_if_database_cleaner_not_present
end
