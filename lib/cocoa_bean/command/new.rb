module CocoaBean
  class Command
    class New < Command

      require 'cocoa_bean/generator/template_generator'

      self.summary = 'Generate a cocoa bean project.'
      self.description = <<-DESC
Generate a cocoa bean project.
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
        generator = case @lang
                    when 'coffee'
                      ::CocoaBean::CoffeeTemplateGenerator.new
                    when 'es6'
                      ::CocoaBean::ES6TemplateGenerator.new
                    end
        generator.destination_directory, generator.app_name = File.split(absolute_app_path)
        generator.template_options = {ios: @ios, osx: @osx, web: @web}
        generator.generate
      end
    end
  end
end
