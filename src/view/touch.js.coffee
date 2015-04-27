class CB.Touch
  @property "readonly", "locationInWindow"
  @property "readonly", "previousLocationInWindow"

  @property "readonly", "view"
  @property "readonly", "window"

  @property "readonly", "timestamp"

  locationInView: (view) ->
    CB.Window.currentWindow.convertPointToView(@locationInWindow, view)

  previousLocationInView: (view) ->
    CB.Window.currentWindow.convertPointToView(@previousLocationInWindow, view)
