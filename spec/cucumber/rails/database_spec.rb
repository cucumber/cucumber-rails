# -*- encoding: utf-8 -*-

require 'spec_helper'
require 'cucumber'

require 'rails'
require 'active_record'
require 'cucumber/rails/database'


describe Cucumber::Rails::Database do

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

  it 'should accept custom JS DB strategies' do
    require 'lib/cucumber/rails/hooks/active_record'

    class ValidStrategy
      def before_js
        # Anything
      end

      def before_non_js
        # Likewise
      end
    end

    Cucumber::Rails::Database.javascript_strategy = ValidStrategy
    # Fun Ruby fact (@frf): foo=(a) will ALWAYS return a (unless you do send(:foo=, a))
    strategy = Cucumber::Rails::Database.instance_variable_get(:@strategy)
    strategy.should_receive(:before_js).once
    QuickCallback.run!('@javascript')

    strategy.should_receive(:before_non_js).once
    QuickCallback.run!('~@javascript')
  end

  it 'should reject invalid JS DB strategies' do
    require 'lib/cucumber/rails/hooks/active_record'

    class InvalidStrategy
    end

    lambda { Cucumber::Rails::Database.javascript_strategy = InvalidStrategy }.should raise_error(ArgumentError)
  end

end
