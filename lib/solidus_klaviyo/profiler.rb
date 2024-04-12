# frozen_string_literal: true

module SolidusKlaviyo
  class Profiler
    attr_reader :api_key

    class << self
      def from_config
        # Setup authorization
        ::KlaviyoAPI.configure do |config|
          config.api_key['Klaviyo-API-Key'] = "Klaviyo-API-Key #{::SolidusKlaviyo.configuration.api_key}"
        end

        new(api_key: ::SolidusKlaviyo.configuration.api_key)
      end
    end

    def initialize(api_key:)
      @api_key = api_key
    end

    def get_profile(id, query = {})
      ::KlaviyoAPI::Profiles.get_profile(id, query)
    end

    def get_profiles(query = {})
      ::KlaviyoAPI::Profiles.get_profiles(query)
    end

    def get_profile_by_email(email)
      payload = {
        filter: "any(email,['#{email}'])"
      }

      ::KlaviyoAPI::Profiles.get_profiles(payload)
    end

    def create_profile(email, firstname, lastname, properties = {})
      payload = {
        data: {
          type: 'profile',
          attributes: {
            email: email,
            first_name: firstname,
            last_name: lastname,
            properties: properties
          }
        }
      }

      ::KlaviyoAPI::Profiles.create_profile(payload)
    end

    def update_profile(profile_id, properties = {})
      payload = {
        data: {
          type: 'profile',
          id: profile_id,
          attributes: {
            properties: properties
          }
        }
      }

      ::KlaviyoAPI::Profiles.update_profile(profile_id, payload)
    end
  end
end
