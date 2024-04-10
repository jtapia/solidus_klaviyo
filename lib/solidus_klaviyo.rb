# frozen_string_literal: true

require 'solidus_core'
require 'solidus_support'
require 'httparty'
require 'solidus_tracking'

require 'solidus_klaviyo/version'
require 'solidus_klaviyo/engine'
require 'solidus_klaviyo/configuration'
require 'solidus_klaviyo/tracker'
require 'solidus_klaviyo/subscriber'
require 'solidus_klaviyo/errors'

require 'klaviyo-api-sdk'

module SolidusKlaviyo
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end

    def subscribe_now(list_id, email)
      subscriber.subscribe(list_id, email)
    end

    def subscribe_later(list_id, email)
      SolidusKlaviyo::SubscribeJob.perform_later(list_id, email)
    end

    def update_now(email, properties = {})
      subscriber.update(list_id, email, properties)
    end

    def update_later(email, properties = {})
      SolidusKlaviyo::UpdateJob.perform_later(email, properties)
    end

    def bulk_update_now(list_id, profiles)
      subscriber.bulk_update(list_id, profiles)
    end

    def bulk_update_later(list_id, profiles)
      SolidusKlaviyo::BulkUpdateJob.perform_later(list_id, profiles)
    end

    private

    def subscriber
      @subscriber ||= SolidusKlaviyo::Subscriber.new(
        api_key: configuration.api_key,
        public_key: configuration.public_key
      )
    end
  end
end
