module CocoaBean
  class Command
    class Open < Command
      self.summary = <<-SUMM
Open cocoa bean application in your favorite text editor
      SUMM

      self.description = <<-DESC
This commmand open the editor specified by 'Beanfile'.
      DESC

      beanfile_required!

      def run
        load beanfile_location
        begin
          app = CocoaBean::Application.only_app
          editor = app.editor || ENV['VISUAL'] || ENV['EDITOR']
          if editor.nil? || editor == ''
            puts "You haven't set your favorite editor."
            exit 1
          end
          system "#{editor} #{Dir.pwd}"
        rescue CocoaBean::Application::ApplicationCountError => e
          puts "You should only declare one cocoa bean application in the Beanfile."
          exit 1
        end
      end

    end
  end
end
