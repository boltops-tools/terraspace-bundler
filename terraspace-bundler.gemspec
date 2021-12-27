# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "terraspace_bundler/version"

Gem::Specification.new do |spec|
  spec.name          = "terraspace-bundler"
  spec.version       = TerraspaceBundler::VERSION
  spec.authors       = ["Tung Nguyen"]
  spec.email         = ["tung@boltops.com"]
  spec.summary       = "Bundles terraform modules"
  spec.homepage      = "https://github.com/boltops-tools/terraspace-bundler"
  spec.license       = "Apache2.0"

  spec.files         = File.directory?('.git') ? `git ls-files`.split($/) : Dir.glob("**/*")
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "aws-sdk-s3"
  spec.add_dependency "dsl_evaluator"
  spec.add_dependency "memoist"
  spec.add_dependency "nokogiri"
  spec.add_dependency "rainbow"
  spec.add_dependency "rubyzip"
  spec.add_dependency "thor"
  spec.add_dependency "zeitwerk"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
