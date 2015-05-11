def build_js(from_dir, build_file_name, to_dir, target_file_name)
  require 'sprockets'
  require 'sprockets/es6'
  target = File.expand_path(target_file_name, to_dir)
  environment = Sprockets::Environment.new
  environment.register_engine('.es6', Sprockets::ES6)
  environment.append_path(from_dir)
  js = environment[build_file_name].to_s
  File.write(target, js)
end

namespace "gen" do
  namespace "app" do
    namespace "web" do

      task "all",
        :app_source, :web_source, :ass_source, :dest do |t, args|
        app_source = args[:app_source]
        web_source = args[:web_source]
        ass_source = args[:ass_source]
        dest = args[:dest]

        invoke "gen:app:web:create dest dir", dest
        invoke "gen:app:web:copy user plat spec code", web_source, dest
        invoke "gen:app:web:gen user app js", app_source, dest
        invoke "gen:app:web:dl jq", dest
        invoke "gen:app:web:gen cb js", dest
        invoke "gen:app:web:cp user assets", ass_source, dest
        invoke "gen:app:web:create image metadata", ass_source, dest
      end

      task "create dest dir", :dest do |t, args|
        dest = args[:dest]

        directory dest do
          UI.happy "destination directory created"
        end.invoke
      end

      task "copy user plat spec code", :source, :dest do |t, args|
        source = args[:source]
        dest = args[:dest]

        did_something = false

        sources = Rake::FileList.new File.expand_path('**/*', source)
        sources.map do |f|
          target = f.gsub(source, dest)
          file target => f do
            if File.directory? f
              sh "mkdir -p #{target}"
            else
              sh "cp #{f} #{target}"
            end
            did_something = true
          end.invoke
        end
      end

      task "gen user app js", :source_dir, :dest do |t, args|
        source_dir = args[:source_dir]
        dest = args[:dest]

        sources = Rake::FileList.new File.expand_path('**/*', source_dir)
        target = File.expand_path('application.js', dest)
        file target => sources do
          build_js source_dir, 'build.js', dest, 'application.js'
          UI.happy "application.js generated"
        end.invoke
      end

      task "dl jq", :dest do |t, args|
        dest = args[:dest]

        jquery_location = File.expand_path('jquery-2.1.3.js', args[:dest])

        file jquery_location do
          require 'open-uri'
          content = open("http://code.jquery.com/jquery-2.1.3.js").read
          File.open(jquery_location, 'w') {|f| f.write(content)}
          UI.happy("jquery-2.1.3.js downloaded")
        end.invoke
      end

      task "gen cb js", :dest do |t, args|
        dest = args[:dest]

        cb_path = File.expand_path('src', CocoaBean::Task.root_directory_of_cocoa_bean)
        sources = Rake::FileList.new(File.expand_path('**/*', cb_path))
        target_name = 'cocoabean-' + CocoaBean::VERSION + '.js'
        target = File.expand_path(target_name, dest)

        file target => sources do
          build_js(cb_path, 'build.js', dest, target_name)
          UI.happy("#{target_name} generated")
        end.invoke
      end

      task "cp user assets", :source, :dest do |t, args|
        source = args[:source]
        dest = args[:dest]

        if File.directory? source
          assets_dir = File.expand_path('assets', dest)
          directory(assets_dir).invoke

          did_something = false

          sources = Rake::FileList.new File.expand_path('**/*', source)
          sources.map do |f|
            target = f.gsub(source, assets_dir)
            file target => f do
              if File.directory?(f)
                sh "mkdir -p #{target}"
              else
                sh "cp #{f} #{target}"
              end
              did_something = true
            end.invoke
          end
          UI.happy "assets copied" if did_something
        end
      end

      task "create image metadata", :source, :dest do |t, args|
        source = args[:source]
        dest = args[:dest]

        require 'fastimage'
        require 'json'

        if File.directory? source
          metadata_target = File.expand_path('imagedata.js', dest)
          all_assets = Rake::FileList.new File.expand_path('**/*', source)
          images = all_assets.select {|f| f.match /\.(jpg|png|bmp|svg)$/ }
          file metadata_target => images do
            doublePixelRatios = images.select { |f| f.match /@2x/ }
            triplePixelRatios = images.select { |f| f.match /@3x/ }
            singlePixelRatios = images - doublePixelRatios - triplePixelRatios

            jash = {}

            images.each do |i|
              if doublePixelRatios.include?(i)
                pixel_ratio = 2
                availability_flag = "@2x"
              elsif triplePixelRatios.include?(i)
                pixel_ratio = 3
                availability_flag = "@3x"
              elsif singlePixelRatios.include?(i)
                pixel_ratio = 1
                availability_flag = "@1x"
              end

              image_file_name = i
              key_name = File.basename(i).sub('@2x', '').sub('@3x', '')
              descriptor = jash[key_name]
              if descriptor
                jash[key_name][availability_flag] = true
                # descriptor[availability_flag] = true
              else
                descriptor = {}
                size = FastImage.size(i)
                descriptor['width'] = (size[0] / pixel_ratio).floor
                descriptor['height'] = (size[1] / pixel_ratio).floor
                descriptor[availability_flag] = true
                jash[key_name] = descriptor
              end
            end

            content = "CB.__ImageMetadata = " + JSON.pretty_generate(jash) + ';'
            File.write(metadata_target, content)

            UI.happy "image metadata file generated"

          end.invoke
        end
      end
    end
  end
end
