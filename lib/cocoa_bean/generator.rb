module CocoaBean
  autoload :FrameworkGenerator, 'cocoa_bean/generator/framework_generator'
  autoload :TemplateGenerator, 'cocoa_bean/generator/template_generator'
  autoload :TargetGenerator, 'cocoa_bean/generator/target_generator'

  class Generator

    class << self

      def abstract?
        return @abstract
      end

      def abstract!
        @abstract = true
      end

      def directory(directory_name)
        if directory_name.is_a? Proc
          directories << directory_name
        elsif directory_name.is_a? String
          directories << directory_name
        end
      end

      def file(file_name) # file name with directory
        if file_name.is_a? Proc
          files << file_name
        elsif file_name.is_a? String
          files << file_name
        end
      end

      def directories
        @directories ||= []
        return @directories
      end

      def files
        @files ||= []
        return @files
      end

    end

    abstract!

    def initialize(options = {})
    end

    def generate
      raise "Abstarct generator cannot generate." if self.class.abstract?
    end

    attr_accessor :base_directory

    def process_file(file_name)
      raise "Abstract generator cannot process file." if self.class.abstract?
    end

    def process_directory(directory_name)
      raise "Abstract generator cannot process directory." if self.class.abstract?
    end
  end
end
