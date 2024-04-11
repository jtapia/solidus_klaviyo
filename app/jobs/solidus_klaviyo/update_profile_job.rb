# frozen_string_literal: true

module SolidusKlaviyo
  class UpdateProfileJob < ApplicationJob
    queue_as :default

    def perform(id, properties = {})
      SolidusKlaviyo.update_profile(id, properties)
    rescue SolidusKlaviyo::RateLimitedError => e
      self.class.set(wait: e.retry_after).perform_later(id, properties)
    end
  end
end
