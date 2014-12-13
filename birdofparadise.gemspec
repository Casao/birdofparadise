# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'birdofparadise/version'

Gem::Specification.new do |spec|
  spec.name          = "Bird of Paradise"
  spec.version       = Birdofparadise::VERSION
  spec.authors       = ["Colin Ewen"]
  spec.email         = ["colin@draecas.com"]
  spec.summary       = %q{A reimplementation of Bower in pure Ruby}
  spec.description   = %q{A reimplementation of Bower in pure Ruby}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"

  spec.add_dependency "octokit"
  spec.add_dependency "httparty"
  spec.add_dependency "disk_store"
end
