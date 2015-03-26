# This class represent the window of the app.
# In web environment, this class wraps around $("body").
# Similar to iOS, CB.Window is a subclass of CB.View
#
class CB.Window extends CB.View

  # The current window object.
  # This is the only current window.
  #
  @currentWindow: () ->
    @__current ||= new CB.Window
    return @__current

  # A window should have a root view controller.
  # The user event and relayout will be sent by the window to
  # the root view controller.
  #
  @property "rootViewController",
    get: -> @_rootViewController
    set: (vc) -> @_rootViewController = vc; this.__setRootView(vc.view)

  # Return true if window is long.
  #
  isLong: () -> this.frame.size.width <= this.frame.size.height

  # Return true if window is wide.
  #
  isWide: () -> !this.isLong()

  __setRootView: (view) ->
   @_rootView = view
   CB.Renderer.sharedRenderer.renderRootViewForWindow(view, this)

  # Deprecated
  @property "height",
    get: -> this.frame.size.height

  # Deprecated
  @property "width",
    get: -> this.frame.size.width

  # pragma mark - window as subclass of CB.View

  @property "readonly", "frame",
    get: ->
      new CB.Rect(0, 0, $(window.height()), $(window.width()))

  layoutSubviews: () ->
    @_rootView.frame = new CB.Rect(0, 0, this.width, this.height)

  layerDescription: () ->
    $("body")
