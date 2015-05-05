namespace :gen do
  namespace :app do
    namespace :web do

      task :all, :app_source, :web_source, :ass_source, :dest do |t, args|
        Rake::Task["gen:app:web:create_dest_dir"].invoke(args[:dest])
        Rake::Task["gen:app:web:copy_user_plat_spec_code"].invoke(args[:web_source], args[:dest])
        Rake::Task["gen:app:web:gen_user_app_js"].invoke(args[:app_source], args[:dest])
        Rake::Task["gen:app:web:dl_jq"].invoke(args[:dest])
        Rake::Task["gen:app:web:gen_cb_js"].invoke(args[:dest])
        Rake::Task["gen:app:web:cp_user_assets"].invoke(args[:ass_source], args[:dest])
      end

      task :create_dest_dir, :dest do |t, args|
        directory args[:dest]
        Rake::Task[args[:dest]].invoke
      end

      task :copy_user_plat_spec_code, :source, :dest do |t, args|
        sources = Rake::FileList.new(File.expand_path('**/*', args[:source]))
        sources.map do |s|
          target = s.gsub(args[:source], args[:dest])
          file target => s do
            if File.directory?(s)
              sh "mkdir -p #{target}"
            else
              sh "cp #{s} #{target}"
            end
          end
          Rake::Task[target].invoke
        end
      end

      task :gen_user_app_js, :source, :dest do |t, args|
        sources = Rake::FileList.new(File.expand_path('**/*', args[:source]))
        target = File.expand_path('application.js', args[:dest])
        file target => sources do
          build_js(args[:source], 'build.js', args[:dest], 'application.js')
        end
        Rake::Task[target].invoke
      end

      task :dl_jq, :dest do |t, args|
        jquery_location = File.expand_path('jquery-2.1.3.js', args[:dest])
        file jquery_location do
          require 'open-uri'
          content = open("http://code.jquery.com/jquery-2.1.3.js").read
          File.open(jquery_location, 'w') {|f| f.write(content)}
        end
        Rake::Task[jquery_location].invoke
      end

      task :gen_cb_js, :dest do |t, args|
        cb_path = File.expand_path('src', CocoaBean::Task.root_directory_of_cocoa_bean)
        sources = Rake::FileList.new(File.expand_path('**/*', cb_path))
        target_name = 'cocoabean-' + CocoaBean::VERSION + '.js'
        target = File.expand_path(target_name, args[:dest])
        file target => sources do
          build_js(cb_path, 'build.js', args[:dest], target_name)
        end
        Rake::Task[target].invoke
      end

      task :cp_user_assets, :source, :dest do |t, args|
        if File.directory? args[:source]
          assets_dir = File.expand_path('assets', args[:dest])
          directory assets_dir
          Rake::Task[assets_dir].invoke
          sources = Rake::FileList.new(File.expand_path('**/*', args[:source]))
          sources.map do |s|
            target = s.gsub(args[:source], File.expand_path('assets', args[:dest]))
            file target => s do
              if File.directory?(s)
                sh "mkdir -p #{target}"
              else
                sh "cp #{s} #{target}"
              end
            end
            Rake::Task[target].invoke
          end
        end
      end


    end
  end
end
