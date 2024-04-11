# frozen_string_literal: true

RSpec.describe SolidusKlaviyo::Profiler do
  describe '.from_config' do
    it 'returns a tracker with the configured API key' do
      allow(SolidusKlaviyo.configuration)
          .to receive(:api_key).and_return('test_key')
      allow(SolidusKlaviyo.configuration)
          .to receive(:public_key).and_return('test_public_key')

      profiler = described_class.from_config

      expect(profiler.api_key).to eq('test_key')
      expect(profiler.public_key).to eq('test_public_key')
    end
  end

  describe '#get_profile' do
    context 'when the request is well-formed' do
      it 'profiles returns the profile based on the ID' do
        profiler = described_class.new(
          api_key: 'pk_969f31237a8adf114b9a6c3197422c6cea',
          public_key: 'test_public_key'
        )
        id = '01GDDKASAP8TKDDA2GRZDSVP4H'

        VCR.use_cassette('profiler') do
          profiler.get_profile(id)
        end

        expect(
          a_request(
            :post,
            "https://a.klaviyo.com/api/profiles/#{id}"
          )
        ).to have_been_made
      end
    end
  end

  describe '#get_profiles' do
    context 'when the request is well-formed' do
      it 'profiles returns the profile based on the email' do
        profiler = described_class.new(
          api_key: 'pk_969f31237a8adf114b9a6c3197422c6cea',
          public_key: 'test_public_key'
        )
        email = 'jdoe@example.com'

        VCR.use_cassette('profiler') do
          profiler.get_profiles(email)
        end

        expect(
          a_request(
            :post,
            "https://a.klaviyo.com/api/profiles/?filter=any(email,['#{email}'])"
          )
        ).to have_been_made
      end
    end
  end

  describe '#get_profile_by_email' do
    context 'when the request is well-formed' do
      it 'profiles returns the profile based on the email' do
        profiler = described_class.new(
          api_key: 'pk_969f31237a8adf114b9a6c3197422c6cea',
          public_key: 'test_public_key'
        )
        email = 'jdoe@example.com'

        VCR.use_cassette('profiler') do
          profiler.get_profile_by_email(email)
        end

        expect(
          a_request(
            :post,
            "https://a.klaviyo.com/api/profiles/?filter=any(email,['#{email}'])"
          )
        ).to have_been_made
      end
    end
  end

  describe '#create_profile' do
    context 'when the request is well-formed' do
      it 'profiles returns the profile created' do
        profiler = described_class.new(
          api_key: 'pk_969f31237a8adf114b9a6c3197422c6cea',
          public_key: 'test_public_key'
        )
        email = 'jdoe@example.com'
        firstname = 'John'
        lastname = 'Doe'
        properties = {}

        VCR.use_cassette('profiler') do
          profiler.create_profile(
            email,
            firstname,
            lastname,
            properties
          )
        end

        expect(
          a_request(:post, 'https://a.klaviyo.com/api/profiles/')
        ).to have_been_made
      end
    end
  end

  describe '#update_profile' do
    context 'when the request is well-formed' do
      it 'profiles returns the profile updated' do
        profiler = described_class.new(
          api_key: 'pk_969f31237a8adf114b9a6c3197422c6cea',
          public_key: 'test_public_key'
        )
        email = 'jdoe@example.com'
        id = '01GDDKASAP8TKDDA2GRZDSVP4H'
        properties = {}

        VCR.use_cassette('profiler') do
          profiler.update_profile(id, properties)
        end

        expect(
          a_request(:post, "https://a.klaviyo.com/api/profiles/#{id}")
        ).to have_been_made
      end
    end
  end
end
