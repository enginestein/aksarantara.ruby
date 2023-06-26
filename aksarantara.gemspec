# frozen_string_literal: true
# You can access detection through Sanscript.detect(text) and transliteration through Sanscript.transliterate(text, from, to).

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "aksarantara/version"

Gem::Specification.new do |spec|
  spec.name          = "aksarantara"
  spec.version       = aksarantara::VERSION
  spec.authors       = ["Arya Praneil Pritesh"]
  spec.email         = ["aryapraneil@gmail.com"]

  spec.summary       = "Ruby gem for Sanskrit transliteration"
  spec.homepage      = "https://github.com/enginestein/aksarantara.rb"
  spec.license       = "GPL-v3"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.extensions    = "Rakefile"

  spec.required_ruby_version = "~> 2.3"

  spec.add_development_dependency "benchmark-ips", "~> 2.7"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "coveralls", "~> 0.8"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "rake", "~> 12"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "rubocop", "~> 0.59"
  spec.add_development_dependency "rubocop-rspec", "~> 1.29"
  spec.add_development_dependency "yard", "~> 0.9"

  spec.add_runtime_dependency "activesupport", "~> 5.2"
  spec.add_runtime_dependency "ice_nine", "~> 0.11"
  spec.add_runtime_dependency "thermite", "~> 0.13"
end