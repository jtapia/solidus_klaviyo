# frozen_string_literal: true

module SolidusKlaviyo
  class UpdateJob < ApplicationJob
    queue_as :default

    def perform(list_id, email, properties = {})
      ::Klaviyo::Profiles.update_profile(list_id, email, properties)
    rescue SolidusKlaviyo::RateLimitedError => e
      self.class.set(wait: e.retry_after).perform_later(list_id, email, properties)
    end
  end
end
