module Cucumber
  module Rails
    VERSION = '0.4.1'
    DEPS = {
      'aruba'             => '>= 0.3.6',
      'cucumber'          => '>= 0.10.2',

      'bundler'           => '>= 1.0.12',
      'rack-test'         => '>= 0.5.7',
      'nokogiri'          => '>= 1.4.4',
      'rails'             => '>= 3.0.7',
      'capybara'          => '>= 0.4.1',
      'webrat'            => '>= 0.7.3',
      'rspec-rails'       => '>= 2.2.0',
      'database_cleaner'  => '>= 0.6.7',
      'sqlite3-ruby'      => '>= 1.3.3',
      'mongoid'           => '>= 2.0.1',
      'bson_ext'          => '>= 1.3.0',
      'akephalos'         => '>= 0.2.5'
    }
  end
end