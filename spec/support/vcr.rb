# frozen_string_literal: true

require 'webmock'
require 'webmock/rspec'
require 'vcr'

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = true
  config.hook_into :webmock
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.default_cassette_options = {
    match_requests_on: [:method, :host, :path]
  }
end
