# frozen_string_literal: true

require 'klaviyo_sdk'

module SolidusKlaviyo
  class Tracker < SolidusTracking::Tracker
    class << self
      def from_config
        new(api_key: SolidusKlaviyo.configuration.api_key)
      end
    end

    def track(event)
      track_payload = {
        'event': event.name,
        'customer_properties': event.customer_properties,
        'properties': event.properties
      }
      data = track_payload.to_json
      tracker = Klaviyo::TrackIdentifyApi.new(klaviyo)
      tracker.track_post(data)
    end

    private

    def klaviyo
      @klaviyo ||= Klaviyo::ApiClient.default
      @klaviyo.config.api_key = options.fetch(:api_key)
      @klaviyo
    end
  end
end
