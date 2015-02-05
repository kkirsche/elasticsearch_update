# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elasticsearch_update/version'

Gem::Specification.new do |spec|
  spec.name          = "elasticsearch_update"
  spec.version       = ElasticsearchUpdate::VERSION
  spec.authors       = ["Kevin Kirsche"]
  spec.email         = ["kev.kirsche@gmail.com"]
  spec.summary       = %q{Updates the elasticsearch instance on the local machine.}
  spec.description   = %q{Updates the elasticsearch instance from a deb, zip, tar, or rpm on the local machine.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
