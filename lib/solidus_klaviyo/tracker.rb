# frozen_string_literal: true

require 'klaviyo-api-sdk'

module SolidusKlaviyo
  class Tracker < SolidusTracking::Tracker
    class << self
      def from_config
        new(
          api_key: SolidusKlaviyo.configuration.api_key,
          public_key: SolidusKlaviyo.configuration.public_key
        )
      end
    end

    def track(event)
      ::KlaviyoAPI::Events.create_event(
        track_payload(event)
      )
    end

    def track_payload(event)
      {
        data: {
          type: 'event',
          attributes: {
            properties: {
              event: event.name,
              customer_properties: event&.customer_properties,
              properties: event&.properties
            },
            metric: {
              data: {
                type: 'metric',
                attributes: {
                  name: event&.name
                }
              }
            },
            profile: {
              data: {
                type: 'profile',
                attributes: {
                  email: event&.customer_properties.try(:[], '$email')
                }
              }
            }
          }
        }
      }
    end
  end
end
