require 'byebug'

module CocoaBean
  class Command
    class New < Command
      self.summary = 'Generate a Cocoa Bean project.'
      self.description = "Need description TODO."

      def self.options
        [
          ['--web', 'Generate web code.'],
          ['--native', 'Generate native code.']
        ].concat(super)
      end

      def initialize(argv)
        super
        @web = argv.flag? 'web'
        @native = argv.flag? 'native'
        @web = true if @web.nil?
        @native = true if @native.nil?
      end

      def validate!
        super
      end

      def run
        puts "Run New Command. Web is #@web Native is #@native"
      end

    end
  end
end
