module CocoaBean
  require 'cocoa_bean/generator'
  class TemplateGenerator < Generator

    class DirectoryExistError < RuntimeError; end
    class FileExistError < RuntimeError; end
    class TemplateSourceNotExistError < RuntimeError; end

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
      absolute_file = File.expand_path(file_name, base_directory)
      raise FileExistError if File.exist?(absolute_file)
      source_to_copy_from = File.expand_path(file_name, File.expand_path(self.class.template_name, self.class.templates_directory)) + '.erb'
      target_to_copy_to = absolute_file
      raise TemplateSourceNotExistError unless File.exist?(source_to_copy_from)
      require 'erb'
      renderer = ERB.new(source_to_copy_from)
      File.write(target_to_copy_to, renderer.result)
    rescue FileExistError => e
      puts "[!] File #{absolute_file} exists! Cannot generate new application."
      exit 1
    rescue TemplateSourceNotExistError => e
      puts "[!] Template source #{source_to_copy_from} does not exist! Cannot generate new application."
      exit 1
    end

    def process_directory(directory_name)
      super
      absolute_directory = File.expand_path(directory_name, base_directory)
      raise DirectoryExistError if Dir.exist?(absolute_directory)
      Dir.mkdir(absolute_directory)
    rescue DirectoryExistError => e
      puts "[!] Directory #{absolute_directory} exists! Cannot generate new application."
      exit 1
    end

    class << self
      def templates_directory
        require 'rubygems'
        spec = Gem::Specification.find_by_name("cocoabean")
        gem_root = spec.gem_dir
        gem_root + "/templates"
      end

      def template_name(template_name = nil)
        return @template_name if !template_name
        @template_name = template_name
      end
    end
  end

  class CoffeeTemplateGenerator < TemplateGenerator
    directory 'app'
    file "app/build.#{template_name}"
    file "app/header.#{template_name}"
    file "app/main.#{template_name}"
    directory 'app/application'
    file "app/application/application_delegate.#{template_name}"
    directory 'app/model'
    directory 'app/view'
    file "app/view/sample_view.#{template_name}"
    directory 'app/view_controller'
    file "app/view_controller/sample_view_controller.#{template_name}"
    directory 'cocoa'
    directory 'test'
    file '.gitignore'
    file 'Beanfile'

    template_name 'coffee'
  end

  class ES6TemplateGenerator < TemplateGenerator
    template_name 'es6'
    directory 'app'
    file "app/build.js.#{template_name}"
    file "app/header.js.#{template_name}"
    file "app/main.js.#{template_name}"
    directory "app/application"
    file "app/application/application_delegate.js.#{template_name}"
    directory "app/model"
    directory "app/view"
    file "app/view/sample_view.js.#{template_name}"
    directory "app/view_controller"
    file "app/view_controller/sample_view_controller.js.#{template_name}"
    directory "cocoa"
    directory "test"
    file ".gitignore"
  end

end
