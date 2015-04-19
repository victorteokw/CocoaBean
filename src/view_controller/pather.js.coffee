class CB.Pather
  constructor: () -> return
  @sharedPather: () ->
    @__shared ||= new CB.Pather
    return @__shared
  currentPath: (_window) ->
    _window ||= window
    u = _window.location.href
    r = /#.*/
    if u.match(r)
      '/' + u.match(r)[0].substring(1)
    else
      '/'
