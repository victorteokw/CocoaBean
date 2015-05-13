namespace "test" do
  namespace "web" do
    task "all",
      :test_source, :temp_dir, :use_browser, :app_source, :web_source, :ass_source do |t, args|

      test_source = args[:test_source]
      temp_dir = args[:temp_dir]
      use_browser = args[:use_browser]
      app_source = args[:app_source]
      web_source = args[:web_source]
      ass_source = args[:ass_source]
      web_dir = File.expand_path('web', temp_dir)
      test_dir = File.expand_path('test', temp_dir)

      invoke "gen:app:web:all", app_source, web_source, ass_source, web_dir, true
      invoke "test:web:create temp test directory", temp_dir
      invoke "test:web:generate plain javascript test files", test_source, temp_dir
      invoke "test:web:invoke test", temp_dir, use_browser, web_dir

    end

    task "create temp test directory", :test_dir do |t, args|
      test_dir = args[:test_dir]

      directory test_dir do
        UI.happy "Testing directory created"
      end
    end

    task "generate plain javascript test files", :test_source, :test_dir do |t, args|
      test_source = args[:test_source]
      test_dir = args[:test_dir]

      require 'coffee_script'
      require 'babel/transpiler'

      did_something = false

      all_files = Rake::FileList.new File.expand_path("**/*", test_source)
      all_files.each do |f|

        if File.directory? f

          target = f.gsub(test_source, test_dir)
          directory target do
            did_something = true
          end.invoke

        elsif f.end_with? 'coffee'

          target = f.gsub(test_source, test_dir).gsub('.coffee', '.js').gsub('.js.js', '.js')
          file target => f do
            File.write target, CoffeeScript.compile(File.read(f))
            did_something = true
          end.invoke

        elsif f.end_with? 'es6'

          target = f.gsub(test_source, test_dir).gsub('.es6', '.js').gsub('.js.js', '.js')
          file target => f do
            File.write target, Babel::Transpiler.transform(File.read(f))
            did_something = true
          end.invoke

        else

          target = f.gsub(test_source, test_dir)
          file target => f do
            sh "cp #{s} #{target}"
            did_something = true
          end.invoke

        end
      end

      UI.happy "test files generated" if did_something
    end

    task "invoke test", :temp_dir, :use_browser, :web_dir do |t, args|
      temp_dir = args[:temp_dir]
      use_browser = args[:use_browser]
      web_dir = args[:web_dir]

      require 'jasmine'
      require 'jasmine/config'
      require 'json'

      Jasmine.configure do |conf|
        conf.src_dir = web_dir
        source_files = Dir[File.expand_path("**/*.js", temp_dir)]
        application_js = source_files.find {|f| f.match(/application/) }
        source_files.delete(application_js)
        source_files.push(application_js)
        conf.src_files = lambda { source_files }
        conf.spec_dir = File.expand_path('test', temp_dir)
        spec_files = Dir[File.expand_path("**/*[sStT][pe][es][ct].js", conf.spec_dir)]
        conf.spec_files = lambda { spec_files }
      end

      if use_browser
        config = Jasmine.config
        port = config.port(:server)
        server = Jasmine::Server.new(port, Jasmine::Application.app(Jasmine.config),
          config.rack_options)
        UI.happy "Open http://localhost:#{port}/ with browser to watch test running"
        server.start
      else
        ci_runner = Jasmine::CiRunner.new(Jasmine.config)
        exit(1) unless ci_runner.run
      end

    end
  end
end
