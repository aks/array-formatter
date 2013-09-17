# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'array/formatter/version'

Gem::Specification.new do |spec|
  spec.name          = "array-formatter"
  spec.version       = Array::Formatter::VERSION
  spec.authors       = ["Alan Stebbens"]
  spec.email         = ["aks@stebbens.org"]
  spec.summary       = "Format an array of arrays in one of serveral string formats"
  spec.description   = <<-EOF
    A simple gem to reformat an array of arrays into one of several string
    formats: HTML table; CSV; ASCII table; YAML
    EOF
  spec.homepage      = "https://gitlab.com/as/array-formatter"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
