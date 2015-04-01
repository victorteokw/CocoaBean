module CocoaBean
  class Command
    class About < Command
      self.summary = 'Show information about this project'
      self.description = <<-DESC
        This command read and show information from application's 'Beanfile'.
      DESC

      def validate!
        help! 'You should run this command inside a cocoa bean application.' unless beanfile_location
      end

      def run
        load beanfile_location
        begin
          puts CocoaBean::Application.only_app
        rescue CocoaBean::Application::ApplicationCountError => e
          puts "You should only declare one cocoa bean application."
          exit 1
        end
      end
    end
  end
end
