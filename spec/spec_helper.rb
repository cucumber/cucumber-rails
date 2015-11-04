require 'rubygems'

require 'rails/all'

module CucumberRails
  class Application < ::Rails::Application
    self.config.secret_key_base = 'ASecretString' if config.respond_to? :secret_key_base
  end
end

require 'ammeter/init'
ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => ':memory:'
)
