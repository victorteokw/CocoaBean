module CocoaBean
  class Command
    class Dist < Command
      self.summary = 'Generate distribution package or product of this cocoabean application'

      self.description = <<-DESC
        This command generates distribution package to directory specified in Beanfile.
        The distribution directory is default to dist/PLATFORM_SHORT_NAME,
        such as dist/web, dist/and, dist/ios
      DESC

      def self.options
        [
          ['--dest', 'The distribution location override the Beanfile value.']
        ].concat(super)
      end

      self.arguments = [CLAide::Argument.new('PLATFORM', true)]

      beanfile_required!

      def initialize(argv)
        super
        @platform = argv.shift_argument
        @destination = argv.option('dest')
      end

      def validate!
        super
        help! 'Provide a platform is required.' unless @platform
        help! 'Platform is not supported by this app.' unless @app.supported_platforms.include? @platform
      end

      def run
        dist = CocoaBean::Distributor.platform_distributor(@platform, @app, @destination)
        dist.distribute
      end
    end
  end
end
