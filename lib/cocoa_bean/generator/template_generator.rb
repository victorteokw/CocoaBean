module CocoaBean

  class TemplateGenerator < Generator

    class DirectoryExistError < RuntimeError; end
    class FileExistError < RuntimeError; end
    class TemplateSourceNotExistError < RuntimeError; end

    require 'pathname'
    require 'fileutils'

    attr_accessor :template

    def initialize(options = {})
      super
      self.destination = options[:destination]
      self.template = options[:template]
      @@template_paths ||= []
    end

    def template_paths
      if @@template_paths.empty?
        tem = File.expand_path('../../../../templates', __FILE__)
        # require 'rubygems'
        # spec = Gem::Specification.find_by_name("cocoabean")
        # gem_root = spec.gem_dir
        # gem_root += "/templates"
        # @@template_paths = [gem_root]
        @@template_paths = [tem]
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
      if location
        location = File.expand_path(template, location) if location
      else
        raise TemplateSourceNotExistError
      end
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
      require 'erb'
      raise FileExistError if File.exist?(to)
      renderer = ERB.new(File.read(from))
      File.write(to, renderer.result(binding))
      output_create_file(to)
    rescue FileExistError => e
      UserInterface.exit("File #{to} exists! Cannot generate new application.")
    end

    def copy_file(from, to)
      raise FileExistError if File.exist?(to)
      FileUtils::cp(from, to)
      output_create_file(to)
    rescue FileExistError => e
      UserInterface.exit("File #{to} exists! Cannot generate new application.")
    end

    def create_directory(dir_path)
      raise DirectoryExistError if Dir.exist?(dir_path)
      FileUtils::mkdir_p(dir_path)
      output_create_file(dir_path)
    rescue DirectoryExistError => e
      UserInterface.exit("Directory #{dir_path} exists! Cannot generate new application.")
    end

    def output_create_file(file_or_dir)
      rel = Pathname.new(file_or_dir).relative_path_from(Pathname.new(File.dirname(destination))).to_s
      color = "created".green.bold
      puts "    #{color} #{rel}"
    end
  end
end
