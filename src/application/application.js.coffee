# The Application class.
#
# To reference the application singleton, use CB.Application.sharedApplication
#
class CB.Application extends CB.Responder
  # Constructor of CB.Application
  # Don't create application instance yourself
  # Use CB.Application.sharedApplication instead
  #
  constructor: () ->
    super()
    return

  # The singleton instance that represents this current running application.
  #
  @sharedApplication: () ->
    @__shared ||= new CB.Application
    return @__shared

  # The application's delegate
  #
  @property "readonly", "delegate"

  # The application's key window
  #
  @property "readonly", "keyWindow",
    get: () ->
      return CB.Window.currentWindow()


  # The windows of this applications
  #
  @property "readonly", "windows",
    get: () ->
      return [CB.Window.currentWindow()]

  # This is currently unused
  #
  finishLaunchingWithInfo: () -> return

  @property "webTitle",
    set: (newValue) ->
      document.title = newValue
    get: ->
      document.title

  nextResponder: () ->
    null

# The application delegate class.
#
class CB.ApplicationDelegate

  constructor: () ->
    return

  # This is currently unused,
  # use applicationDidFinishLaunchingWithOptions instead.
  applicationWillFinishLaunchingWithOptions: (options) ->
    return

  applicationDidFinishLaunchingWithOptions: (options) ->
    return

CB.__constructWebLaunchingArguments = () ->
  options_argument =
    path: CB.Pather.sharedPather().currentPath()
  return options_argument


# CB.Run(application: object, delegate: object, arguments: [])
CB.Run = (user_options) ->
  options_argument = CB.__constructWebLaunchingArguments()
  if typeof user_options == 'function'
    $(document).ready ->
      CB.Application.sharedApplication.delegate = new CB.ApplicationDelegate
      user_options(options_argument)
  else if typeof user_options == 'object'
    unless user_options.delegate
      throw CB.ArgumentError("The object you passed into CB.Run should have a delegate object.")
    user_options.application ||= new CB.Application()
    CB.Application.__shared = user_options.application
    app = CB.Application.sharedApplication()
    app._delegate = user_options.delegate
    $(document).ready ->
      app.delegate.applicationWillFinishLaunchingWithOptions(options_argument)
      app.finishLaunchingWithInfo()
      app.delegate.applicationDidFinishLaunchingWithOptions(options_argument)
  else
    throw CB.ArgumentError("CB.Run should receive an object or function.")
