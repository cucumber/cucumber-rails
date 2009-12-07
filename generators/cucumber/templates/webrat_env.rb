require 'cucumber/webrat/element_locator' # Deprecated - remove this line if you don't use #element_at or #table_at
require 'cucumber/web/tableish'
World(Cucumber::Tableish)
require 'webrat'
require 'webrat/core/matchers'
Webrat.configure do |config|
  config.mode = :rails
  config.open_error_files = false # Set to true if you want error pages to pop up in the browser
end

# If you set this to true, each scenario will run in a database transaction.
# You can still turn off transactions on a per-scenario basis, simply tagging 
# a feature or scenario with the @no-txn tag. 
#
# If you set this to false, transactions will be off for all scenarios,
# regardless of whether you use @no-txn or not.
#
# Beware that turning transactions off will leave data in your database 
# after each scenario, which can lead to hard-to-debug failures in 
# subsequent scenarios. If you do this, we recommend you create a Before
# block that will explicitly put your database in a known state.
Cucumber::Rails::World.use_transactional_fixtures = true
