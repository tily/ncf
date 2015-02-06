# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ncf/version'

Gem::Specification.new do |spec|
  spec.name          = "ncf"
  spec.version       = Ncf::VERSION
  spec.authors       = ["tily"]
  spec.email         = ["tidnlyam@gmail.com"]
  spec.summary       = %q{ncf}
  spec.description   = %q{ncf}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "ace-client", "0.0.20"
  spec.add_dependency "thor", "0.19.1"
  spec.add_dependency "json", "1.8.2"
  spec.add_dependency "builder"
end
