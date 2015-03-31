#= require <%= @module_name %>
#= require view
#= require view_controller

class ApplicationDelegate extends CB.ApplicationDelegate
  applicationDidFinishLaunchingWithOptions: (options) ->
    controller = new <%= @module %>.ViewController()
    CB.Window.currentWindow().rootViewController = controller
