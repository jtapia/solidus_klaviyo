# frozen_string_literal: true

RSpec.describe SolidusKlaviyo::Subscriber do
  describe '.from_config' do
    it 'returns a tracker with the configured API key' do
      allow(SolidusKlaviyo.configuration)
        .to receive(:api_key).and_return('test_key')
      allow(SolidusKlaviyo.configuration)
        .to receive(:public_key).and_return('test_public_key')

      subscriber = described_class.from_config

      expect(subscriber.api_key).to eq('test_key')
      expect(subscriber.public_key).to eq('test_public_key')
    end
  end

  describe '#subscribe' do
    context 'when the request is well-formed' do
      it 'subscribes the given email to the configured list' do
        subscriber = described_class.new(
          api_key: 'test_key',
          public_key: 'test_public_key'
        )
        list_id = 'dummyListId'
        email = 'jdoe@example.com'

        VCR.use_cassette('subscriber') do
          subscriber.subscribe(list_id, email)
        end

        expect(
          a_request(
            :post, "https://a.klaviyo.com/api/v2/list/#{list_id}/subscribe"
          )
        ).to have_been_made
      end
    end

    context 'when the request is rate-limited' do
      it 'raises a RateLimitedError' do
        subscriber = described_class.new(
          api_key: 'test_key',
          public_key: 'test_public_key'
        )
        list_id = 'dummyListId'
        email = 'jdoe@example.com'

        expect {
          VCR.use_cassette('subscriber-rate-limited') do
            subscriber.subscribe(list_id, email)
          end
        }.to raise_error(SolidusKlaviyo::RateLimitedError)
      end
    end

    context 'when the request is malformed' do
      it 'raises a SubscriptionError' do
        subscriber = described_class.new(
          api_key: 'test_key',
          public_key: 'test_public_key'
        )
        list_id = 'wrongListId'
        email = 'jdoe@example.com'

        expect {
          VCR.use_cassette('subscriber') do
            subscriber.subscribe(list_id, email)
          end
        }.to raise_error(SolidusKlaviyo::SubscriptionError)
      end
    end
  end

  describe '#update' do
    context 'when the request is well-formed' do
      it 'updates the given email on the configured list' do
        subscriber = described_class.new(
          api_key: 'test_key',
          public_key: 'test_public_key'
        )
        list_id = 'dummyListId'
        email = 'jdoe@example.com'

        VCR.use_cassette('update') do
          subscriber.update(list_id, email)
        end

        expect(
          a_request(:post, "https://a.klaviyo.com/api/v2/list/#{list_id}/members")
        ).to have_been_made
      end
    end

    context 'when the request is rate-limited' do
      it 'raises a RateLimitedError' do
        subscriber = described_class.new(
          api_key: 'test_key',
          public_key: 'test_public_key'
        )
        list_id = 'dummyListId'
        email = 'jdoe@example.com'

        expect {
          VCR.use_cassette('update-rate-limited') do
            subscriber.update(list_id, email)
          end
        }.to raise_error(SolidusKlaviyo::RateLimitedError)
      end
    end

    context 'when the request is malformed' do
      it 'raises a SubscriptionError' do
        subscriber = described_class.new(
          api_key: 'test_key',
          public_key: 'test_public_key'
        )
        list_id = 'wrongListId'
        email = 'jdoe@example.com'

        expect {
          VCR.use_cassette('update') do
            subscriber.update(list_id, email)
          end
        }.to raise_error(SolidusKlaviyo::SubscriptionError)
      end
    end
  end

  describe '#bulk_update' do
    context 'when the request is well-formed' do
      it 'updates the profile on the configured list' do
        subscriber = described_class.new(
          api_key: 'test_key',
          public_key: 'test_public_key'
        )
        list_id = 'dummyListId'
        profile = {
          email: 'jdoe@example.com'
        }

        VCR.use_cassette('update') do
          subscriber.bulk_update(list_id, profile)
        end

        expect(
          a_request(
            :post,
            "https://a.klaviyo.com/api/v2/list/#{list_id}/members"
          )
        ).to have_been_made
      end
    end

    context 'when the request is rate-limited' do
      it 'raises a RateLimitedError' do
        subscriber = described_class.new(
          api_key: 'test_key',
          public_key: 'test_public_key'
        )
        list_id = 'dummyListId'
        profile = {
          email: 'jdoe@example.com'
        }

        expect {
          VCR.use_cassette('update-rate-limited') do
            subscriber.bulk_update(list_id, profile)
          end
        }.to raise_error(SolidusKlaviyo::RateLimitedError)
      end
    end

    context 'when the request is malformed' do
      it 'raises a SubscriptionError' do
        subscriber = described_class.new(
          api_key: 'test_key',
          public_key: 'test_public_key'
        )
        list_id = 'wrongListId'
        profile = {
          email: 'jdoe@example.com'
        }

        expect {
          VCR.use_cassette('update') do
            subscriber.bulk_update(list_id, profile)
          end
        }.to raise_error(SolidusKlaviyo::SubscriptionError)
      end
    end
  end
end
