def build_js(from_dir, build_file_name, to_dir, target_file_name)
  require 'sprockets'
  target = File.expand_path(target_file_name, to_dir)
  environment = Sprockets::Environment.new
  environment.append_path(from_dir)
  js = environment[build_file_name].to_s
  File.write(target, js)
end
