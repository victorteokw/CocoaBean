module CocoaBean
  class Application

    class ApplicationCountError < RuntimeError; end

    def initialize
      yield self
    end

    attr_accessor :name
    attr_accessor :version
    attr_accessor :supported_platform
    attr_accessor :editor

    def to_s
      "#<CocoaBean::Application:\n@name=#@name\n@version=#@version\n@supported_platform=#@supported_platform\n@editor=#@editor>"
    end

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
