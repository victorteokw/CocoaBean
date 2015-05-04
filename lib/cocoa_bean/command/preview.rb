module CocoaBean
  class Command
    class Preview < Command
      self.summary = 'Preview an cocoa bean application'
      self.description = <<-DESC
        Open web browser or iOS simulator to see and debug the application.\n
      DESC

      self.arguments = [CLAide::Argument.new('PLATFORM', true)]

      beanfile_required!

      def initialize(argv)
        super
        @platform = argv.shift_argument
      end

      def validate!
        super
        help! 'Provide a platform is required.' unless @platform
        help! 'Platform is not supported by this app.' unless @app.supported_platforms.include? @platform
      end

      def run
        generate_application_js
        preview_web
      end

      # Duplicate code
      def generate_application_js
        require 'sprockets'
        environment = Sprockets::Environment.new
        environment.append_path('app')
        js = environment['build.js'].to_s
        File.write(File.expand_path('web/application.js', beanfile_directory), js)
        puts "web/application.js generated"
      end

      def preview_web
        system("open '#{File.expand_path('web/index.html', beanfile_directory)}'")
        puts "Let's preview on web"
      end
    end
  end
end
