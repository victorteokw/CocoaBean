#= require <%= @module_name %>
#= require view
#= require view_controller

class ApplicationDelegate
  applicationDidFinishLaunchingWithOptions: (options) ->
    controller = new <%= @module %>.ViewController()
    CB.Window.currentWindow().rootViewController = controller
