# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gcaldis/version'

Gem::Specification.new do |spec|
  spec.name          = "gcaldis"
  spec.version       = Gcaldis::VERSION
  spec.authors       = ["Tony Martin"]
  spec.email         = ["tonypmgg@gmail.com"]
  spec.summary       = %q{Display events from a user's google calendar'}
  spec.description   = %q{Uses the Google Calendar API to display events from the user's google calendar'}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  
  spec.add_dependency 'google-api-client'
  spec.add_dependency 'gtk3'
  
end
