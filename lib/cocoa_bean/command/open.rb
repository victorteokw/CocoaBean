module CocoaBean
  class Command
    class Open < Command
      self.summary = <<-SUMM
Open cocoa bean application in your favorite text editor
      SUMM

      self.description = <<-DESC
This commmand open the editor specified by 'Beanfile'.
      DESC

      def self.options
        [
          ['--root', 'Open this app under application root directory'],
          ['--editor', 'Use this certain editor']
        ].concat(super)
      end

      beanfile_required!

      def initialize(argv)
        super
        @app = CocoaBean::Application.only_app
        @editor = argv.option('editor') || @app.editor || ENV['VISUAL'] || ENV['EDITOR']
        @root = argv.flag?('root', false)
      end

      def run
        begin
          if @editor.nil? || @editor == ''
            warning_and_exit("You haven't set your favorite editor.")
          end
          if @root
            system "#{@editor} #{beanfile_directory}"
          else
            system "#{@editor} #{Dir.pwd}"
          end
        rescue CocoaBean::Application::ApplicationCountError => e
          warning_and_exit("You should only declare one cocoa bean application in the Beanfile.")
        end
      end

    end
  end
end
