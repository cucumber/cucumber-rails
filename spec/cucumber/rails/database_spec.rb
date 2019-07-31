# frozen_string_literal: true

require 'cucumber/rails/database'

describe Cucumber::Rails::Database do
  before { allow(strategy_type).to receive(:new).and_return(strategy) }

  let(:strategy) { instance_double(strategy_type, before_js: nil, before_non_js: nil) }
  let(:strategy_type) { Cucumber::Rails::Database::TruncationStrategy }

  it 'forwards events to the selected strategy' do
    described_class.javascript_strategy = :truncation

    expect(strategy).to receive(:before_non_js).ordered
    described_class.before_non_js

    expect(strategy).to receive(:before_js).ordered
    described_class.before_js
  end

  it 'raises an error if you use a non-understood strategy' do
    expect { described_class.javascript_strategy = :invalid }
      .to raise_error(Cucumber::Rails::Database::InvalidStrategy)
  end

  describe 'using a custom strategy' do
    let(:strategy_type) { ValidStrategy }

    class ValidStrategy
      def before_js
        # Anything
      end

      def before_non_js
        # Likewise
      end
    end

    class InvalidStrategy; end

    it 'raises an error if the strategy doens\'t support the protocol' do
      expect { described_class.javascript_strategy = InvalidStrategy }
        .to raise_error(ArgumentError)
    end

    it 'accepts a custom strategy with a valid interface' do
      expect { described_class.javascript_strategy = ValidStrategy }
        .not_to raise_error
    end

    it 'forwards events to a custom strategy' do
      described_class.javascript_strategy = ValidStrategy

      expect(strategy).to receive(:before_non_js).ordered
      described_class.before_non_js

      expect(strategy).to receive(:before_js).ordered
      described_class.before_js
    end
  end
end
