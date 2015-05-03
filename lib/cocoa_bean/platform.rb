module CocoaBean
  class Platform
    def initialize(name)
      @name = name.to_s
    end

    attr_reader :name
    attr_accessor :readable_name
    attr_accessor :supported

    attr_accessor :distribution_directory
    attr_accessor :code_location

    def to_s
      "#<CocoaBean::Platform:\n
@name=#@name\n@readable_name=#@readable_name\n
@distribution_directory=#@distribution_directory\n@supported=#@supported\n
@code_location=#@code_location"
    end

  end
end
