# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gamer_stats/version'

Gem::Specification.new do |spec|
  spec.name          = "gamer_stats"
  spec.version       = GamerStats::VERSION
  spec.authors       = ["SeriousM - Bernhard Millauer"]
  spec.email         = ["bernhard.millauer@gmail.com"]
  spec.description   = %q{Provides a way to gather gamer stats from the http://p-stats.com network}
  spec.summary       = %q{Provides a way to gather gamer stats from the http://p-stats.com network}
  spec.homepage      = "https://github.com/SeriousM/gamer_stats"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.1"
  spec.add_development_dependency "vcr", "~> 2.5"
  spec.add_development_dependency "webmock", "~> 1.13"
  
  spec.add_dependency "httparty", "~> 0.11.0"
  spec.add_dependency "json", "~> 1.8.0"
  spec.add_dependency "percentage", "~> 1.0.0"
end
