namespace "preview" do
  namespace "web" do
    task "all",
      :web_dir, :app_source, :web_source, :ass_source do |t, args|
        web_dir = args[:web_dir]
        app_source = args[:app_source]
        web_source = args[:web_source]
        ass_source = args[:ass_source]

        invoke "gen:app:web:all", app_source, web_source, ass_source, web_dir
        invoke "preview:web:launch", web_dir
    end

    task "launch", :web_dir do |t, args|
      web_dir = args[:web_dir]

      require 'webrick'
      server = WEBrick::HTTPServer.new Port: 3000
      server.mount "/", WEBrick::HTTPServlet::FileHandler, web_dir
      trap('INT') { server.stop }
      server.start
    end
  end
end
