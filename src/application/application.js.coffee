# Documentation needed
class CB.Application extends Object

  constructor: () ->
    @__i = 0

  @sharedApplication: () ->
    @__shared ||= new CB.Application
    return @__shared

  # The application delegate
  @property "delegate"

  @property "keyWindow" # readonly
  @property "windows" # readonly, unused

  finishLaunchingWithInfo: () ->
    return

# Documentation needed
class CB.ApplicationDelegate extends Object
  constructor: () ->
    @__i = 0

  # Documentation needed
  applicationWillFinishLaunchingWithOptions: (options) ->
    return
  # Documentation needed
  applicationDidFinishLaunchingWithOptions: (options) ->
    return



# CB.Run(application: object, delegate: object, arguments: [])
CB.Run = (options) ->
  if typeof options == 'function'
    $(document).ready ->
      options()
  else if typeof options == 'object'
    options.application ||= new CB.Application()
    CB.Application.__shared = options.application
    app = CB.Application.sharedApplication()
    app.delegate = options.delegate
    $(document).ready ->
      app.delegate.applicationWillFinishLaunchingWithOptions()
      app.finishLaunchingWithInfo()
      app.delegate.applicationDidFinishLaunchingWithOptions()
