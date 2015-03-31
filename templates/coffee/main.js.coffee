#= require application_delegate

# Full-fleaged application
CB.run(application: CB.Application, delegate: <%= @module %>.ApplicationDelegate)

# Simple application
# CB.run ->
#   controller = new <%= @module %>.ViewController()
#   CB.Window.currentWindow().rootViewController = controller
