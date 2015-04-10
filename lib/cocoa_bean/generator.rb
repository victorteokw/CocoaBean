module CocoaBean

  autoload :TemplateGenerator, 'cocoa_bean/generator/template_generator'
  autoload :BlockGenerator, 'cocoa_bean/generator/block_generator'

  class Generator

    require 'colored'

    class AbstractGeneratorCannotGenerateError < RuntimeError; end

    class << self

      def abstract?
        return @abstract
      end

      def abstract!
        @abstract = true
      end

      attr_accessor :abstract

    end

    abstract!

    def initialize(options = {})
      @options = options
    end

    def generate
      raise AbstractGeneratorCannotGenerateError if self.class.abstract?
    end

    attr_accessor :destination

    def warning_and_exit(message)
      puts ('[!] ' + message).red
      exit 1
    end
  end
end
