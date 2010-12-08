begin
  require 'database_cleaner'

  Before do
    $__cucumber_global_use_txn = !!Cucumber::Rails::World.use_transactional_fixtures if $__cucumber_global_use_txn.nil?
  end

  Before('~@no-txn', '~@selenium', '~@culerity', '~@celerity', '~@javascript') do
    Cucumber::Rails::World.use_transactional_fixtures = $__cucumber_global_use_txn
  end

  Before('@no-txn,@selenium,@culerity,@celerity,@javascript') do
    Cucumber::Rails::World.use_transactional_fixtures = false
  end

  Before do
    DatabaseCleaner.start
  end

  After do
    DatabaseCleaner.clean
  end

rescue LoadError => ignore_if_database_cleaner_not_present
end
