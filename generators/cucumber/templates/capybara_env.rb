require 'capybara/rails'
require 'capybara/cucumber'
require 'cucumber/web/tableish'
World(Cucumber::Tableish)

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
Cucumber::Rails::World.use_transactional_fixtures = true

# Capybara defaults to XPATH selectors rather than Webrat's default of CSS. In
# order to ease the transition to Capybara we set the default here. If you'd
# prefer to use XPATH just remove this line and adjust any selectors in your
# steps to use the XPATH syntax.
Capybara.default_selector = :css
