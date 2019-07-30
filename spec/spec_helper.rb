# frozen_string_literal: true

require 'rspec/rails/fixture_support'
require 'rails/all'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

module CucumberRails
  class Application < ::Rails::Application
    config.secret_key_base = 'ASecretString'
  end
end

require 'rspec/support/spec'
require 'rspec/rails'
require 'ammeter/init'
