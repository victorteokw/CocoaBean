#= require application_delegate

# Full-fleaged application
CB.run(CB.Application, <%= @module %>.ApplicationDelegate)

# Simple application
# CB.run ->
#   controller = new <%= @module %>.ViewController()
#   CB.Window.currentWindow().rootViewController = controller
