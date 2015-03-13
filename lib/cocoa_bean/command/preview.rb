module CocoaBean
  class Command
    class Preview < Command
      self.summary = 'Preview Project.'
      self.description = <<-DESC
        Preview this Project.\n
        PLATFORM should be one of 'native' and 'web'.
      DESC

      self.arguments = [CLAide::Argument.new('PLATFORM', true)]

      def initialize(argv)
        super
        @platform = argv.shift_argument
      end

      def validate!
        help! 'Provide a platform is required.' unless @platform
        help! 'Platform should be either web or native.' unless ['web', 'native'].include? @platform
      end

      def run
        puts "preview command #@platform "
      end

    end
  end
end
