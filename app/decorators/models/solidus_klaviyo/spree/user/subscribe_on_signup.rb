# frozen_string_literal: true

module SolidusKlaviyo
  module Spree
    module User
      module SubscribeOnSignup
        def self.prepended(base)
          base.class_eval do
            after_commit :subscribe_to_klaviyo, on: :create

            private

            def subscribe_to_klaviyo
              return unless SolidusKlaviyo.configuration.default_list

              SolidusKlaviyo.subscribe_later(
                SolidusKlaviyo.configuration.default_list,
                email
              )
            end
          end
        end

        ::Spree.user_class.prepend(self)
      end
    end
  end
end
