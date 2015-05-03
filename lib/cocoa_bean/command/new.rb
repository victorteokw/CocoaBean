module CocoaBean
  class Command
    class New < Command

      require 'cocoa_bean/generator/template_generator'

      self.summary = 'Generate a cocoa bean project'
      self.description = <<-DESC
This command generates a cocoa bean project.
      DESC

      self.arguments = [CLAide::Argument.new('APP_PATH', true)]

      def self.options
        [
          ['--web', 'Indicate this application is intended for web platform'],
          ['--ios', 'Indicate this application is intended for iOS platform'],
          ['--osx', 'Indicate this application is intended for OS X platform'],
          ['--lang=[coffee|es6]', 'The language to use']
# ['--android', 'Indicate this application is intended for Android platform.']
        ].concat(super)
      end

      def initialize(argv)
        super
        %w{web ios osx}.each do |platform_name|
          instance_eval %Q(
            @#{platform_name} = argv.flag? '#{platform_name}', true
          )
        end
        @lang = argv.option('lang', 'es6')
        @app_path = argv.shift_argument
      end

      def validate!
        super
        if @lang && !%w(coffee es6).include?(@lang)
          help! "`#{@lang}' is not a valid language."
        end
        if !@app_path
          help! "Please provide where to generate the application."
        end
      end

      def run
        absolute_app_path = File.expand_path(@app_path, Dir.pwd)
        generate_main_project(absolute_app_path)
        if true
          generate_web_project(absolute_app_path)
        end
        if true
          generate_cocoa_project(absolute_app_path)
          generate_ios_target(absolute_app_path)
          generate_osx_target(absolute_app_path)
        end
      end

      def generate_main_project(app_path)
        generator = CocoaBean::TemplateGenerator.new
        generator.template = @lang
        generator.destination = app_path
#        generator.app_name = File.basename(app_path)
        generator.generate
      end

      def generate_web_project(app_path)
        generator = CocoaBean::TemplateGenerator.new
        generator.template = "web"
        generator.destination = app_path
        generator.generate
      end

      def generate_cocoa_project(app_path)
        file_generator = CocoaBean::TemplateGenerator.new
        file_generator.template = "cocoa"
        file_generator.destination = app_path
        file_generator.generate
        require 'xcodeproj'
        cocoa_dir = File.expand_path('cocoa', app_path)
        Dir.mkdir(cocoa_dir) unless Dir.exist?(cocoa_dir)
        proj = ::Xcodeproj::Project.new(File.expand_path(File.basename(app_path) + '.xcodeproj', cocoa_dir))
        proj.save

      end

      def generate_ios_target(app_path)
      end

      def generate_osx_target(app_path)
      end
    end
  end
end
