module CocoaBean
  class Command
    class About < Command
      require 'colored'

      self.summary = 'Show information about current CocoaBean application'
      self.description = <<-DESC
        This command read and show information from application's 'Beanfile'.
      DESC

      beanfile_required!

      def bold(str)
        if str = str.to_s then str.bold else "" end
      end

      def next_color
        @index ||= 0
        @index = @index + 1
        if @index >= 5
          @index = 0
        end
        @color = ['red', 'green', 'blue', 'magenta', 'cyan']
        return @color[@index]
      end

      def random_color_put(str)
        color = next_color
        puts str.send(color.to_sym)
      end

      def run
        begin
          app = CocoaBean::Application.only_app
          random_color_put "Application name: #{bold(app.name)}"
          random_color_put "Application version: #{bold(app.version)}"
          random_color_put "Primary code location: #{bold(app.code_location)}"
          random_color_put "Assets location: #{bold(app.assets_location)}"
          random_color_put "Product distribution directory: #{bold(app.distribution_directory)}"
          random_color_put "Editor: #{bold(app.editor)}"
          random_color_put ""
          random_color_put "Platforms:\n"

          app.platforms.each do |p|
            random_color_put "  Platform name: #{bold(p.readable_name)}"
            random_color_put "  Short name: #{bold(p.name)}"
            random_color_put "  Supported: #{bold(p.supported)}"
            random_color_put "  Distribution directory: #{bold(p.distribution_directory)}"
            random_color_put "  Platform specific code location: #{bold(p.code_location)}\n"
          end
        rescue CocoaBean::Application::ApplicationCountError => e
          UserInterface.exit("You should only declare one cocoa bean application.")
        end
      end
    end
  end
end
