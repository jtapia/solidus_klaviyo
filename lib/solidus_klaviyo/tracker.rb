# frozen_string_literal: true

# require 'klaviyo-api-sdk'

module SolidusKlaviyo
  class Tracker < SolidusTracking::Tracker
    class << self
      def from_config
        # Setup authorization
        KlaviyoAPI.configure do |config|
          config.api_key['Klaviyo-API-Key'] = "Klaviyo-API-Key #{SolidusKlaviyo.configuration.api_key}"
        end

        new(api_key: SolidusKlaviyo.configuration.api_key)
      end
    end

    # This method is called by SolidusTracking on `track` call
    def track(event)
      payload = {
        data: {
          type: 'event',
          attributes: {
            properties: event.properties.merge({ name: event.name }),
            metric: {
              data: {
                type: 'metric',
                attributes: {
                  name: event.name
                }
              }
            },
            profile: {
              data: {
                type: 'profile',
                attributes: {
                  email: event.customer_properties['$email'] || SolidusKlaviyo.configuration.email,
                  properties: event.customer_properties
                }
              }
            }
          },
          time: event.time
        }
      }

      ::KlaviyoAPI::Events.create_event(payload)
    end

    # This method is called directly to send more information
    def create_event(event_name, email, properties = {})
      payload = {
        data: {
          type: 'event',
          attributes: {
            properties: properties.merge({ name: event_name }),
            metric: {
              data: {
                type: 'metric',
                attributes: {
                  name: event_name
                }
              }
            },
            profile: {
              data: {
                type: 'profile',
                attributes: {
                  email: email || SolidusKlaviyo.configuration.email
                }
              }
            }
          }
        }
      }

      ::KlaviyoAPI::Events.create_event(payload)
    end
  end
end
