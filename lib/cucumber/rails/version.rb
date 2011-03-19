module Cucumber
  module Rails
    VERSION = '0.4.0'
    DEPS = {
      'bundler'           => '>= 1.0.10',
      'cucumber'          => '~> 0.10',
      'rack-test'         => '~> 0.5',
      'nokogiri'          => '~> 1.4.4',
      'rails'             => '~> 3.0',
      'capybara'          => '~> 0.4',
      'webrat'            => '~> 0.7',
      'rspec-rails'       => '~> 2.2',
      'database_cleaner'  => '~> 0.6',
      'sqlite3-ruby'      => '~> 1.3',
      'aruba'             => '~> 0.3',
      'mongoid'           => '>= 1.9',
      'bson_ext'          => '~> 1.2'
    }
  end
end