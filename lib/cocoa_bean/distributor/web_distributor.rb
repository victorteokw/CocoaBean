module CocoaBean
  class Distributor
    class WebDistributor < CocoaBean::Distributor
      require 'fileutils'
      def initialize(app, destination)
        super
        @platform = 'web'
        @destination = self.absolutefy_destination(destination) || self.absolute_platform_destination
      end

      def distribute
        return true if create_dir && copy_jquery && copy_cocoabean_js && copy_platform_code && generate_application_js && copy_assets
        return false
      end

      private

      def create_dir
        FileUtils.mkdir_p @destination
        true
      end

      def copy_platform_code
        FileUtils.cp_r platform_code_location + '/.', @destination
        puts "copied custom platform code"
        true
      end

      def generate_application_js
        require 'sprockets'
        environment = Sprockets::Environment.new
        environment.append_path(absolute_code_location)
        js = environment['build.js'].to_s
        File.write(File.expand_path('application.js', @destination), js)
        puts "generated application js"
        true
      end

      def copy_jquery
        jquery_location = @destination + '/jquery-2.1.3.js'
        return true if File.exist? jquery_location
        require 'open-uri'
        content = open("http://code.jquery.com/jquery-2.1.3.js").read
        File.open(jquery_location, 'w') {|f| f.write(content) }
        puts "copied jquery"
        true
      end

      def copy_cocoabean_js
        puts "copied cocoabean not implemented"
        true
      end

      def copy_assets
        puts "copy assets not implemented"
        true
      end
    end
  end
end
