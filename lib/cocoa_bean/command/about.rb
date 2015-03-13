module CocoaBean
  class Command
    class About < Command
      self.summary = 'Show information about this project.'
      self.description = <<-DESC
        Show information about this project.
      DESC

      def run
        puts "information haha nice."
      end
    end
  end
end
