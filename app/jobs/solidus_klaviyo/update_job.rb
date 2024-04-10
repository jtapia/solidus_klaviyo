# frozen_string_literal: true

module SolidusKlaviyo
  class UpdateJob < ApplicationJob
    queue_as :default

    def perform(email, properties = {})
      SolidusKlaviyo.update_now(email, properties)
    rescue SolidusKlaviyo::RateLimitedError => e
      self.class.set(wait: e.retry_after).perform_later(email, properties)
    end
  end
end
