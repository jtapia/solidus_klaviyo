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
      klaviyo_client = stub_klaviyo_client
      event = {
        'token': 'test_public_key',
        'event': 'Started Checkout',
        'customer_properties': { '$email' => 'jdoe@example.com' },
        'properties': { 'foo' => 'bar' }
      }

      event_tracker = Klaviyo::TrackIdentifyApi.new(klaviyo_client)
      expect(event_tracker.track_post(event)).to eq('0')
    end
  end

  private

  def stub_klaviyo_client
    klaviyo_client = Klaviyo::ApiClient.default
    klaviyo_client.config.api_key = 'test_key'
    klaviyo_client
  end
end
