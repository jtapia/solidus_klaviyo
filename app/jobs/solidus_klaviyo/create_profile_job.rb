# frozen_string_literal: true

module SolidusKlaviyo
  class CreateProfileJob < ApplicationJob
    queue_as :default

    def perform(email, firstname, lastname, properties = {})
      SolidusKlaviyo.create_profile(
        email,
        firstname,
        lastname,
        properties
      )
    rescue SolidusKlaviyo::RateLimitedError => e
      self.class.set(wait: e.retry_after).perform_later(
        email,
        firstname,
        lastname,
        properties
      )
    end
  end
end
