# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tar_archive/version'

Gem::Specification.new do |spec|
  spec.name          = "tar_archive"
  spec.version       = TarArchive::VERSION
  spec.authors       = ["rekero"]
  spec.email         = ["remurdo@gmail.com"]
  spec.summary       = %q{Small tar gem}
  spec.description   = %q{Primitive executable gem for making and extracting tar archives}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ['tarr']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
