# frozen_string_literal: true

RSpec.describe SolidusKlaviyo::Profiler do
  describe '.from_config' do
    it 'returns a tracker with the configured API key' do
      allow(SolidusKlaviyo.configuration)
          .to receive(:api_key).and_return('test_key')

      profiler = described_class.from_config

      expect(profiler.api_key).to eq('test_key')
    end
  end

  describe '#get_profile' do
    context 'when the request is well-formed' do
      it 'profiles returns the profile based on the ID' do
        profiler = described_class.new(
          api_key: 'test_key'
        )
        id = '01HV2Q5N708912T7NDCJ6C2TX8'

        VCR.use_cassette('profiler') do
          profiler.get_profile(id)
        end

        expect(
          a_request(
            :get,
            "https://a.klaviyo.com/api/profiles/01HV2Q5N708912T7NDCJ6C2TX8/"
          )
        ).to have_been_made
      end
    end
  end

  describe '#get_profiles' do
    context 'when the request is well-formed' do
      it 'profiles returns the profile based filters' do
        profiler = described_class.new(
          api_key: 'test_key'
        )
        email = 'jdoe@example.com'
        query = {
          filter: "any(email,['#{email}'])"
        }

        VCR.use_cassette('profiler') do
          profiler.get_profiles(query)
        end

        expect(
          a_request(
            :get,
            "https://a.klaviyo.com/api/profiles/?filter=any(email,%5B'jdoe@example.com'%5D)"
          )
        ).to have_been_made
      end
    end
  end

  describe '#get_profile_by_email' do
    context 'when the request is well-formed' do
      it 'profiles returns the profile based on the email' do
        profiler = described_class.new(
          api_key: 'test_key'
        )
        email = 'jdoe@example.com'

        VCR.use_cassette('profiler') do
          profiler.get_profile_by_email(email)
        end

        expect(
          a_request(
            :get,
            "https://a.klaviyo.com/api/profiles/?filter=any(email,%5B'jdoe@example.com'%5D)"
          )
        ).to have_been_made
      end
    end
  end

  describe '#create_profile' do
    context 'when the request is well-formed' do
      it 'profiles returns the profile created' do
        profiler = described_class.new(
          api_key: 'test_key'
        )
        email = 'jdoe@example.com'
        firstname = 'John'
        lastname = 'Doe'
        properties = { newKey: 'value' }

        VCR.use_cassette('profiler') do
          profiler.create_profile(
            email,
            firstname,
            lastname,
            properties
          )
        end

        expect(
          a_request(
            :post,
            'https://a.klaviyo.com/api/profiles/'
          )
        ).to have_been_made
      end
    end
  end

  describe '#update_profile' do
    context 'when the request is well-formed' do
      it 'profiles returns the profile updated' do
        profiler = described_class.new(
          api_key: 'test_key'
        )
        email = 'jdoe@example.com'
        id = '01HV2Q5N708912T7NDCJ6C2TX8'
        properties = { newKey: 'value' }

        VCR.use_cassette('profiler') do
          profiler.update_profile(id, properties)
        end

        expect(
          a_request(
            :patch,
            'https://a.klaviyo.com/api/profiles/01HV2Q5N708912T7NDCJ6C2TX8/'
          )
        ).to have_been_made
      end
    end
  end
end
