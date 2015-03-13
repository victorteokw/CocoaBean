class CB.Application extends Object
  @sharedApplication: () ->
    @__shared ||= new CB.Application
    return @__shared

  @property "delegate"

  @property "keyWindow" # readonly
  @property "windows" # readonly



class CB.ApplicationDelegate extends Object


CB.Run(application: object, delegate: object, arguments: [])

CB.Run = (options) ->
  $(document).ready ->
    options.delegate.appWillLaunch()
    options.application.launch()
    options.delegate.appDidLaunch()
