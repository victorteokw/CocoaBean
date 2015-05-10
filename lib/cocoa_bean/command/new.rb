module CocoaBean
  class Command
    class New < Command

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
        @lang = argv.option('lang') || CocoaBean::Preferences.instance.lang || 'es6'
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
        CocoaBean::Task.invoke("gen:proj:base:all",
                               @lang,
                               absolute_app_path)
        CocoaBean::Task.invoke("gen:proj:assets:all",
                               absolute_app_path)
        if @web
          web_path = File.expand_path("web", absolute_app_path)
          CocoaBean::Task.invoke("gen:proj:web:all",
                                 web_path,
                                 absolute_app_path)
        end
      end

      # TODO: remove
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

    end
  end
end
