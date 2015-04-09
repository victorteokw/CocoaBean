module CocoaBean
  class Command
    class Dist < Command
      self.summary = 'generate application.js into target applications'

      self.description = <<-DESC
        This command generate application.js into target applications.
      DESC

      beanfile_required!

      def run
        generate_application_js
      end

      # Duplicate code
      def generate_application_js
        require 'sprockets'
        environment = Sprockets::Environment.new
        environment.append_path('app')
        js = environment['build.js'].to_s
        File.write(File.expand_path('web/application.js', beanfile_directory), js)
        puts "web/application.js generated"
      end
    end
  end
end
