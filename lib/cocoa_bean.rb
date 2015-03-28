module CocoaBean
  require 'cocoa_bean/version'
  autoload :Command, 'cocoa_bean/command'
  autoload :Generator, 'cocoa_bean/generator'
  autoload :FrameworkGenerator, 'cocoa_bean/generator/framework_generator'
  autoload :TemplateGenerator, 'cocoa_bean/generator/template_generator'
end
