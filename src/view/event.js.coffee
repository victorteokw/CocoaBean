class CB.Event

  @property "readonly", "locationInWindow"
  @property "readonly", "previousLocationInWindow"

  @property "readonly", "view"
  @property "readonly", "window"

  @property "readonly", "timestamp"

  @property "readonly", "allTouches"
  @property "readonly", "type"

  locationInView: (view) ->
    CB.Window.currentWindow.convertPointToView(@locationInWindow, view)

  previousLocationInView: (view) ->
    CB.Window.currentWindow.convertPointToView(@previousLocationInWindow, view)
