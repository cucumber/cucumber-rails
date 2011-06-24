begin
  require 'database_cleaner'

  Before('~@no-database-cleaner') do
    DatabaseCleaner.start
  end

  After('~@no-database-cleaner') do
    DatabaseCleaner.clean
  end

rescue LoadError => ignore_if_database_cleaner_not_present
end
