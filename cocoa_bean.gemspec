# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoa_bean/version'

Gem::Specification.new do |s|
  s.name          = "cocoabean"
  s.version       = CocoaBean::VERSION
  s.authors       = ["Zhang Kai Yu"]
  s.email         = ["yeannylam@gmail.com"]
  s.summary       = "The framework enables you to develop native \
iOS app with javaScript."
  s.description   = "Need description"
  s.homepage      = "https://github.com/cheunghy/CocoaBean"
  s.license       = "MIT"

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = %w{ lib }

  s.add_runtime_dependency 'cocoapods', '~> 0.35'
  s.add_runtime_dependency 'xcodeproj'
  s.add_runtime_dependency 'sprockets', '~> 2.12.3'

  s.add_development_dependency 'bundler', '~> 1.7'
  s.add_development_dependency 'rake', '~> 10.0'

  s.required_ruby_version = '>= 2.0.0'
end
