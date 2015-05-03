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
        begin
          app = CocoaBean::Application.only_app
          editor = app.editor || ENV['VISUAL'] || ENV['EDITOR']
          if editor.nil? || editor == ''
            warning_and_exit("You haven't set your favorite editor.")
          end
          system "#{editor} #{Dir.pwd}"
        rescue CocoaBean::Application::ApplicationCountError => e
          warning_and_exit("You should only declare one cocoa bean application in the Beanfile.")
        end
      end

    end
  end
end
