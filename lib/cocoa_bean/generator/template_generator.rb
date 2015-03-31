module CocoaBean
  require 'cocoa_bean/generator'
  class TemplateGenerator < Generator

    attr_accessor :destination_directory
    attr_accessor :app_name
    attr_accessor :template_options

    abstract!

    def initialize(options = {})
      super(options)
      self.destination_directory = options[:destination_directory]
      self.app_name = options[:app_name]
    end

    def base_directory
      return if !destination_directory || !app_name
      @base_directory ||= File.expand_path(app_name, destination_directory)
    end

    def generate
      super
      process_directory(base_directory)
      self.class.directories.each do |d|
        process_directory(d)
      end
      self.class.files.each do |f|
        process_file(f)
      end
    end

    def process_file(file_name)
      super
      puts "Process file: #{file_name}"
    end

    def process_directory(directory_name)
      super
      puts "Process directory: #{directory_name}"
    end

    class << self
      def templates_directory
        require 'rubygems'
        spec = Gem::Specification.find_by_name("cocoabean")
        gem_root = spec.gem_dir
        gem_root + "/templates"
      end

      def template_name(template_name)
        @template_name = template_name
      end
    end
  end

  class CoffeeTemplateGenerator < TemplateGenerator
    directory 'app'
    file 'app/build'
    file 'app/header'
    file 'app/main'
    directory 'app/application'
    file 'app/application/application_delegate'
    directory 'app/model'
    directory 'app/view'
    file 'app/view/sample_view'
    directory 'app/view_controller'
    file 'app/view_controller/sample_view_controller'
    directory 'cocoa'
    directory 'test'
    file '.gitignore'
    file 'Beanfile'

    template_name 'coffee'
  end

  class ES6TemplateGenerator < TemplateGenerator
    directory 'app'
    file 'app/build'
    file 'app/header'
    file 'app/main'
    directory 'app/application'
    file 'app/application/application_delegate'
    directory 'app/model'
    directory 'app/view'
    file 'app/view/sample_view'
    directory 'app/view_controller'
    file 'app/view_controller/sample_view_controller'
    directory 'cocoa'
    directory 'test'
    template_name 'coffee'
    file '.gitignore'
  end

end
