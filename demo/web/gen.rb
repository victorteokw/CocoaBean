require 'sprockets'
environment = Sprockets::Environment.new
environment.append_path '.'
js = environment['main.js'].to_s
File.write('application.js', js)
