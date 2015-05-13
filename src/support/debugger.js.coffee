window.onerror = (msg, url, line, col, error) ->
  if !@debuggerView
    @debuggerView = new CB.DebuggerView
    CB.Window.currentWindow().addSubview(@debuggerView)
  @debuggerView.addEntry(msg, url, line, col, error)
  @debuggerView.hidden = false
