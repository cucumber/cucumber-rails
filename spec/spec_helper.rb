require 'rspec/rails/fixture_support'
require 'rails/all'

module CucumberRails
  class Application < ::Rails::Application
    self.config.secret_key_base = 'ASecretString' if config.respond_to? :secret_key_base
  end
end

require 'rspec/support/spec'
require 'rspec/rails'
require 'ammeter/init'
