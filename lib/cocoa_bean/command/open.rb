module CocoaBean
  class Command
    class Open < Command
      self.summary = <<-SUMM
Open an cocoa bean application in your favorite text editor.
      SUMM

      self.description = <<-DESC
        Show information about this project.
      DESC

      def run
        puts "command open not implemented yet."
      end

    end
  end
end
