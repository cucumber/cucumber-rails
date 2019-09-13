# frozen_string_literal: true

require 'cucumber/rails/database'

describe Cucumber::Rails::Database do
  before { allow(strategy_type).to receive(:new).and_return(strategy) }

  let(:strategy) { instance_double(strategy_type, before_js: nil, before_non_js: nil) }
  let(:strategy_type) { Cucumber::Rails::Database::TruncationStrategy }

  it 'forwards events to the selected strategy' do
    described_class.javascript_strategy = :truncation

    expect(strategy).to receive(:before_non_js)
    described_class.before_non_js

    expect(strategy).to receive(:before_js)
    described_class.before_js
  end

  it 'raises an error if you use a non-understood strategy' do
    expect { described_class.javascript_strategy = :invalid }
      .to raise_error(Cucumber::Rails::Database::InvalidStrategy)
  end

  context 'when using a custom strategy' do
    let(:strategy_type) { valid_strategy }

    let(:valid_strategy) do
      Class.new do
        def before_js
          # Anything
        end

        def before_non_js
          # Likewise
        end
      end
    end

    let(:invalid_strategy) do
      Class.new
    end

    it 'raises an error if the strategy does not have a valid interface' do
      expect { described_class.javascript_strategy = invalid_strategy }
        .to raise_error(ArgumentError)
    end

    it 'accepts the strategy if it has a valid interface' do
      expect { described_class.javascript_strategy = valid_strategy }
        .not_to raise_error
    end

    it 'forwards events to the strategy' do
      described_class.javascript_strategy = valid_strategy

      expect(strategy).to receive(:before_non_js)
      described_class.before_non_js

      expect(strategy).to receive(:before_js)
      described_class.before_js
    end
  end
end
