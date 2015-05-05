namespace :dist do
  namespace :web do
    task :all, :app_source, :web_source, :ass_source, :dest do |t, args|
      # Rake::Task["gen:app:web:all"].invoke(args)
      CocoaBean::Task.invoke("gen:app:web:all", *args)
    end
  end
end
