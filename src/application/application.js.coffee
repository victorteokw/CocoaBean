# The Application class.
#
# To reference the application singleton, use CB.Application.sharedApplication
#
class CB.Application
  # Constructor of CB.Application
  # Don't create application instance yourself
  # Use CB.Application.sharedApplication instead
  #
  constructor: () -> return

  # The singleton instance that represents this current running application.
  #
  @sharedApplication: () ->
    @__shared ||= new CB.Application
    return @__shared

  # The application's delegate
  #
  @property "readonly", "delegate"

  # The application's key window
  # It's currently unused, use CB.Window.currentWindow instead
  #
  @property "readonly", "keyWindow"

  # The windows of this applications
  # It's currently unused
  #
  @property "readonly", "windows"

  # This is currently unused
  #
  finishLaunchingWithInfo: () -> return

  @property "webTitle",
    set: (newValue) ->
      document.title = newValue
    get: ->
      document.title


# The application delegate class.
#
class CB.ApplicationDelegate

  constructor: () -> return

  # This is currently unused, use applicationDidFinishLaunchingWithOptions instead.
  applicationWillFinishLaunchingWithOptions: (options) ->
    return

  applicationDidFinishLaunchingWithOptions: (options) ->
    return

# CB.Run(application: object, delegate: object, arguments: [])
CB.Run = (options) ->
  if typeof options == 'function'
    $(document).ready ->
      CB.Application.sharedApplication.delegate = new CB.ApplicationDelegate
      options()
      CB.DebugLog("Finished launching from an function!")
  else if typeof options == 'object'
    options.application ||= new CB.Application()
    CB.Application.__shared = options.application
    app = CB.Application.sharedApplication()
    app._delegate = options.delegate
    $(document).ready ->
      app.delegate.applicationWillFinishLaunchingWithOptions()
      app.finishLaunchingWithInfo()
      app.delegate.applicationDidFinishLaunchingWithOptions()
      CB.DebugLog("Finished launching from an object!")
