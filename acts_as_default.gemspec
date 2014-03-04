# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acts_as_default/version'

Gem::Specification.new do |spec|
  spec.name          = "acts_as_default"
  spec.version       = ActsAsDefault::VERSION
  spec.authors       = ["Mirko Mignini"]
  spec.email         = ["mirko.mignini@libero.it"]
  spec.summary       = %q{Using acts as default you can set a default row in your activerecord collection, also for has_many relationships}
  spec.description   = ''
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency "activerecord", "~> 4.0.0"
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "sqlite3"
end
