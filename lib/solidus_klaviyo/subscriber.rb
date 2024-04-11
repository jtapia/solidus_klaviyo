# frozen_string_literal: true

module SolidusKlaviyo
  class Subscriber
    attr_reader :api_key, :public_key

    class << self
      def from_config
        # Setup authorization
        KlaviyoAPI.configure do |config|
          config.api_key['Klaviyo-API-Key'] = "Klaviyo-API-Key #{SolidusKlaviyo.configuration.api_key}"
        end

        new(api_key: SolidusKlaviyo.configuration.api_key)
      end
    end

    def initialize(api_key:, public_key:)
      @api_key = api_key
      @public_key = public_key
    end

    def subscribe(list_id, email)
      payload = {
        data: {
          type: 'profile-subscription-bulk-create-job',
          attributes: {
            profiles: {
              data: [
                {
                  type: 'profile',
                  attributes: {
                    email: email.to_s,
                    subscriptions: {
                      email: {
                        marketing: {
                          consent: 'SUBSCRIBED'
                        }
                      }
                    }
                  }
                }
              ]
            }
          },
          relationships: {
            list: {
              data: {
                type: 'list',
                id: list_id
              }
            }
          }
        }
      }

      ::KlaviyoAPI::Profiles.subscribe_profiles(payload)
    end

    def update(id, email, properties = {})
      profile = SolidusKlaviyo::Profiler.get_profile_by_email(email)
      profile_id = profile[:data][0].try(:[], :id)

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

    def bulk_update(list_id, profiles)
      payload = {
        data: {
          type: 'profile-bulk-import-job',
          attributes: {
            profiles: {
              data: build_profiles_payload(profiles)
            }
          },
          relationships: {
            lists: {
              data: [
                {
                  type: 'list',
                  id: list_id
                }
              ]
            }
          }
        }
      }

      ::KlaviyoAPI::Profiles.spawn_bulk_profile_import_job(payload)
    end

    private

    def build_profiles_payload(profiles)
      profiles_payload = []

      profiles.each do |profile|
        profiles_payload << {
          type: 'profile',
          id: profile[:id],
          attributes: {
            email: profile[:email],
            first_name: profile[:first_name],
            last_name: profile[:last_name]
          }
        }
      end

      profiles_payload
    end
  end
end
