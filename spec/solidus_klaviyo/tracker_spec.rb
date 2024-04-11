# frozen_string_literal: true

RSpec.describe SolidusKlaviyo::Tracker do
  describe '.from_config' do
    it 'returns a tracker with the configured API key' do
      allow(SolidusKlaviyo.configuration)
          .to receive(:api_key).and_return('test_key')
      allow(SolidusKlaviyo.configuration)
          .to receive(:public_key).and_return('test_public_key')

      tracker = described_class.from_config

      expect(tracker.options[:api_key]).to eq('test_key')
      expect(tracker.options[:public_key]).to eq('test_public_key')
    end
  end

  describe '#track' do
    it 'tracks the event through the Klaviyo API' do
      VCR.use_cassette('track') do
        expect(
          KlaviyoAPI::Events.create_event(
            'Started Checkout',
            'jdoe@example.com',
            'properties': { 'foo' => 'bar' }
          )
        ).to eq('0')
      end
    end
  end

  describe '#create_event' do
    it 'creates the track event through the Klaviyo API' do
      VCR.use_cassette('track') do
        expect(
          KlaviyoAPI::Events.create_event(
            'Started Checkout',
            'jdoe@example.com',
            'properties': { 'foo' => 'bar' }
          )
        ).to eq('0')
      end
    end
  end
end
