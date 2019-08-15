# frozen_string_literal: true

# require 'cucumber/rails/application'
# require 'cucumber/rails/hooks'
# require 'cucumber/rails/database'
require 'cucumber/rails'
# require 'cucumber/rails/world'

describe Cucumber::Rails do
  describe '.configure' do
    it 'can configure Cucumber Rails in a configure block' do
      expect(described_class).to receive(:configure).once

      described_class.configure { |_| :foo }
    end

    it 'yields the configured options' do
      expect(described_class).to receive(:remove_rack_test_helpers=)

      described_class.configure do |config|
        config.remove_rack_test_helpers = true
      end
    end
  end

  describe '.remove_rack_test_helpers' do
    subject { described_class.remove_rack_test_helpers }

    context 'by default' do
      it { is_expected.to be nil }

      it 'leaves the RackTest Helpers present in the Cucumber World' do
        expect(World.ancestors).to include(Rack::Test::Methods)
      end
    end

    context 'when set to true' do
      before { described_class.remove_rack_test_helpers = true }

      it { is_expected.to be true }

      it 'removes the RackTest Helpers from the Cucumber World' do
        expect(World.ancestors).not_to include(Rack::Test::Methods)
      end
    end
  end
end
