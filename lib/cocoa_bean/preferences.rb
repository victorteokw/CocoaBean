module CocoaBean
  class Preferences
    def initialize
      yield self if block_given?
    end

    attr_accessor :editor

    attr_accessor :lang

    def self.all
      ObjectSpace.each_object(self).to_a
    end

    def self.only_one
      self.all.first
    end

    def self.instance
      the_file = File.expand_path('~/.cocoabeanrc', 'abc')
      if File.exist? the_file
        load the_file
        return self.only_one || self.new
      else
        return self.new
      end
    end
  end
end
