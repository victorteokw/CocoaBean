namespace :dist do
  namespace :web do
    task :all, :app_source, :web_source, :ass_source, :dest do |t, args|
      Rake::Task["dist:web:create_destination_directory"].invoke(args[:dest])
      Rake::Task["dist:web:copy_user_platform_specific_code"].invoke(args[:web_source], args[:dest])
      Rake::Task["dist:web:generate_user_application_js"].invoke(args[:app_source], args[:dest])
      Rake::Task["dist:web:download_a_copy_of_jquery"].invoke(args[:dest])
      Rake::Task["dist:web:generate_cocoabean_js"].invoke(args[:dest])
      Rake::Task["dist:web:copy_user_assets"].invoke(args[:ass_source], args[:dest])
    end

    task :create_destination_directory, :dest do |t, args|
      directory args[:dest]
      Rake::Task[args[:dest]].invoke
    end

    task :copy_user_platform_specific_code, :source, :dest do |t, args|
      sources = Rake::FileList.new(File.expand_path('**/*', args[:source]))
      sources.map do |s|
        target = s.gsub(args[:source], args[:dest])
        file target => s do
          sh "cp #{s} #{target}"
        end
        Rake::Task[target].invoke
      end
    end

    task :generate_user_application_js, :source, :dest do |t, args|
      require 'sprockets'
      sources = Rake::FileList.new(File.expand_path('**/*', args[:source]))
      target = File.expand_path('application.js', args[:dest])
      file target => sources do
        environment = Sprockets::Environment.new
        environment.append_path(args[:source])
        js = environment['build.js'].to_s
        File.write(target, js)
      end
      Rake::Task[target].invoke
    end

    task :download_a_copy_of_jquery, :dest do |t, args|
      jquery_location = File.expand_path('jquery-2.1.3.js', args[:dest])
      file jquery_location do
        require 'open-uri'
        content = open("http://code.jquery.com/jquery-2.1.3.js").read
        File.open(jquery_location, 'w') {|f| f.write(content)}
      end
      Rake::Task[jquery_location].invoke
    end

    task :generate_cocoabean_js, :dest do |t, args|

    end

    task :copy_user_assets, :source, :dest do |t, args|
      assets_from = File.expand_path('assets', args[:source])
      if File.exist? assets_from
        sources = Rake::FileList.new(File.expand_path('**/*', args[:source]))
        sources.map do |s|
          target = s.gsub(args[:source], File.expand_path('assets', args[:dest]))
          file target => s do
            sh "cp #{s} #{target}"
          end
          Rake::Task[target].invoke
        end
      end
    end
  end
end
