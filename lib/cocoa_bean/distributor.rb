module CocoaBean
  class Distributor
    require 'cocoa_bean/distributor/web_distributor'
    def initialize(app, destination)
      @app = app

    end

    def absolute_code_location
      File.expand_path(@app.code_location, @app.root_directory)
    end

    def absolute_destination
      File.expand_path(@destination, @app.root_directory)
    end

    def absolutefy_destination(destination)
      File.expand_path(destination, @app.root_directory) if destination
    end

    def absolute_platform_destination
      p = @app.get_platform(@platform)
      File.expand_path(p.distribution_directory, @app.root_directory)
    end

    def platform_code_location
      p = @app.get_platform(@platform)
      File.expand_path(p.code_location, @app.root_directory)
    end

    def distribute
      raise "Abstract distributor cannot distribute!"
    end

    def self.platform_distributor(platform_name, app, destination)
      case platform_name.to_s
      when 'web'
        CocoaBean::Distributor::WebDistributor.new(app, destination)
      # when 'ios'
      #   CocoaBean::Distributor::Ios.new(app, destination)
      # when 'osx'
      #   CocoaBean::Distributor::Osx.new(app, destination)
      # when 'and'
      #   CocoaBean::Distributor::And.new(app, destination)
      # when 'win'
      #   CocoaBean::Distributor::Win.new(app, destination)
      else
        raise "Platform #{platform_name} is not supported yet."
      end
    end
  end
end
