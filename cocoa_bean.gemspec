# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'cocoa_bean/version'
require 'cocoa_bean/description'

Gem::Specification.new do |s|
  s.name          = "cocoabean"
  s.version       = CocoaBean::VERSION
  s.authors       = ["Zhang Kai Yu"]
  s.email         = ["yeannylam@gmail.com"]
  s.summary       = "Code web like iOS."
  s.description   = CocoaBean::DESCRIPTION

  s.homepage      = "https://github.com/cheunghy/CocoaBean"
  s.license       = "MIT"

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = %w{ lib }

  s.add_runtime_dependency 'cocoapods', '~> 0.39'
  s.add_runtime_dependency 'sprockets', '~> 3.5'
  s.add_runtime_dependency 'coffee-script', '~> 2.4'
  s.add_runtime_dependency 'sprockets-es6', '~> 0.8'
  s.add_runtime_dependency 'jasmine', '~> 2.4'
  s.add_runtime_dependency 'uglifier', '~> 2.7'
  s.add_runtime_dependency 'fastimage', '~> 1.8'

  s.add_development_dependency 'bundler', '~> 1.11'
  s.add_development_dependency 'rake', '~> 10.4'

  s.required_ruby_version = '>= 2.0.0'
end
