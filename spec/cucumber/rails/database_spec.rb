# frozen_string_literal: true

require 'cucumber/rails/database/strategy'
require 'cucumber/rails/database/deletion_strategy'
require 'cucumber/rails/database/shared_connection_strategy'
require 'cucumber/rails/database/truncation_strategy'
require 'cucumber/rails/database'

describe Cucumber::Rails::Database do
  before { allow(strategy_type).to receive(:new).and_return(strategy) }

  let(:strategy) { instance_double(strategy_type, before_js: nil, before_non_js: nil) }
  let(:strategy_type) { Cucumber::Rails::Database::TruncationStrategy }

  context 'when using a valid pre-determined strategy' do
    before { described_class.javascript_strategy = :truncation }

    it 'forwards a `before_non_js` event to the selected strategy' do
      expect(strategy).to receive(:before_non_js)

      described_class.before_non_js
    end

    it 'forwards a `before_js` event to the selected strategy' do
      expect(strategy).to receive(:before_js)

      described_class.before_js
    end
  end

  context 'when using an invalid pre-determined strategy' do
    it 'raises an error if you use a non-understood strategy' do
      expect { described_class.javascript_strategy = :invalid }
        .to raise_error(Cucumber::Rails::Database::InvalidStrategy)
    end
  end

  context 'when using a valid custom strategy' do
    before { described_class.javascript_strategy = strategy_type }

    let(:strategy_type) do
      Class.new do
        def before_js
          # Anything
        end

        def before_non_js
          # Likewise
        end
      end
    end

    it 'forwards a `before_non_js` event to the strategy' do
      expect(strategy).to receive(:before_non_js)

      described_class.before_non_js
    end

    it 'forwards a `before_js` event to the strategy' do
      expect(strategy).to receive(:before_js)

      described_class.before_js
    end
  end

  context 'when using an invalid custom strategy' do
    let(:invalid_strategy) { Class.new }

    it 'raises an error if the strategy does not have a valid interface' do
      expect { described_class.javascript_strategy = invalid_strategy }
        .to raise_error(ArgumentError)
    end
  end
end
