require 'capybara/rails'
require 'capybara/cucumber'

# If you set this to true, each scenario will run in a database transaction.
# You can still turn off transactions on a per-scenario basis, simply tagging
# a feature or scenario with the @no-txn tag. 
#
# If you set this to false, transactions will be off for all scenarios,
# regardless of whether you use @no-txn or not.
#
# Beware that turning transactions off will leave data in your database after
# each scenario, which can lead to hard-to-debug failures in subsequent
# scenarios. If you do this, we recommend you create a Before block that will
# explicitly put your database in a known state.
#
# Capybara supports drivers which require testing against a separate process
# (webdriver for example), so we disable transactional fixtures here as they
# would prevent the drivers from working. Capybara uses DatabaseCleaner to
# wipe the database before each Scenario instead of using transactions.
Cucumber::Rails::World.use_transactional_fixtures = false
