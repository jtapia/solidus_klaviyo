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
require 'solidus_klaviyo/profiler'
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

    def get_profile(profile_id, query)
      profiler.get_profile(profile_id, query)
    end

    def get_profiles(email)
      profiler.get_profiles(email)
    end

    def get_profile_by_email(email)
      profiler.get_profile_by_email(email)
    end

    def create_profile(email, firstname, lastname, properties = {})
      profiler.create_profile(
        email,
        firstname,
        lastname,
        properties
      )
    end

    def create_profile_later(email, firstname, lastname, properties = {})
      SolidusKlaviyo::CreateProfileJob.perform_later(
        email,
        firstname,
        lastname,
        properties
      )
    end

    def update_profile(profile_id, properties = {})
      profiler.update_profile(profile_id, properties)
    end

    def update_profile_later(profile_id, properties = {})
      SolidusKlaviyo::UpdateProfileJob.perform_later(
        profile_id,
        properties
      )
    end

    def create_event(event_name, email, properties = {})
      tracker.create_event(event_name, email, properties)
    end

    def create_event_later(event_name, email, properties = {})
      SolidusKlaviyo::CreateEventJob.perform_later(
        event_name,
        email,
        properties
      )
    end

    private

    def subscriber
      @subscriber ||= SolidusKlaviyo::Subscriber.new(
        api_key: configuration.api_key,
        public_key: configuration.public_key
      )
    end

    def profiler
      @profiler ||= SolidusKlaviyo::Profiler.new(
        api_key: configuration.api_key,
        public_key: configuration.public_key
      )
    end

    def tracker
      @tracker ||= SolidusKlaviyo::Tracker.new(
        api_key: configuration.api_key,
        public_key: configuration.public_key
      )
    end
  end
end
