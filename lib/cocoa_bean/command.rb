require 'claide'

module CocoaBean
  class Command < CLAide::Command
    require 'cocoa_bean/command/new'
    require 'cocoa_bean/command/preview'
    require 'cocoa_bean/command/about'
    require 'cocoa_bean/command/test'

    self.abstract_command = true
    self.command = 'cocoabean'
    self.version = VERSION
    self.description = "The very nice CocoaBean command."

  end
end
