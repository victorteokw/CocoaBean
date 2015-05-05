namespace :prev do
  namespace :web do
    task :all, :temp, :app_source, :web_source, :ass_source do |t, args|
      site_location = File.expand_path('web', args[:temp])
      CocoaBean::Task.invoke("gen:app:web:all", args[:app_source], args[:web_source], args[:ass_source], site_location)
      Rake::Task["prev:web:launch"].invoke(site_location)
    end

    task :launch, :site do |t, args|
      require 'webrick'
      server = WEBrick::HTTPServer.new Port: 3000
      server.mount "/", WEBrick::HTTPServlet::FileHandler, args[:site]
      trap('INT') { server.stop }
      server.start
    end
  end
end
