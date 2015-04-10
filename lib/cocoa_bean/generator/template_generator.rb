module CocoaBean

  class TemplateGenerator < Generator

    class DirectoryExistError < RuntimeError; end
    class FileExistError < RuntimeError; end

    attr_accessor :destination
    attr_accessor :template

    def initialize(options = {})
      super
      self.destination = options[:destination]
      self.template = options[:template]
      @@template_paths ||= []
    end

    def template_paths
      if @@template_paths.empty?
        require 'rubygems'
        spec = Gem::Specification.find_by_name("cocoabean")
        gem_root = spec.gem_dir
        gem_root += "/templates"
        @@template_paths = [gem_root]
      end
      return @@template_paths
    end

    def generate_instance_variable_for_erb
      @author_name = ENV['USER']
      @created_at = Time.now.strftime("%d/%m/%Y %H:%M")
      @created_year = Time.now.strftime("%Y")
      @module_name = File.basename(destination).upcase
      @app_name = File.basename(destination)
    end

    def ignore_list
      [".", "..", ".DS_Store"]
    end

    def source_location
      location = template_paths.find {|p| File.exist?(File.expand_path(template, p)) }
      location = File.expand_path(template, location)
      raise TemplateSourceNotExistError unless location
      location
    end

    def generate
      super
      generate_instance_variable_for_erb
      files = Dir.glob(File.expand_path('**/*', source_location))
      files.reject! {|f| ignore_list.include?(File.basename(f)) }
      files.each do |f|
        if File.directory?(f)
          create_directory(target_for_source(f))
        elsif File.extname(f) == '.erb'
          process_file(f, target_for_source(f, true))
        else
          copy_file(f, target_for_source(f))
        end
      end
    end

    def relative_path(full_path, prefix = nil)
      prefix ||= source_location
      require 'pathname'
      Pathname.new(full_path).relative_path_from(Pathname.new(prefix)).to_s
    end

    def target_for_source(source_path, remove_erb = false)
      rel = relative_path(source_path)
      if remove_erb
        if File.extname(rel) == ".erb"
          rel = rel.sub(/\.erb$/, '')
        end
      end
      File.expand_path(rel, destination)
    end

    def process_file(from, to)
      puts "Process_file #{to}"
      require 'erb'
      raise FileExistError if File.exist?(to)
      renderer = ERB.new(File.read(from))
      File.write(to, renderer.result(binding))
    rescue FileExistError => e
      warning_and_exit("File #{to} exists! Cannot generate new application.")
    end

    def copy_file(from, to)
      puts "Copy_file #{to}"
      raise FileExistError if File.exist?(to)
      require 'fileutils'
      FileUtils::cp(from, to)
    rescue FileExistError => e
      warning_and_exit("File #{to} exists! Cannot generate new application.")
    end

    def create_directory(dir_path)
      puts "Create_dir #{dir_path}"
      raise DirectoryExistError if Dir.exist?(dir_path)
      require 'fileutils'
      FileUtils::mkdir_p(dir_path)
    rescue DirectoryExistError => e
      warning_and_exit("Directory #{dir_path} exists! Cannot generate new application.")
    end
  end
end
