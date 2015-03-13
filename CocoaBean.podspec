lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoa_bean/version'

Pod::Spec.new do |s|
  s.name = 'CocoaBean'
  s.version = CocoaBean::VERSION
  s.license = "MIT"
  s.summary = "The framework enables you to develop native \
iOS app with javaScript."
  s.authors = {
    'Zhang Kai Yu' => 'yeannylam@gmail.com'
  }

  s.source   = "" # TODO

  s.requires_arc = true

  s.ios.deployment_target = '8.0'

  s.public_header_files = "" # TODO
  s.source_files = "" # TODO

end
