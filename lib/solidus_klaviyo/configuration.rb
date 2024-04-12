# frozen_string_literal: true

module SolidusKlaviyo
  class Configuration
    attr_accessor :api_key, :default_list
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    alias config configuration

    def configure
      yield configuration
    end
  end
end
