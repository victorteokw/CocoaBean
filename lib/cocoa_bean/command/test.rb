module CocoaBean
  class Command
    class Test < Command
      self.summary = 'Unit test the project'
      self.description = "Unit test the project."

      beanfile_required!

      def run
        puts "Not implemented yet. Test command."
      end
    end
  end
end
