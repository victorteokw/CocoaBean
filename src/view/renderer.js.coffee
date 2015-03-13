class CB.Renderer

  @sharedRenderer: () ->
    @__shared ||= new CHESS.VIEW.Renderer
    return @__shared
