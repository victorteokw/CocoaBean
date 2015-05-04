module CocoaBean
  class Command
    class Test < Command
      self.summary = 'Unit test current cocoabean application'

      self.description = <<-DESC
        This command generates unit test code and run unit test for the CocoaBean application.
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
        app_test_source = File.expand_path(@app.test_directory, @app.root_directory)
        temp = File.expand_path(@app.temporary_directory, @app.root_directory)
        CocoaBean::Task.invoke("test:#@platform:all", app_test_source, temp)
      end
    end
  end
end
