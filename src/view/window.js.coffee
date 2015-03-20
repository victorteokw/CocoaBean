class CB.Window extends CB.View

  @currentWindow: () ->
    @__current ||= new CB.Window
    return @__current

  @property "height",
    get: -> $(window).height()

  @property "width",
    get: -> $(window).width()

  @property "rootViewController",
    get: -> @_rootViewController
    set: (vc) -> @_rootViewController = vc; this.__setRootView(vc.view)

  @property "readonly", "frame",
    get:

  isLong: () -> this.width <= this.height
  isWide: () -> !this.isLong()

  __setRootView: (view) ->
   @_keyView = view
   CB.Renderer.sharedRenderer.renderRootViewForWindow(view, this)

  # pragma mark - window as subclass of CB.View

  layoutSubviews: () ->
