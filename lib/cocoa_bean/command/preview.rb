module CocoaBean
  class Command
    class Preview < Command
      self.summary = 'Preview an cocoa bean application'

      self.description = <<-DESC
        Open web browser or iOS simulator to see and debug the application.\n
      DESC

      self.arguments = [CLAide::Argument.new('PLATFORM', true)]

      beanfile_required!
      validate_platform!

      def initialize(argv)
        super
        @platform = argv.shift_argument
      end

      def run
        temp = @app.full_path(@app.temporary_directory)
        app_source = @app.full_path(@app.code_location)
        web_source = @app.full_path(@app.get_platform(@platform).code_location)
        ass_source = @app.full_path(@app.assets_location)
        CocoaBean::Task.invoke("prev:#@platform:all",
                               temp,
                               app_source,
                               web_source,
                               ass_source)
      end

    end
  end
end
