# frozen_string_literal: true

module SolidusKlaviyo
  class CreateEventJob < ApplicationJob
    queue_as :default

    def perform(event_name, email, properties = {})
      SolidusKlaviyo.create_event(event_name, email, properties)
    rescue SolidusKlaviyo::RateLimitedError => e
      self.class.set(wait: e.retry_after).perform_later(
        event_name,
        email,
        properties
      )
    end
  end
end
