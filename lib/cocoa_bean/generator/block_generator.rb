module CocoaBean
  class BlockGenerator < Generator

    def initialize options = nil, &block
      @options = options
      @block = block
    end

    def generate
      super
      @block.call(destination, @options)
    end
  end
end
