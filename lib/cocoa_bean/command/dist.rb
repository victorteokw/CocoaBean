module CocoaBean
  class Command
    class Dist < Command
      self.summary = 'Generate distribution package or product of this cocoabean application'

      self.description = <<-DESC
        This command generates distribution package to directory specified in Beanfile.
        The distribution directory is default to dist/PLATFORM_SHORT_NAME,
        such as dist/web, dist/and, dist/ios.
        If platform is web, the generation is an static html page with some javaScript files.
        If platform is ios, the generation is an app package.
      DESC

      def self.options
        [
          ['--dest', 'The distribution location override the Beanfile value']
        ].concat(super)
      end

      self.arguments = [CLAide::Argument.new('PLATFORM', true)]

      beanfile_required!
      validate_platform!

      def initialize(argv)
        super
        @platform = argv.shift_argument
        dest = argv.option('dest')
        if dest
          @destination = @app.full_path(dest)
        else
          @destination = @app.full_path(@app.get_platform(@platform).distribution_directory)
        end
      end

      def run
        app_source = @app.full_path(@app.code_location)
        web_source = @app.full_path(@app.get_platform(@platform).code_location)
        ass_source = @app.full_path(@app.assets_location)
        CocoaBean::Task.invoke("dist:#@platform:all",
                               app_source,
                               web_source,
                               ass_source,
                               @destination)
      end
    end
  end
end
