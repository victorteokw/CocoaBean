class CB.Window

  @currentWindow: () ->
    @__current ||= new CB.Window
    return @__current

  @property "height",
    get: -> $(window).height()

  @property "width",
    get: -> $(window).width()

  @property "rootViewController",
    get: -> @_keyViewController
    set: (vc) -> @_keyViewController = vc; this.__setKeyView(vc.view)

  isLong: () -> this.width <= this.height
  isWide: () -> !this.isLong()

  __setKeyView: (view) ->
   if $("body").length
     $("body").empty()
   view.__loadLayer() # This call has bug
   view.__syncView() # This call may has bug
   view.layout()
   view.show = true
   @_keyView = view
   $(window).off("resize")
   $(window).resize ->
     view.layout()
