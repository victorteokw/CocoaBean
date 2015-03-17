#= require view
#= require view_controller

class DEMO.ApplicationDelegate extends CB.ApplicationDelegate
  applicationDidFinishLaunchingWithOptions: (options) ->
    controller = new DEMO.ViewController()
    CB.Window.currentWindow().rootViewController = controller
