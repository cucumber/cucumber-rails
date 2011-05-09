# Default setup for DatabaseCleaner that will work for most projects.
# If you need your own setup, roll your own.
begin
  require 'database_cleaner'

  Before do
    # TODO: May have to patch DatabaseCleaner's Transaction class to do what we used to do:
    #   run_callbacks :setup if respond_to?(:run_callbacks)
    # IIRC There was a cucumber-rails ticket that added that to support multiple connections...
    # Similar in After (use run_callbacks :teardown if respond_to?(:run_callbacks))
    #
    # May also have to add this to Transaction:
    #  include ActiveSupport::Testing::SetupAndTeardown if ActiveSupport::Testing.const_defined?("SetupAndTeardown")
    DatabaseCleaner.start
  end

  After do
    DatabaseCleaner.clean
  end

rescue LoadError => ignore_if_database_cleaner_not_present
end
