# frozen_string_literal: true

require_relative 'lib/solidus_klaviyo/version'

Gem::Specification.new do |s|
  s.name = 'solidus_klaviyo'
  s.version = SolidusKlaviyo::VERSION
  s.authors = ['Alessandro Desantis', 'Jonathan Tapia']
  s.email = 'jtapia.dev@gmail.com'

  s.summary = 'Klaviyo integration for Solidus stores.'
  s.homepage = 'https://github.com/solidusio-contrib/solidus_klaviyo'
  s.license = 'BSD-3-Clause'

  s.metadata['homepage_uri'] = s.homepage
  s.metadata['source_code_uri'] = 'https://github.com/Minimal-Audio/solidus_klaviyo'
  s.metadata['changelog_uri'] = 'https://github.com/Minimal-Audio/solidus_klaviyo/blob/master/CHANGELOG.md'

  s.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0") }

  s.files = files.grep_v(%r{^(test|spec|features)/})
  s.test_files = files.grep(%r{^(test|spec|features)/})
  s.bindir = 'exe'
  s.executables = files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'solidus_core'
  s.add_dependency 'solidus_support', '~> 0.5'
  s.add_dependency 'httparty', '~> 0.18'
  s.add_dependency 'solidus_tracking'
  s.add_dependency 'klaviyo_sdk'

  s.add_development_dependency 'pry'
  s.add_development_dependency 'solidus_dev_support', '~> 2.5'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
end
