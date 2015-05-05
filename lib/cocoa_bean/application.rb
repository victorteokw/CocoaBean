module CocoaBean
  class Application

    class ApplicationCountError < RuntimeError; end
    class PlatformNameError < RuntimeError; end
    class ApplicationRootDirectoryUnsetError < RuntimeError; end

    def initialize
      @platforms = {}
      @code_location = 'app'
      @assets_location = 'assets'
      @distribution_directory = 'dist'
      @temporary_directory = 'tmp'
      @test_directory = "test"
      yield self
    end

    attr_accessor :name
    attr_accessor :version
    attr_accessor :editor

    attr_accessor :code_location
    attr_accessor :assets_location
    attr_accessor :distribution_directory

    attr_accessor :temporary_directory
    attr_accessor :test_directory

    def full_path(relative_path)
      raise ApplicationRootDirectoryUnsetError if !root_directory
      raise ArgumentError.new("relative path should not be nil") if relative_path.nil?
      File.expand_path(relative_path, root_directory)
    end

    def spec_directory
      test_directory
    end

    def spec_directory=(new_value)
      self.test_directory = new_value
    end

    attr_accessor :root_directory

    def platform(name)
      verify_name!(name)
      p = CocoaBean::Platform.new(name)
      p.readable_name = readable_name_for_platform_name(name)
      p.code_location = name.to_s
      p.distribution_directory = 'dist' + '/' + name.to_s
      p.supported = true
      @platforms[name.to_sym] = p
      yield p if block_given?
    end

    def get_platform(name)
      raise "platform name shouldn't be nil!"if name.nil?
      @platforms[name.to_sym]
    end

    def platforms
      @platforms.values
    end

    def supported_platforms
      retVal = platforms.reject do |p|
        p.supported = false
      end
      retVal.map {|p| p.name}
    end

    def to_s
      "#<CocoaBean::Application:\n
@name=#@name\n@version=#@version\n
@code_location=#@code_location\n@assets_location=#@assets_location
@distribution_directory=#@distribution_directory
@editor=#@editor\n@platforms=#@platforms>"
    end

    private

    def verify_name(name)
      ['web'].include?(name.to_s)
      # ['web', 'ios', 'osx', 'and', 'win'].include?(name)
    end

    def verify_name!(name)
      unless verify_name(name)
        raise PlatformNameError
      end
    end

    def readable_name_for_platform_name(name)
      {ios: "iOS", osx: "OS X", web: "Web Browser", and: "Android", win: "Windows"}[name.to_sym]
    end

    public

    class << self
      def all
        ObjectSpace.each_object(self).to_a
      end

      def only_app
        if self.all.count == 1
          self.all.first
        else
          raise ApplicationCountError
        end
      end
    end

  end
end
