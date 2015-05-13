namespace "dist" do
  namespace "web" do
    task "all",
      :app_source, :web_source, :ass_source, :dest do |t, args|
      invoke "gen:app:web:all", *args, false
    end
  end
end
