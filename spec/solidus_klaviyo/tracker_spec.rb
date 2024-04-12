# frozen_string_literal: true

RSpec.describe SolidusKlaviyo::Tracker do
  describe '.from_config' do
    it 'returns a tracker with the configured API key' do
      allow(SolidusKlaviyo.configuration)
          .to receive(:api_key).and_return('test_key')

      tracker = described_class.from_config

      expect(tracker.options[:api_key]).to eq('test_key')
    end
  end

  describe '#track' do
    it 'tracks the event through the Klaviyo API' do
      tracker = described_class.new(
        api_key: 'test_key'
      )

      payload = OpenStruct.new(
        name: 'Started Checkout',
        properties: {},
        customer_properties: { '$email': 'jdoe@example.com' }
      )

      VCR.use_cassette('track') do
        expect(
          tracker.track(payload)
        ).to be_nil
      end
    end
  end

  describe '#create_event' do
    it 'creates the track event through the Klaviyo API' do
      tracker = described_class.new(
        api_key: 'test_key'
      )

      VCR.use_cassette('track') do
        expect(
          tracker.create_event(
            'Started Checkout',
            'jdoe@example.com',
            { 'foo' => 'bar' }
          )
        ).to be_nil
      end
    end
  end
end
