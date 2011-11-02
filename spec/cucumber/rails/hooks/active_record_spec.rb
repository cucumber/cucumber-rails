# -*- encoding: utf-8 -*-

require 'spec_helper'
require 'cucumber'

require 'rails'
require 'active_record'

describe ActiveRecord::Base do

  class QuickCallback
    @@callbacks = Hash.new {|h,k| h[k] = []}
    def self.add_callback(name, block)
      @@callbacks[name] << block
    end

    def self.run!(name)
      @@callbacks[name].map(&:call)
    end
  end

  class Object
    def Before(name, &block)
      QuickCallback.add_callback(name, block)
    end
  end

  module Cucumber
    module Rails
      class World
        cattr_accessor :use_transactional_fixtures
      end
    end
  end
  require 'lib/cucumber/rails/hooks/active_record'

  def mock_active_record_retrieve_connection(times=1)
    ActiveRecord::Base.should_receive(:retrieve_connection).exactly(times).times.and_return(true)
  end

  it 'should set a shared_connection when use_transactional_fixtures is false' do
    mock_active_record_retrieve_connection(3)
    Cucumber::Rails::World.use_transactional_fixtures = false
    QuickCallback.run!('@javascript')
    3.times { ActiveRecord::Base.connection }
  end

  it 'should NOT set a shared_connection when use_transactional_fixtures is true' do
    mock_active_record_retrieve_connection
    Cucumber::Rails::World.use_transactional_fixtures = true
    QuickCallback.run!('@javascript')
    3.times { ActiveRecord::Base.connection }
  end
end
