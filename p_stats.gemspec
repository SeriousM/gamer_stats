# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'p_stats/version'

Gem::Specification.new do |spec|
  spec.name          = "p_stats"
  spec.version       = PStats::VERSION
  spec.authors       = ["SeriousM - Bernhard Millauer"]
  spec.email         = ["bernhard.millauer@gmail.com"]
  spec.description   = %q{Provides a way to gather game stats from the http://p-stats.com network}
  spec.summary       = %q{Provides a way to gather game stats from the http://p-stats.com network}
  spec.homepage      = "https://github.com/SeriousM/p_stats"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  
  spec.add_dependency "httparty"
  spec.add_dependency "json"
end
