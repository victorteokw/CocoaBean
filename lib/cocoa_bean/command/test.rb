module CocoaBean
  class Command
    class Test < Command
      self.summary = 'Unit test current cocoabean application'

      self.description = <<-DESC
        This command generates unit test code and run unit test for the CocoaBean application.
      DESC

      def self.options
        [
          ['--browser', 'Use browser instead of ci']
        ].concat(super)
      end

      self.arguments = [CLAide::Argument.new('PLATFORM', true)]

      beanfile_required!
      validate_platform!

      def initialize(argv)
        super
        @platform = argv.shift_argument
        @browser = argv.flag?('browser', false)
      end

      def run
        app_test_source = @app.full_path(@app.test_directory)
        temp = @app.full_path(@app.temporary_directory)
        app_source = @app.full_path(@app.code_location)
        web_source = @app.full_path(@app.get_platform(@platform).code_location)
        ass_source = @app.full_path(@app.assets_location)
        CocoaBean::Task.invoke("test:#@platform:all",
                               app_test_source,
                               temp,
                               @browser,
                               app_source,
                               web_source,
                               ass_source)
      end
    end
  end
end
