begin
  require 'database_cleaner'

  Before do
    DatabaseCleaner.start
  end

  After do
    DatabaseCleaner.clean
  end

rescue LoadError => ignore_if_database_cleaner_not_present
end
