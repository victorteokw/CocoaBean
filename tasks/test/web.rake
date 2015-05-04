require 'coffee_script'
require 'babel/transpiler'

namespace :test do
  namespace :web do
    task :all, :test_source, :temp_dir do |t, args|
      Rake::Task["test:web:create_temp_test_directory"].invoke(args[:temp_dir])
      Rake::Task["test:web:generate_plain_javascript_test_files"].invoke(args[:test_source], args[:temp_dir])
      Rake::Task["test:web:invoke_test"].invoke(args[:temp_dir])
    end

    task :create_temp_test_directory, :temp_dir do |t, args|
      temp_test_dir = File.expand_path('test', args[:temp_dir])
      directory temp_test_dir
      Rake::Task[temp_test_dir].invoke
    end

    task :generate_plain_javascript_test_files, :test_source, :temp_dir do |t, args|
      dest_test_dir = File.expand_path('test', args[:temp_dir])
      coffee_files = Rake::FileList.new(File.expand_path("**/*.coffee", args[:test_source]))
      es6_files = Rake::FileList.new(File.expand_path("**/*.es6", args[:test_source]))
      all_files = Rake::FileList.new(File.expand_path("**/*", args[:test_source]))
      other_files = all_files - es6_files - coffee_files

      coffee_files.each do |s|
        target = s.gsub(args[:test_source], dest_test_dir).gsub('.coffee', '.js').gsub('.js.js', '.js')
        file target => s do
          File.write(target, CoffeeScript.compile(File.read(s)))
        end
        dirname = File.dirname(target)
        directory dirname
        Rake::Task[dirname].invoke
        Rake::Task[target].invoke
      end
      es6_files.each do |s|
        target = s.gsub(args[:test_source], dest_test_dir).gsub('.es6', '.js').gsub('.js.js', '.js')
        file target => s do
          File.write(target, Babel::Transpiler.transform(File.read(s)))
        end
        dirname = File.dirname(target)
        directory dirname
        Rake::Task[dirname].invoke
        Rake::Task[target].invoke
      end
      other_files.each do |s|
        target = s.gsub(args[:test_source], dest_test_dir)
        file target => s do
          sh "cp #{s} #{target}"
        end
        dirname = File.dirname(target)
        directory dirname
        Rake::Task[dirname].invoke
        Rake::Task[target].invoke
      end
    end

    task :invoke_test, :temp_dir do |t, args|
      require 'jasmine'
      require 'jasmine/config'
      require 'json'
      Jasmine.configure do |conf|
        # Temporarily hard code
        conf.src_dir = File.expand_path('../dist/web', args[:temp_dir])
        conf.spec_dir = File.expand_path('test', args[:temp_dir])
        conf.src_files = lambda {Dir[File.expand_path("**/*.js", conf.src_dir)]}
        conf.spec_files = lambda {Dir[File.expand_path("**/*[sStT][pe][es][ct].js", conf.spec_dir)]}
      end
#      ci_runner = Jasmine::CiRunner.new(Jasmine.config)
#      exit(1) unless ci_runner.run
      config = Jasmine.config
      port = config.port(:server)
      server = Jasmine::Server.new(port, Jasmine::Application.app(Jasmine.config), config.rack_options)
      puts "your server is running here: http://localhost:#{port}/"
      puts "your tests are here:         #{config.spec_dir}"
      puts "your source files are here:  #{config.src_dir}"
      puts ''
      server.start
    end
  end
end
